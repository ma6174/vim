#!/usr/bin/env python
#coding=utf-8
import markdown
import sys
if __name__=='__main__':
    in_file,out_file = sys.argv[1:]
    html = markdown.markdownFromFile(in_file,out_file,encoding='utf-8')
