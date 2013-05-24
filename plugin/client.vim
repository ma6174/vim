if !has('python')
  echo "Error: Required vim compiled with +python"
  finish
endif

"Needs to be set on connect, MacVim overrides otherwise"
function! SetCoVimColors ()
  :hi CursorUser gui=bold term=bold cterm=bold 
  :hi Cursor1 ctermbg=DarkRed ctermfg=White guibg=DarkRed guifg=White gui=bold term=bold cterm=bold 
  :hi Cursor2 ctermbg=DarkBlue ctermfg=White guibg=DarkBlue guifg=White gui=bold term=bold cterm=bold 
  :hi Cursor3 ctermbg=DarkGreen ctermfg=White guibg=DarkGreen guifg=White gui=bold term=bold cterm=bold 
  :hi Cursor4 ctermbg=DarkCyan ctermfg=White guibg=DarkCyan guifg=White gui=bold term=bold cterm=bold 
  :hi Cursor5 ctermbg=DarkMagenta ctermfg=White guibg=DarkMagenta guifg=White gui=bold term=bold cterm=bold 
  :hi Cursor6 ctermbg=Brown ctermfg=White guibg=Brown guifg=White gui=bold term=bold cterm=bold 
  :hi Cursor7 ctermbg=LightRed ctermfg=Black guibg=LightRed guifg=Black gui=bold term=bold cterm=bold 
  :hi Cursor8 ctermbg=LightBlue ctermfg=Black guibg=LightBlue guifg=Black gui=bold term=bold cterm=bold 
  :hi Cursor9 ctermbg=LightGreen ctermfg=Black guibg=LightGreen guifg=Black gui=bold term=bold cterm=bold 
  :hi Cursor10 ctermbg=LightCyan ctermfg=Black guibg=LightCyan guifg=Black gui=bold term=bold cterm=bold 
  :hi Cursor0 ctermbg=LightYellow ctermfg=Black guibg=LightYellow guifg=Black gui=bold term=bold cterm=bold 
endfunction
 
:python import vim
python << EOF

from twisted.internet.protocol import ClientFactory, Protocol
#from twisted.protocols.basic import LineReceiver
from twisted.internet import reactor
#from twisted.internet.interfaces import IReactorThreads
from threading import Thread
import json
import os
from time import sleep


# Check for Vundle/Pathogen
if os.path.exists(os.path.expanduser('~') + '/.vim/bundle/CoVim/plugin'):
  CoVimServerPath = '~/.vim/bundle/CoVim/plugin/server.py'
else:
  CoVimServerPath = '~/.vim/plugin/server.py'

