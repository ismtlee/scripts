#!/usr/local/bin/python
# -*- coding: utf-8 -*-

# main.py

import sys
import os
import re
import struct
import base64

def parseRequest(request):
  #解析request
  #print(request)
  rs = {}
  unknown = "_"
  if request:
    params = request.split("&")
    if params:
      for i in params:
        param = i.split("=", 1)  
        if param:
          rs[param[0]] = param[1]
    else:
      return rs
  else:
    return rs 
  return(rs['appid'] if 'appid' in rs else unknown, 
         rs['country'] if 'country' in rs else unknown,
         rs['lang'] if 'lang' in rs else unknown,
         rs['model'] if 'model' in rs else unknown,
         rs['package'] if 'package' in rs else unknown,
         rs['uuid'] if 'uuid' in rs else unknown,
         rs['version'] if 'version' in rs else unknown,
         rs['ios'] if 'ios' in rs else unknown)

def parseLine(line):
    ip = r"?P<ip>[\d.]*"
    method = r"?P<method>\S+"
    #request = r"?P<request>/\?appid=\S+"
    request = r"?P<request>appid=\S+"
    p = re.compile(r"(%s)\ -\ -\ \[.*\]\ \"(%s)[\s]/\?(%s)"%(ip, method, request), re.VERBOSE)
    return re.findall(p, line)

def cutlogs():
  with open("nginx.log", "r") as file:
    for line in file:
      m = parseLine(line)
      if m: 
        ip = m[0][0]
        request = m[0][2]
        (appid, country, lang, model, package, uuid, version, ios) = parseRequest(request)
        parseRequest(request)
        newline = "%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n"%(ip, appid, country, lang, model, package, uuid, version, ios)
        with open("raws.log", "a") as newfile:
            newfile.write(newline)


def main():
  cutlogs()

if __name__ == '__main__':
  main()
