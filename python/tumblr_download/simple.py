#!/usr/local/bin/python
# -*- coding: utf-8 -*-

# center.py

import wx
import pytumblr
import json

class Example(wx.Frame):

    def __init__(self, parent, title):    
        super(Example, self).__init__(parent, title=title, 
            size=(450, 300))

        self.InitUI()
        self.Centre()
        self.Show()     

    def InitUI(self):
      
        panel = wx.Panel(self)
        
        sizer = wx.GridBagSizer(5, 5)

        text1 = wx.StaticText(panel, label="Tumblr 图片|视频 下载")
        sizer.Add(text1, pos=(0, 0), flag=wx.TOP|wx.LEFT|wx.BOTTOM, 
            border=15)


        line = wx.StaticLine(panel)
        sizer.Add(line, pos=(1, 0), span=(1, 5), 
            flag=wx.EXPAND|wx.BOTTOM, border=10)

        text1 = wx.StaticText(panel, label="博客名称")
        sizer.Add(text1, pos=(2, 0), flag=wx.LEFT, border=10)
        self.tc1 = wx.TextCtrl(panel)
        sizer.Add(self.tc1, pos=(2, 1), span=(1, 3), flag=wx.TOP|wx.EXPAND)

        text2 = wx.StaticText(panel, label="存储路径")
        sizer.Add(text2, pos=(3, 0), flag=wx.LEFT|wx.TOP, border=10)
        self.tc2 = wx.TextCtrl(panel)
        sizer.Add(self.tc2, pos=(3, 1), span=(1, 3), flag=wx.TOP|wx.EXPAND, 
            border=5)

        button1 = wx.Button(panel, label="选择...")
        sizer.Add(button1, pos=(3, 4), flag=wx.TOP|wx.RIGHT, border=5)

        #sb = wx.StaticBox(panel, label="可选项")

        #boxsizer = wx.StaticBoxSizer(sb, wx.VERTICAL)
        #boxsizer.Add(wx.CheckBox(panel, label="按类型存储"), 
            #flag=wx.LEFT|wx.TOP, border=5)
        #boxsizer.Add(wx.CheckBox(panel, label="Generate Default Constructor"),
        #    flag=wx.LEFT, border=5)
        #boxsizer.Add(wx.CheckBox(panel, label="Generate Main Method"), 
        #    flag=wx.LEFT|wx.BOTTOM, border=5)
        #sizer.Add(boxsizer, pos=(5, 0), span=(1, 5), 
        #    flag=wx.EXPAND|wx.TOP|wx.LEFT|wx.RIGHT , border=10)


        button2 = wx.Button(panel, label="帮助")
        sizer.Add(button2, pos=(8, 3), span=(1, 1),  
                        flag=wx.BOTTOM|wx.RIGHT, border=5)

        button3 = wx.Button(panel, label="下载")
        sizer.Add(button3, pos=(8, 4), span=(1, 1),  
                        flag=wx.BOTTOM|wx.RIGHT, border=5)

        sizer.AddGrowableCol(2)
        
        panel.SetSizer(sizer)

        self.Bind(wx.EVT_BUTTON,  self.OnDir, id=button1.GetId())
        self.Bind(wx.EVT_BUTTON,  self.OnDownload, id=button3.GetId())

    def OnDir(self, e):
        dlg = wx.DirDialog(self, "选择目录", 
                style=wx.DD_DEFAULT_STYLE
                )
        if dlg.ShowModal() == wx.ID_OK:
            print "You choose %s" % dlg.GetPath()
            #print self.GetChildren().GetChildren()
            self.tc2.SetValue(dlg.GetPath())

        dlg.Destroy()

    def OnDownload(self, e):
        bloggerName = self.tc1.GetValue()
        client = pytumblr.TumblrRestClient(
                    'Mrh5bNbP2HJJoMtQVjaKe7Ma08cDr6Jp52lbX7xvsACm2buEFB',
                    'uwmYCeMrCefYHz8wA6YPbJgpwOZUBzj84BQDhz3BVWFgQkj054'
                )
        info = client.blog_info(bloggerName)
        total = json.loads(info)
        print total

if __name__ == '__main__':
  
    app = wx.App()
    Example(None, title="tumblr下载器")
    app.MainLoop()