class VimProtocol(Protocol):
  def __init__(self, fact):
    self.fact = fact
  def addUsers(self, list):
    for user_obj in list:
      if user_obj['name'] == self.fact.me:
        self.fact.colors[user_obj['name']] = ('CursorUser', 4000)
      else:
        self.fact.colors[user_obj['name']] = ('Cursor' + str(self.fact.color_count), self.fact.id_count)
        self.fact.id_count += 1
        self.fact.color_count = (self.fact.id_count-3)%11
        vim.command(':call matchadd(\''+self.fact.colors[user_obj['name']][0]+'\', \'\%'+ str(user_obj['cursor']['x']) + 'v.\%'+str(user_obj['cursor']['y'])+'l\', 10, ' + str(self.fact.colors[user_obj['name']][1])+ ')')
      self.refreshBuddyList()
  def remUser(self, name):
    vim.command('call matchdelete('+str(self.fact.colors[name][1]) + ')')
    del(self.fact.colors[name])
    self.refreshBuddyList()
  def refreshBuddyList(self):
    buddylist_window_width = int(vim.eval('winwidth(0)'))
    #TODO: Set Width to Autogrow with added/deleted users
    CoVim.buddylist[:] = ['']
    current_window_i = vim.eval('winnr()')
    x_a = 1
    line_i = 0
    vim.command("1wincmd w")
    for match_id in self.fact.buddylist_matches:
      vim.command('call matchdelete('+str(match_id) + ')')
    self.fact.buddylist_matches = []
    for name in self.fact.colors.keys():
      x_b = x_a + len(name)
      if x_b > buddylist_window_width:
        line_i += 1
        x_a = 1
        x_b = x_a + len(name)
        CoVim.buddylist.append('')
        vim.command('resize '+str(line_i+1))
      CoVim.buddylist[line_i] += name+' '
      self.fact.buddylist_matches.append(vim.eval('matchadd(\''+self.fact.colors[name][0]+'\',\'\%<'+str(x_b)+'v.\%>'+str(x_a)+'v\%'+str(line_i+1)+'l\',10,'+str(self.fact.colors[name][1]+2000)+')'))
      x_a = x_b + 1
    vim.command(str(current_window_i)+"wincmd w")
  def send(self, event):
      self.transport.write(event)
  def connectionMade(self):
    self.send(self.fact.me)
  def dataReceived(self, data_string):
    def to_utf8(d):
      if isinstance(d, dict):
        # no dict comprehension in python2.5/2.6
        d2 = {}
        for key, value in d.iteritems():
          d2[to_utf8(key)] = to_utf8(value)
        return d2
      elif isinstance(d, list):
        return map(to_utf8, d)
      elif isinstance(d, unicode):
        return d.encode('utf-8')
      else:
        return d

    def clean_data_string(d_s):
      bad_data = d_s.find("}{")
      if bad_data > -1:
        d_s = d_s[:bad_data+1]
      return d_s
      
    data_string = clean_data_string(data_string)
    packet = to_utf8(json.loads(data_string))
    if 'packet_type' in packet.keys():
      data = packet['data']
      if packet['packet_type'] == 'message':
        if data['message_type'] == 'error_newname_taken':
          CoVim.disconnect()
          print 'ERROR: Name already in use. Please try a different name'
        if data['message_type'] == 'error_newname_invalid':
          CoVim.disconnect()
          print 'ERROR: Name contains illegal characters. Only numbers, letters, underscores, and dashes allowed. Please try a different name'
        if data['message_type'] == 'connect_success':
          CoVim.setupWorkspace()
          if 'buffer' in data.keys():
            self.fact.buffer = data['buffer']
            vim.current.buffer[:] = self.fact.buffer
          self.addUsers(data['collaborators'])
          print 'Success! You\'re now connected [Port '+str(CoVim.port)+']'
        if data['message_type'] == 'user_connected':
          self.addUsers([ data['user'] ])
          print data['user']['name']+' connected to this document'
        if data['message_type'] == 'user_disconnected':
          self.remUser(data['name'])
          print data['name']+' disconnected from this document'
      if packet['packet_type'] == 'update':
        if 'buffer' in data.keys() and data['name'] != self.fact.me:
          b_data = data['buffer']
          self.fact.buffer = vim.current.buffer[:b_data['start']]   \
                             + b_data['buffer']                     \
                             + vim.current.buffer[b_data['end']-b_data['change_y']+1:]
          vim.current.buffer[:] = self.fact.buffer
        if 'updated_cursors' in data.keys():
          # We need to update your own cursor as soon as possible, then update other cursors after
          for updated_user in data['updated_cursors']:
            if self.fact.me == updated_user['name'] and data['name'] != self.fact.me:
              vim.current.window.cursor = (updated_user['cursor']['y'], updated_user['cursor']['x']) 
          for updated_user in data['updated_cursors']:
            if self.fact.me != updated_user['name']:
              vim.command(':call matchdelete('+str(self.fact.colors[updated_user['name']][1]) + ')')
              vim.command(':call matchadd(\''+self.fact.colors[updated_user['name']][0]+'\', \'\%'+ str(updated_user['cursor']['x']) + 'v.\%'+str(updated_user['cursor']['y'])+'l\', 10, ' + str(self.fact.colors[updated_user['name']][1])+ ')')
        #data['cursor']['x'] = max(1,data['cursor']['x'])
        #print str(data['cursor']['x'])+', '+str(data['cursor']['y'])
      vim.command(':redraw')

class VimFactory(ClientFactory):
  def __init__(self, name):
    self.id_count = 4
    self.setup(name)
  def setup(self, me=False):
    if me:
      self.me = me
    self.buddylist_matches = []
    self.colors = {}
    self.color_count = 1
    self.buffer = []
  def buildProtocol(self, addr):
    self.p = VimProtocol(self)
    return self.p
  def startFactory(self):
    self.isConnected = True
  def stopFactory(self):
    self.isConnected = False
  def buff_update(self):
    d = {
      "packet_type":"update",
      "data": {
        "cursor": {
          "x":max(1, vim.current.window.cursor[1]),
          "y":vim.current.window.cursor[0]
        },
        "name":self.me
      }
    }
    d = self.create_update_packet(d)
    data = json.dumps(d)
    self.p.send(data)
  def cursor_update(self):
    d = {
      "packet_type":"update",
      "data": {
        "cursor": {
          "x":max(1, vim.current.window.cursor[1]+1),
          "y":vim.current.window.cursor[0]
        },
        "name":self.me
      }
    }
    d = self.create_update_packet(d)
    data = json.dumps(d)
    self.p.send(data)
  def create_update_packet(self, d):
    current_buffer = vim.current.buffer[:]
    if current_buffer != self.buffer:
      cursor_y = vim.current.window.cursor[0] - 1
      change_y = len(current_buffer) - len(self.buffer)
      change_x = 0
      if len(self.buffer) > cursor_y-change_y and cursor_y-change_y >= 0 \
        and len(current_buffer) > cursor_y and cursor_y >= 0:
        change_x = len(current_buffer[cursor_y]) - len(self.buffer[cursor_y-change_y])
      limits = {
        'from': max(0,cursor_y-abs(change_y)),
        'to': min(len(vim.current.buffer)-1, cursor_y+abs(change_y))
      }
      d_buffer = {
        'start' : limits['from'],
        'end'   : limits['to'],
        'change_y' : change_y,
        'change_x' : change_x,
        'buffer': vim.current.buffer[limits['from']:limits['to']+1],
        'buffer_size': len(current_buffer)
      }
      d['data']['buffer'] = d_buffer
      self.buffer = current_buffer
    return d;
  def clientConnectionLost(self, connector, reason):
    #THIS IS A HACK
    if hasattr(CoVim, 'buddylist'):
      CoVim.disconnect()
      print 'Lost connection.'
  def clientConnectionFailed(self, connector, reason):
    CoVim.disconnect()
    print 'Connection failed.' 

