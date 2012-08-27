#!/usr/bin/env python
#coding=utf-8
import urllib
import json
#ret = '''{"translation":["苹果"],"basic":{"phonetic":"'æpl","explains":["n. 苹果；家伙"]},"query":"apple","errorCode":0,"web":[{"value":["苹果","苹果公司","苹果汁","美国苹果"],"key":"Apple"},{"value":["苹果电脑","苹果电脑公司","苹果计算机","苹果公司"],"key":"Apple Computer"},{"value":["苹果公司","苹果","果公司","苹果股份有限公司"],"key":"Apple Inc"},{"value":["大苹果","纽约","大苹果城","纽约的别称"],"key":"big apple"},{"value":["苹果皮"],"key":"apple skin"},{"value":["苹果馅饼","苹果饼","苹果排","苹果蛋糕"],"key":"apple tart"},{"value":["苹果日报","韩版恶作之吻造型曝光"],"key":"Apple Daily"},{"value":["垫脚箱","因在早期电影制作中"],"key":"APPLE BOXES"},{"value":["炸苹果饼"],"key":"apple fritter"},{"value":["查拉尔·阿佩尔","阿佩尔","由查拉尔阿"],"key":"Gerald Apple"}]}'''
def dealjson(ret):
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

def youdao(word):
    word = urllib.quote(word)
    print word
    url = 'http://fanyi.youdao.com/openapi.do?keyfrom=ACM-OnlineJudge&key=2091830782&type=data&doctype=json&version=1.1&q='+word
    ret = urllib.urlopen(url).read()
    dealjson(ret)


if __name__=='__main__':
    while True:
        word = raw_input('input: ')
        if word == '':
            continue
        word = urllib.quote(word)
        print word
        url = 'http://fanyi.youdao.com/openapi.do?keyfrom=ACM-OnlineJudge&key=2091830782&type=data&doctype=json&version=1.1&q='+word
        ret = urllib.urlopen(url).read()
        dealjson(ret)

