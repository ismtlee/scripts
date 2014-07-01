var sys = require('sys')
var filename = process.argv[2];

if(!filename) {
	return sys.puts("Usage: node watchLog.js filename");
}

var child = require('child_process').spawn("tail", ["-f", filename]);
sys.puts("start tailing");
child.stdout.addListener("data", function (chunk) {
	sys.puts(chunk);
});

var http = require("http");
http.createServer(function (req, res) {
	res.writeHead(200, {"Content-Type": "text/plain"});
	child.stdout.addListener("data", function (chunk) {
		res.writeContinue(chunk);	
	});
}).listen(8000);
