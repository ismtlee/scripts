console.log('hello from me')
var sys = require('sys')

var filename = process.argv[2];
if(!filename) {
   return sys.puts("Usage: node watchLog.js filename");
}

var child = require('child_process').spawn("tail", ["-f", filename])

child.stdout.addListener('data', function (data) {
	//require('util').print(data)
	//process.stdout.write(data)
	sys.puts(data)
})

child.stderr.addListener('data', function (data) {
	require('util').print(data)
})
