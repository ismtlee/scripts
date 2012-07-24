var http = require("http"),
url = require("url");

function index(req, res) {
  var path = require("path"),
  fs = require("fs");
  var filename = path.join(process.cwd(), '/index.html');
  fs.readFile(filename, "binary", function(err, file) {
    if(err) {
      res.writeHead(500, {"Content-Type": "text/plain"});
      res.end(err + "\n");
      return;
    }
      res.writeHead(200);
      res.end(file, "binary");
  });
}

function execCmd(req, res, shFile, arg, tip) {
  //var spawn = require('child_process').spawn;
  //var cmd = spawn("/bin/sh", [shFile]);
  var  exec = require('child_process').exec;
  var cmd = exec('sh ' + shFile + ' ' + arg);
  res.writeHead(200, {"Content-Type": "text/plain; charset=UTF-8"});
  cmd.stdout.on("data", function (chunk) {
    res.write(chunk);
  });
  cmd.stderr.on("data", function (chunk) {
    res.write(chunk);
  });
  cmd.on('exit', function(code) {
    //console.log("end....");
    res.write(tip);
    res.end();
  });

}

http.createServer(function (req, res) {
  var uri = url.parse(req.url).pathname;
 
  switch(uri) {
    case '/load':
      //execCmd(req, res, 'loadGame.sh', '亲，数据已经加载并生效了!');
      break;
    case '/andwall':
    case '/applist':
      execCmd(req, res, 'svnup.sh', uri, '亲，' + uri + '代码已更新完毕!');
      break;
    default:
      index(req, res);
     break;
  } 
	
/*
        cmd1.stdout.addListener("data", function (chunk) {
                res.write(chunk);
        });
	cmd1.stderr.addListener("data", function (chunk) {
                res.write(chunk);
        });
*/	
}).listen(8000);
