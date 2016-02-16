var superagent = require('superagent')
var observe = require('observe.js')
var cheerio = require('cheerio')
var path = require('path')
var url = require('url')
var fs = require('fs')
var YAML = require('yamljs')

function loadYAMLFile (file) {
      return YAML.parse(fs.readFileSync(file).toString());
}

var config = loadYAMLFile('./config.yaml');
console.log(config);
console.log(config.sites[0]);

//以同步的方式：判断是否存在这个文件夹，不存在才创建
if (!fs.existsSync('postList')) {
    fs.mkdirSync('postList')
}
//获取当前路径，方便读写目录跟文件
var cwd = process.cwd()

//reptile 的意思是爬行动物、卑鄙的人。
//爬别人的内容，有点卑鄙的意味
var reptile = observe({})

//observe过的对象，有on off once hold collect tie等方法
//这里只用了on，根据属性名添加侦听函数
//用法跟jQuery.on类似，可以是对象批量侦听，可以逐个侦听reptile.on('url', callback)
reptile.on({
    //根据 url ，获取 text
    url: function(url) {
        var that = this
        console.log(url)
        //get方法发出请求，query方法为url添加query字段（url问号背后的）
        //end方法接受回调参数，html一般在res.text中
        console.log(this.query)
        superagent
            .get(url)
            .accept('json')
            //.query(this.query)
            .end(function(err, res) {
                if (res.ok) {
                    //赋值给reptile.text，就会触发回调
                    //console.log(res.text)
                    that.text = res.text
                }
            })
    },
    //触发的回调函数在这里
    text: function(text) {
        var that = this
        //cheerio 的 load 方法返回的对象，拥有与jQuery相似的API
        var $ = cheerio.load(text)
        var postList = []
        //根据html结构，筛选所需部分
        //这个页面我们只要标题跟对应的url
        $('h2.title a').each(function() {
                postList.push({
                    title: $(this).text(),
                    url: path.join(url.parse(that.url).hostname, $(this).attr('href'))
                })
            })
        //赋值就触发回调
        this.postList = postList
        this.postItem = postList.shift()
    },
    //在这个回调里发出每一篇文章的请求
    postItem: function(postItem) {
        console.log(postItem.url)
        var that = this
        superagent
            .get(postItem.url)
            .end(function(err, res) {
                if (res.ok) {
                    //我们在这里构造filename，指定了具体路径
                    that.content = {
                        filename: path.join(cwd, 'postList', postItem.title + '.txt'),
                        title: postItem.title,
                        text: res.text
                    }
                } else {
                    console.log(res)
                }
            })
    },
    
    test: function(test) {

              console.log(test)
    }, 

    //在这里处理每篇文章的具体内容
    content: function(content) {
        var that = this
        var $ = cheerio.load(content.text)
        var data = ''
        //根据html结构选取正文，只要text部分，去掉html标签
        $('.article *').each(function() {
                data += $(this).text() + '\n'
            })
        //前面已经构造好了文件路径，直接写入即可
        fs.writeFile(content.filename, data, function(err) {
            if (err) {
                console.log(err)
            } else if (that.postList.length) {
                //写入完毕后，检查postList还有没有剩余
                //若有，取出来赋值给postItem，又goto到请求文章的步骤
                that.postItem = that.postList.shift()
            }
        })
    }
})

//reptile.url = 'http://segmentfault.com/blogs/recommend'
reptile.url = 'http://segmentfault.com/blogs'
reptile.query = 'page=3'
