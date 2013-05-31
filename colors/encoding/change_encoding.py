#!/usr/bin/env python
# coding=utf-8
'''
转换配置文件编码，将windows下的"\r\n"替换成"\n"
'''
import os
for i in os.listdir("./"):
    if i.endswith(".vim"):
        han = open(i)
        data = han.read().replace("\r\n", "\n")
        han.close()
        han = open(i, 'w')
        han.write(data)
        han.close()
