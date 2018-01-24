#!/usr/local/bin/python
# -*- coding: utf-8 -*-

# main.py

import sys
import os
import re
import struct
import base64

def parseRequest(rqst):
  param = r"?P<param>.*"
  p = re.compile(r"/\?(%s)" %param, re.VERBOSE)
  return re.findall(p, rqst)

def parseLine(line):
    ip = r"?P<ip>[\d.]*"
    method = r"?P<method>\S+"
    request = r"?P<request>/\?appid=\S+"
    p = re.compile(r"(%s)\ -\ -\ \[.*\]\ \"(%s)[\s](%s)"%(ip, method, request), re.VERBOSE)
    return re.findall(p, line)
    #p = re.match(r"(%s)\ -\ -\ \[.*\]\ \"(%s)[\s](%s)"%(ip, method, request), line)
    #return p.group() 
    #print(p.group())

def cutlogs():
  with open('test.log') as file:
    for line in file:
      m = parseLine(line)
      #print(m)
      if m: 
        #p = parseParam(m[0])
        print(m[0][2])

def main():
  cutlogs()

if __name__ == '__main__':
  main()
