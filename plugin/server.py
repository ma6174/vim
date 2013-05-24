#!/usr/bin/env python2

from twisted.internet.protocol import Factory, Protocol
#from twisted.protocols.basic import LineReceiver
from twisted.internet import reactor
import json
import sys, re

def name_validate(strg, search=re.compile(r'[^0-9a-zA-Z\-\_]').search):
  return not bool(search(strg))

class React(Protocol):
  def __init__(self, factory):
    self.factory = factory
    self.state = "GETNAME"
  def dataReceived(self, data):
    if self.state == "GETNAME":
      self.handle_GETNAME(data)
    else:
      self.handle_BUFF(data)
  def handle_GETNAME(self, name):
    # Handle duplicate name 
    if userManager.has_user(name):
      d = {
        'packet_type':'message',
        'data': {
          'message_type':'error_newname_taken'
        }
      }
      self.transport.write(json.dumps(d))
      return
    # Handle spaces in name
    if not name_validate(name):
      d = {
        'packet_type':'message',
        'data': {
          'message_type':'error_newname_invalid'
        }
      }
      self.transport.write(json.dumps(d))
      return
    # Name is Valid, Add to Document
    self.user = User(name, self)
    userManager.add_user(self.user)
    self.state = "CHAT"
    d = {
      'packet_type':'message',
      'data': {
        'message_type':'connect_success',
        'name':name,
        'collaborators':userManager.all_users_to_json()
      }
    }
    if userManager.is_multi():
      d['data']['buffer'] = self.factory.buff 
    self.transport.write(json.dumps(d))
    print 'User "'+self.user.name+'" Connected'
    # Alert other Collaborators of new user
    d = {
      'packet_type':'message',
      'data': {
        'message_type':'user_connected',
        'user':self.user.to_json()
      }
    }
    self.user.broadcast_packet(d)

  def handle_BUFF(self, data_string):
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
    d = to_utf8(json.loads(data_string))
    data = d['data']
    update_self = False
    if 'cursor' in data.keys():
      user = userManager.get_user(data['name'])
      user.update_cursor(data['cursor']['x'], data['cursor']['y'])
      d['data']['updated_cursors'] = [user.to_json()]
      del d['data']['cursor']
    if 'buffer' in data.keys():
      b_data = data['buffer']
      #TODO: Improve Speed: If change_y = 0, just replace that one line
      #print ' \\n '.join(self.factory.buff[:b_data['start']])
      #print ' \\n '.join(b_data['buffer'])
      #print ' \\n '.join(self.factory.buff[b_data['end']-b_data['change_y']+1:])
      self.factory.buff = self.factory.buff[:b_data['start']]   \
                          + b_data['buffer']                    \
                          + self.factory.buff[b_data['end']-b_data['change_y']+1:]
      d['data']['updated_cursors'] += userManager.update_cursors(b_data, user)
      update_self = True
    self.user.broadcast_packet(d, update_self)

  #def connectionMade(self):

  def connectionLost(self, reason):
    if hasattr(self, 'user'):
      userManager.rem_user(self.user)
      if userManager.is_empty():
        print 'All users disconnected. Shutting down...'
        reactor.stop()

class ReactFactory(Factory):
  def __init__(self):
    self.buff = []
  def initiate(self, port):
    self.port = port
    print 'Now listening on port '+str(port)+'...'
    reactor.listenTCP(port,self)
    reactor.run()
  def buildProtocol(self, addr):
    return React(self) 


class Cursor:
  def __init__(self):
    self.x = 1
    self.y = 1

  def to_json(self):
    return {
      'x': self.x,
      'y': self.y
    }


class User:
  def __init__(self, name, protocol):
    self.name = name
    self.protocol = protocol
    self.cursor = Cursor()

  def to_json(self):
    return {
      'name': self.name,
      'cursor': self.cursor.to_json()
    }

  def broadcast_packet(self, obj, send_to_self = False):
    obj_json = json.dumps(obj)
    #print obj_json
    for name, user in userManager.users.iteritems():
      if user.name != self.name or send_to_self:
        user.protocol.transport.write(obj_json)
        #TODO: don't send yourself your own buffer, but del on a copy doesn't work

  def update_cursor(self, x, y):
    self.cursor.x = x
    self.cursor.y = y


class UserManager:
  def __init__(self):
    self.users = {}
  
  def is_empty(self):
    return len(self.users)==0
  
  def is_multi(self):
    return len(self.users)>1
  
  def has_user(self, search_name):
    return self.users.has_key(search_name)
  
  def add_user(self,u):
    self.users[u.name] = u
  
  def get_user(self, u_name):
    try:
      return self.users[u_name]
    except KeyError:
      raise Exception('user doesnt exist')

  def rem_user(self, user):
    if self.users.has_key(user.name):
      d = {
        'packet_type':'message',
        'data': {
          'message_type':'user_disconnected',
          'name':user.name
        }
      }
      user.broadcast_packet(d)
      print 'User "'+user.name+'" Disconnected'
      del self.users[user.name]

  def all_users_to_json(self):
    return_arr = []
    for name, user in userManager.users.iteritems():
      return_arr.append(user.to_json())
    return return_arr

  def update_cursors(self, buffer_data, u):
    return_arr = []
    y_target = u.cursor.y
    x_target = u.cursor.x
    for name, user in userManager.users.iteritems():
      updated = False
      if user != u:
        if user.cursor.y > y_target:
          user.cursor.y += buffer_data['change_y']
          updated = True
        if user.cursor.y == y_target and user.cursor.x > x_target:
          user.cursor.x = max(1, user.cursor.x+buffer_data['change_x'])
          updated = True
        if user.cursor.y == y_target-1 and user.cursor.x > x_target and buffer_data['change_y']==1:
          user.cursor.y += 1
          user.cursor.x = max(1, user.cursor.x+buffer_data['change_x'])
          updated = True
        #TODO: If the line was just split?
        if updated:
          return_arr.append(user.to_json())
    return return_arr




userManager = UserManager()

if __name__ == '__main__':
  Server = ReactFactory()
  Server.initiate(int(sys.argv[1]))
