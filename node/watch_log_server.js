var spawn = require('child_process').spawn;
var tail = spawn("tail", ['-f', '/logs/php_errors.log']);
tail.stdout.setEncoding('utf8')
console.log('starting');

var ws = require('websocket-server');
var server = ws.createServer();
server.addListener('connection', function(connection) {
	tail.stdout.on('data', function(data) {
		server.broadcast(data);
	});
});

server.listen(8001, '127.0.0.1');
