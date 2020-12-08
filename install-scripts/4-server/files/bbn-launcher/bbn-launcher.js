/*
 Copyright 2020, Bareboat Necessities
 */
const http = require('http');
const url = require('url');
const fileSystem = require('fs');
const path = require('path');
const {spawn} = require('child_process');

const hostname = '127.0.0.1';
const port = 4997;

const commands = [
    {name: 'chart', title: 'Chart', img: 'chart', bg: 'Peru', cmd: 'onlyone', args: ['opencpn']},
    {name: 'pilot', title: 'AutoPilot', img: 'radar', bg: 'ForestGreen', cmd: '/opt/Pypilot_webapp/Pypilot_webapp', args: []},
    {name: 'dash', title: 'Dashboard', img: 'dashboard', bg: 'Olive', cmd: '/opt/MusicBox/MusicBox', args: []},
    {name: 'weather', title: 'Weather', img: 'weather', bg: 'RoyalBlue', cmd: 'onlyone', args: ['XyGrib']},
    {name: 'cam', title: 'Camera', img: 'camera', bg: 'SeaGreen', cmd: 'onlyone', args: ['vlc']},
    {name: 'music', title: 'Music', img: 'multimedia', bg: 'IndianRed', cmd: '/opt/MusicBox/MusicBox', args: []},
    {name: 'www', title: 'WWW', img: 'internet', bg: 'SteelBlue', cmd: 'onlyone', args: ['chromium']},
    {name: 'marinas', title: 'Marinas', img: 'travel', bg: 'SaddleBrown', cmd: '/opt/Dockwa/Dockwa', args: []},
    {name: 'files', title: 'Files', img: 'travel', bg: 'Peru', cmd: 'onlyone', args: ['thunar']},
    {name: 'tasks', title: 'Tasks', img: 'travel', bg: 'ForestGreen',  cmd: 'onlyone', args: ['lxtask']},
    {name: 'sky', title: 'Sky', img: 'travel', bg: 'Olive', cmd: 'onlyone', args: ['stellarium']},
    {name: 'chess', title: 'Chess', img: 'travel', bg: 'RoyalBlue', cmd: 'onlyone', args: ['gnome-chess']},
    {name: 'cards', title: 'Cards', img: 'travel', bg: 'SeaGreen', cmd: 'onlyone', args: ['openpref']},
    {name: 'radio', title: 'Radio', img: 'travel', bg: 'IndianRed', cmd: 'onlyone', args: ['fldigi']},
    {name: 'email', title: 'Email', img: 'travel', bg: 'SteelBlue', cmd: 'onlyone', args: ['geary']},
]

function writeSvgResponse(res, status, contentType, parsed) {
    const imgName = parsed.query['name'];
    if (imgName && imgName.match(/^[0-9a-zA-Z_\-]+$/)) {
        const filePath = path.join(__dirname, 'img/' + imgName + '2.svg');
        const stat = fileSystem.statSync(filePath);
        res.writeHead(status, {
            'Content-Type': contentType,
            'Content-Length': stat.size
        });
        const readStream = fileSystem.createReadStream(filePath);
        readStream.pipe(res);
    }
}

const server = http.createServer((req, res) => {
    console.log(`req: ${req.url}`);
    const parsed = url.parse(req.url, true);
    console.log(`path: ${parsed.pathname}`)
    if (parsed.pathname === '/run') {
        writeResponse(res, 200, 'application/json', processReq(parsed));
    } else if (parsed.pathname === '/img') {
        writeSvgResponse(res, 200, 'image/svg+xml', parsed);
    } else {
        writeResponse(res,200, 'text/html', processMain());
    }
});

server.listen(port, hostname, () => {
    console.log(`Server running at http://${hostname}:${port}/`);
});

function writeResponse(res, status, contentType, content) {
    res.writeHead(200, {
        'Content-Type': contentType,
        'Content-Length': content.length,
        'Expires': new Date().toUTCString()
    }).end(content);
}

