/**code is far away from bug with the animal protecting
 *         ┌─┐       ┌─┐
 *      ┌──┘ ┴───────┘ ┴──┐
 *      │                 │
 *      │       ───       │
 *      │  ─┬┘       └┬─  │
 *      │                 │
 *      │       ─┴─       │
 *      │                 │
 *      └───┐         ┌───┘
 *          │         │
 *          │         │  神兽保佑
 *          │         │  代码无BUG!
 *          │         └──────────────┐
 *          │                        │
 *          │                        ├─┐
 *          │                        ┌─┘
 *          │                        │
 *          └─┐  ┐  ┌───────┬──┐  ┌──┘
 *            │ ─┤ ─┤       │ ─┤ ─┤
 *            └──┴──┘       └──┴──┘
 * Created by nochi0105 on 17/08/25.
 */

var fs = require( 'fs' );
var options = {
    // key : fs.readFileSync('./server_key.pem').toString(),
    // cert: fs.readFileSync('./server_crt.pem').toString(),
    // ca: fs.readFileSync('./server_csr.pem').toString(),
};

var app = require('express')();
var server = require('http').createServer(app, options);
var io = require('socket.io')(server);

app.get('/', function (req, res) {
    res.sendFile(__dirname + '/index.html');
});

// chatでメッセージを受信したらクライアント全体にキャスト
io.on('connection', function (socket) {
    socket.on('chat', function (msg) {
        io.emit('chat', msg);
    })
});

server.on('listening', function () {
    console.log('listening on 8080');
});

server.listen(8080);
