var http    = require('http'),
    io      = require('socket.io'),
    fs      = require('fs');

const port = 8008;
var spawn = require('child_process').spawn;

//var filename = process.argv[2];
//if (!filename) return console.log("Usage: node <server.js> <filename>");

// -- Node.js Server ----------------------------------------------------------

server = http.createServer(function(req, res){
  res.writeHead(200, {'Content-Type': 'text/html'})
  fs.readFile(__dirname + '/index.html', function(err, data){
  	res.write(data, 'utf8');
  	res.end();
  });
})
server.listen(port, '0.0.0.0');

// -- Setup Socket.IO ---------------------------------------------------------

var io = io.listen(server);

io.on('connection', function(client){
  console.log('Client connected');
  //var tail = spawn("tail", ["-f", filename]);
  //client.send( { filename : filename } );

 // tail.stdout.on("data", function (data) {
  //  console.log(data.toString('utf-8'))
   // client.send( { tail : data.toString('utf-8') } )
  //}); 

  client.on('svnup', function(data) {
   console.log('svn up');
   execCmd('/home/build/update.sh', client);
  });

  client.on('pkg', function(data) {
   console.log('pkg');
   arg = data.apptype + ' ' + data.appid + '  ' + data.pkg;
   execCmdArg('pkg.sh', client, arg);
  });

});

function execCmd(shFile, socket) {
  var spawn = require('child_process').spawn;
  var cmd = spawn("/bin/sh", [shFile]);
  cmd.stdout.on("data", function (data) {
    socket.send({ tail : data.toString('utf-8') });
  });
  cmd.stderr.on("data", function (data) {
    socket.send({ tail : data.toString('utf-8') });
  });
  cmd.on('close', function(data) {//脚本执行完
     socket.send({ result : 1 });
  });
}

function execCmdArg(shFile, socket, arg) {
  var  exec = require('child_process').exec;
  var cmd = exec('sh ' + shFile + ' ' + arg);
  cmd.stdout.on("data", function (data) {
    socket.send({ tail : data.toString('utf-8') });
  });
  cmd.stderr.on("data", function (data) {
    socket.send({ tail : data.toString('utf-8') });
  });
  cmd.on('close', function(data) {//脚本执行完
     socket.send({ result : 1 });
  });

}

console.log('Server running at http://0.0.0.0:' + port);
