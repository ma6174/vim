"translate.vim
"author      : sowill
"email       : sowill@gmail.com
"description : translate the english word that under cursor to chinese
"usage       : put cursor on the english word , then type :Trans , 
"              or in Visual-mode type :TransV ,
"I map the :Trans and :TransV to <Space>,just like 
"nnoremap <Space> :Trans<CR>
"vnoremap <Space> <ESC>:TransV<CR>
"in .vimrc files.
"Now,Visual-mode only support 'v' and 'V','<C-V>' will be
"treated same as 'v' mode
"Install     : just drop it to your plugin directory.

function! Translate_google(text)
python << EOF
from urllib2 import urlopen
from urllib import urlencode
import vim

def Translate_unicode(text):
    str=text
    while str.find("\u0026#39;")>=0:
        start_index=str.find("\u0026#39;")
        end_index=start_index+10
        unicode_str='\''
        str=str[:start_index]+unicode_str+str[end_index:]
        while str.find("\u")>=0:
            start_index=str.find("\u")
            end_index=start_index+6
            unicode_str=str[start_index+2:end_index]
            unicode_str=unichr(int(unicode_str,16)).decode('utf8').encode(vim.eval("&encoding"))
            str=str[:start_index]+unicode_str+str[end_index:]
            return str

def Trans_word2(word):
    if not word:
        print 'be sure there is word under cursor'
        return
    from_lang='en'
    to_lang='zh-CN'
    langpair='%s|%s'%(from_lang,to_lang)
    base_url='http://ajax.googleapis.com/ajax/services/language/translate?'
    params=urlencode( (('v',1.0),
                       ('q',word),
                       ('langpair',langpair),) )
    url=base_url+params
    content=urlopen(url).read()
    start_idx=content.find('"translatedText":"')+18
    translation=content[start_idx:]
    end_idx=translation.find('"}, "')
    translation=translation[:end_idx]
    print(Translate_unicode(translation).decode('utf-8').encode(vim.eval("&encoding"))) 

def Trans_word(word):
    import json
    import urllib
    #    word = raw_input('input: ')
    if word == '':
        print 'NULL'
    word = urllib.quote(word)
    print word
    url = 'http://fanyi.youdao.com/openapi.do?keyfrom=ACM-OnlineJudge&key=2091830782&type=data&doctype=json&version=1.1&q='+word
    ret = urllib.urlopen(url).read()
    ret = json.loads(ret)
    error = ret['errorCode']
    print error
    if error == 20:
        print '要翻译的文本过长'
    elif error == 30:
        print '无法进行有效的翻译'
    elif error == 40:
        print '不支持的语言类型'
    elif error == 50:
        print '无效的key'
    elif error == 0:
        trans = ret['translation']
        for i in trans:
            print i
        print ret['query']
        if 'basic' in ret.keys():
            explain =  ret['basic']['explains']
            for i in explain:
                print i
            web =ret['web']
            for i in web:
                print i['key'],
                for j in i['value']:
                    print j,
                print 


Trans_word(vim.eval("a:text"))
EOF
endfunction

func! Translate_GetVisual() range
let firstcol= col("'<")
let lastcol= col("'>")
let firstline = line("'<")
let lastline = line("'>")
let str =''
if firstline == lastline 
let ll  = getline(firstline)
let str = strpart(ll,firstcol-1,lastcol-firstcol)
    else		
    let lcount=firstline+1
    let lines = []
    let ll  = strpart(getline(firstline),firstcol-1)
    call add(lines,ll)
    while lcount<lastline
    let ll=getline(lcount)
    call add(lines,ll)
    let lcount+=1
    endw
    let ll=strpart(getline(lcount),0,lastcol-1)
    call add(lines,ll)
    let str=join(lines,"\n")
    endif
    return str
endf

command! -nargs=0 Trans :call Translate_google(eval("expand('<cword>')"))
command! -nargs=0 TransV :call Translate_google(Translate_GetVisual())
