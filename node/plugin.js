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

function execCmd(req, res, shFile, tip) {
  var spawn = require('child_process').spawn;
  var cmd = spawn("/bin/sh", [shFile]);
  res.writeHead(200, {"Content-Type": "text/plain; charset=UTF-8"});
  cmd.stdout.on("data", function (chunk) {
    res.write(chunk);
  });
  cmd.stderr.on("data", function (chunk) {
    res.write(chunk);
  });
  cmd.on('close', function(code) {
    res.write(tip);
    res.end();
  });

}

function execCmdArg(req, res, shFile, arg, tip) {
  var  exec = require('child_process').exec;
  var cmd = exec('sh ' + shFile + ' ' + arg);
  res.writeHead(200, {"Content-Type": "text/plain; charset=UTF-8"});
  cmd.stdout.on("data", function (chunk) {
    res.write(chunk);
  });
  cmd.stderr.on("data", function (chunk) {
    res.write(chunk);
    res.write("Something wrong, plz have a check ...\n");
  });
  cmd.on('close', function(code) {
    res.write(tip);
    res.end();
  });

}

http.createServer(function (req, res) {
  var uri = url.parse(req.url).pathname;
 
  switch(uri) {
    case '/plugin':
      execCmdArg(req, res, 'scripts/run.sh', 'all', 'apk插件注入完毕!');
      break;
    //http://localhost:port/pkg?olddir=com.macropinch.pearl_130043&newpkg=com.a.b
    case '/pkg':
      //execCmdArg(req, res, 'run.sh', 'all', 'apk插件注入完毕!');
      pkgname = url.parse(req.url, true).query
      arg = pkgname.olddir + ' ' + pkgname.newpkg;
      execCmdArg(req, res, 'scripts/pkg.sh', arg, '');
      console.log(pkgname);
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
