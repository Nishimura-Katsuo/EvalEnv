"use strict";
const cluster = require('cluster');

if (cluster.isMaster) {
	cluster.fork();
	cluster.on('exit', () => {
		console.log('Eval process died; restarting...');
		cluster.fork();
	});
} else {
	const fs = require('fs');
	const cp = require('child_process');
	const websocket = require('ws');
	let httpServer;

	try {
		httpServer = require('https').createServer({
			ca: fs.readFileSync('cert/server.ca-bundle'),
			key: fs.readFileSync('cert/server.key'),
			cert: fs.readFileSync('cert/server.crt'),
		});
	} catch (err) {
		httpServer = require('http').createServer();
	}

	const server = new websocket.Server({ server: httpServer });
	let evalcount = 0, tmpfilename = () => '/tmp/eval' + (++evalcount);
	server.on('connection', ws => {
		ws.on('message', data => {
			try {
				data = JSON.parse(data);

				if (data && data.program && data.data) {
					let cmdline = `/var/eval/cmds/${data.program}.sh`;
					fs.stat(cmdline, (err, stats) => {
						if (!err && stats.isFile()) {
							cmdline = `sudo -u eval ${cmdline} ${tmpfilename()}`;
							let proc = cp.exec(cmdline, {cwd: "/tmp/"}), output = '';

							proc.stdout.on('data', pdata => {
								if (pdata.length) {
									output += pdata;
								}
							});
							proc.stderr.on('data', pdata => {
								if (pdata.length) {
									output += pdata;
								}
							});
							proc.on('close', () => {
								ws && output && ws.send(output);
							});

							proc.stdin.write(data.data);
							proc.stdin.end();

							return;
						} else {
							ws.send('Eval not supported for: ' + data.program);
						}
					});
				}
			} catch (e) {
				ws.send(e.toString());
			}
		});
	});

	httpServer.listen(80);
}