function processReq(parsed) {
    const progName = parsed.query['name'];
    if (progName) {
        const commandObj = commands.find(value => {
            if (value.name === progName) return value
        });
        if (commandObj) {
            const cmd = spawn(commandObj.cmd, commandObj.args);
            cmd.stdout.on('data', data => console.log(`stdout: ${data}`));
            cmd.stderr.on('data', data => console.log(`stderr: ${data}`));
            cmd.on('error', (error) => console.log(`error: ${error.message}`));
            cmd.on('close', code => console.log(`child process exited with code ${code}`));
            return '{"return" : "ok"}';
        } else {
            console.log(`not found: ${progName}`)
        }
    }
    return '{"return" : "err"}';
}

const style = '    <style>\n' +
    '\n' +
    'html {\n' +
    '    font-family: Sans, Arial, Helvetica, sans-serif;\n' +
    '}\n' +
    '\n' +
    'body {\n' +
    '    margin-top: 50px;\n' +
    '    font-family: Sans, Arial, Helvetica, sans-serif;\n' +
    '}\n' +
    '\n' +
    'a {\n' +
    '    color:orange;\n' +
    '    text-decoration:none;\n' +
    '    font-family: Sans, Arial, Helvetica, sans-serif;\n' +
    '}\n' +
    '\n' +
    'a:hover, a:focus {\n' +
    '    text-decoration:underline;\n' +
    '}\n' +
    '\n' +
    '.desktop {\n' +
    '    width: 960px;\n' +
    '    height: 340px;\n' +
    '    background: #101010;\n' +
    '    margin: 0 auto;\n' +
    '    padding: 10px;\n' +
    '    position: relative;\n' +
    '}\n' +
    '\n' +
    '.tile {\n' +
    '    border-radius: 10px;\n' +
    '    width: 120px;\n' +
    '    height: 100px;\n' +
    '    margin: 0 10px 10px 0;\n' +
    '    padding: 8px;\n' +
    '    color: White;\n' +
    '    display: inline-block;\n' +
    '    text-align: center;\n' +
    '    font-family: Sans, Arial, Helvetica, sans-serif;\n' +
    '    font-size: 16pt;\n' +
    '}\n' +
    '\n' +
    '.toolbar {\n' +
    '    margin: 0 6px 2px 0;\n' +
    '    color: white;\n' +
    '    height: 32px;\n' +
    '    font-family: Sans, Arial, Helvetica, sans-serif;\n' +
    '}\n' +
    '\n' +
    '.button-bar {\n' +
    '    margin: 0 10px 10px 0;\n' +
    '    color: white;\n' +
    '    height: 32px;\n' +
    '    font-family: Sans, Arial, Helvetica, sans-serif;\n' +
    '}\n' +
    '\n' +
    '.main-panel {\n' +
    '    margin: auto;\n' +
    '    width: 758px;\n' +
    '}\n' +
    '\n' +
    '.main-icon {\n' +
    '    width: 70px;\n' +
    '    height: 70px;\n' +
    '}\n' +
    '\n' +
    '.credits {\n' +
    '    position: absolute;\n' +
    '    bottom: 2px;\n' +
    '}\n' +
    '\n' +
    '.button-bar span {\n' +
    '    border-radius: 4px;\n' +
    '}\n' +
    '\n' +
    '    </style>';

const script = '\n' +
    '    <script>\n' +
    'function run(progId) {\n' +
    '    const http = new XMLHttpRequest();\n' +
    '    const url=\'/run?name=\' + progId;\n' +
    '    http.open("GET", url);\n' +
    '    http.send();\n' +
    '    http.onreadystatechange = (e) => {\n' +
    '        console.debug(http.responseText);\n' +
    '    }\n' +
    '}\n' +
    '    </script>\n';

function processMain() {
    const header = '<head>\n<meta charset="UTF-8">\n' + style + script +
        '\n    <title>bbn-launcher</title>\n' + '\n</head>\n';
    let items = '';
    commands.forEach(value => {
        items = items +
            '            <div class="tile" style="background: ' + value.bg + ';" onclick="run(\'' + value.name + '\');">\n' +
            '                <div>' + value.title + '</div>\n' +
            '                <div><img src="img?name=' + value.img + '" alt="' + value.title + '" class="main-icon"/></div>\n' +
            '            </div>'
    });
    const body = '<body style="background: black;">\n' +
        '<div style="width: 800px; height: 480px;" class="desktop">' + items + '</div>\n</body>';
    return '<!DOCTYPE html>'
        + '<html lang="en">' + header + body + '</html>';
}