class CoVimScope:
  #def __init__(self):
  def initiate(self, addr, port, name):
    #Check if connected. If connected, throw error.
    if hasattr(self, 'fact') and self.fact.isConnected:
      print 'ERROR: Already connected. Please disconnect first'
      return
    if not port and hasattr(self, 'port') and self.port:
      port = self.port
    if not addr and hasattr(self, 'addr') and self.addr:
      addr = self.addr
    if not addr or not port or not name:
      print 'Syntax Error: Use form :Covim connect <server address> <port> <name>'  
      return
    port = int(port)
    addr = str(addr)
    if not hasattr(self, 'connection'):
      self.addr = addr
      self.port = port
      self.fact = VimFactory(name)
      self.connection = reactor.connectTCP(addr, port, self.fact)
      self.reactor_thread = Thread(target=reactor.run, args=(False,))
      self.reactor_thread.start()
      vim.command('autocmd VimLeave * py CoVim.quit()')
    elif (hasattr(self, 'port') and port != self.port) or (hasattr(self, 'addr') and addr != self.addr):
      print 'ERROR: Different address/port already used. To try another, restart Vim'
      return
    else:
      self.fact.setup(name)
      self.connection.connect()
      print 'Reconnecting...'
      return
    #if first time run, setup
    #if not connected, reconnect
    print 'Connecting...'
  def setupWorkspace(self):
    vim.command('call SetCoVimColors()')
    vim.command(':autocmd!')
    vim.command('autocmd CursorMoved * py CoVim.cursor_update()')
    vim.command('autocmd CursorMovedI * py CoVim.buff_update()')
    vim.command("1new +setlocal\ stl=%!'CoVim-Collaborators'")
    self.buddylist = vim.current.buffer
    self.buddylist_window = vim.current.window
    vim.command("wincmd j")
  def command(self, arg1=False, arg2=False, arg3=False, arg4=False):
    if arg1=="connect":
      if arg2 and arg3 and arg4:
        self.initiate(arg2, arg3, arg4)
      else:
        print "usage :CoVim connect [host address] [port] [your name]"
    elif arg1=="disconnect":
      self.disconnect()
    elif arg1=="start":
      if arg2 and arg3:
        self.createServer(arg2, arg3)
      else:
        print "usage: CoVim start [port] [your name]"
    else:
      print "usage: CoVim [start] [connect] [disconnect]"
  def createServer(self, port, name):
    vim.command(':silent execute "!'+CoVimServerPath+' '+port+' &>/dev/null &"')
    sleep(0.4)
    self.initiate('localhost', port, name)
  def buff_update(self):
    reactor.callFromThread(self.fact.buff_update)
  def cursor_update(self):
    reactor.callFromThread(self.fact.cursor_update)
  def disconnect(self):
    if hasattr(self,'buddylist'):
      vim.command("1wincmd w")
      vim.command("q!")
      self.fact.buddylist_matches = []
      for name in self.fact.colors.keys():
        if name != self.fact.me:
          vim.command(':call matchdelete('+str(self.fact.colors[name][1]) + ')')
      del(self.buddylist)
    if hasattr(self,'buddylist_window'):
      del(self.buddylist_window)
    reactor.callFromThread(self.connection.disconnect)
    print 'Successfully disconnected from document!'
  def quit(self):
    reactor.callFromThread(reactor.stop)


CoVim = CoVimScope()
EOF

com! -nargs=+ CoVim py CoVim.command(<f-args>)
