/*
 Copyright 2021, Bareboat Necessities
 */
const {commands1, commands2, sites} = require('./constants');

const http = require('http');
const url = require('url');
const fileSystem = require('fs');
const path = require('path');
const {spawn} = require('child_process');

const hostname = '127.0.0.1';
const port = 4997;

function writeSvgResponse(res, status, contentType, parsed) {
    const imgName = parsed.query['name'];
    if (imgName && imgName.match(/^[0-9a-zA-Z_\-]+$/)) {
        const filePath = path.join(__dirname, 'img/' + imgName + '.svg');
        const stat = fileSystem.statSync(filePath);
        res.writeHead(status, {
            'Content-Type': contentType,
            'Content-Length': stat.size
        });
        const readStream = fileSystem.createReadStream(filePath);
        readStream.pipe(res);
    }
}

function writeJsResponse(res, status, contentType, parsed) {
    const jsName = parsed.query['name'];
    if (jsName && jsName.match(/^[0-9a-zA-Z_\-]+$/)) {
        const filePath = path.join(__dirname, 'js/' + jsName + '.js');
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
    //console.log(`req: ${req.url}`);
    const parsed = url.parse(req.url, true);
    //console.log(`path: ${parsed.pathname}`)
    if (parsed.pathname === '/www') {
        writeResponse(res, 200, 'text/html', processSiteReq(parsed.query['name']));
    } else if (parsed.pathname === '/run') {
        writeResponse(res, 200, 'application/json', processReq(parsed), "");
    } else if (parsed.pathname === '/img') {
        writeSvgResponse(res, 200, 'image/svg+xml', parsed, processMain(parsed.query['m']));
    } else if (parsed.pathname === '/js') {
        writeJsResponse(res, 200, 'text/javascript', parsed, processMain(parsed.query['m']));
    } else {
        writeResponse(res,200, 'text/html', processMain(parsed.query['m']));
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
        let commandObj = commands1.find(value => {
            if (value.name === progName) return value
        });
        if (!commandObj) {
            commandObj = commands2.find(value => {
                if (value.name === progName) return value
            });
        }
        if (commandObj) {
            if (commandObj.cmd != null && commandObj.cmd.length > 0) {
                const cmd = spawn(commandObj.cmd, commandObj.args);
                cmd.stdout.on('data', data => console.log(`stdout: ${data}`));
                cmd.stderr.on('data', data => console.log(`stderr: ${data}`));
                cmd.on('error', (error) => console.log(`error: ${error.message}`));
                //cmd.on('close', code => console.log(`child process exited with code ${code}`));
                return '{"return" : "ok"}';
            }
        } else {
            console.log(`not found: ${progName}`)
        }
    }
    return '{"return" : "err"}';
}

const style =
    '\n' +
    '* {\n' +
    '    -webkit-user-select: none;\n' +
    '}\n' +
    'html {\n' +
    '    font-family: Sans, Arial, Helvetica, sans-serif;\n' +
    '}\n' +
    '\n' +
    'body {\n' +
    '    margin-top: 50px;\n' +
    '    margin-left: 0;\n' +
    '    margin-right: 0;\n' +
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
    '    background: #101010;\n' +
    '    margin: 0 auto;\n' +
    '    padding: 6px;\n' +
    '    position: relative;\n' +
    '}\n' +
    '\n' +
    '.tile {\n' +
    '    width: 122px;\n' +
    '    margin: 3px;\n' +
    '    padding: 3px;\n' +
    '    color: White;\n' +
    '    display: inline-block;\n' +
    '    text-align: center;\n' +
    '    font-family: Sans, Arial, Helvetica, sans-serif;\n' +
    '    font-size: 15pt;\n' +
    '}\n' +
    '\n' +
    '.tile-img2 {\n' +
    '    border-radius: 14px;\n' +
    '    width: 55px;\n' +
    '    height: 55px;\n' +
    '    margin: 0 auto;\n' +
    '    padding: 8px;\n' +
    '    text-align: center;\n' +
    '    font-family: Sans, Arial, Helvetica, sans-serif;\n' +
    '}\n' +
    '\n' +
    '.tile-img {\n' +
    '    width: 55px;\n' +
    '    height: 55px;\n' +
    '    margin: 0 auto;\n' +
    '    padding: 8px;\n' +
    '    text-align: center;\n' +
    '    font-family: Sans, Arial, Helvetica, sans-serif;\n' +
    '}\n' +
    '\n' +
    '.tile-label {\n' +
    '    padding: 4px;\n' +
    '    text-align: center;\n' +
    '}\n' +
    '\n' +
    '.main-icon {\n' +
    '    max-width: 100%;\n' +
    '    max-height: 100%;\n' +
    '}\n' +
    '\n' +
    '.toolbar {\n' +
    '    margin: 0 6px 2px 0;\n' +
    '    color: White;\n' +
    '    height: 32px;\n' +
    '    font-family: Sans, Arial, Helvetica, sans-serif;\n' +
    '}\n' +
    '\n' +
    '.button-bar {\n' +
    '    margin: 0 10px 10px 0;\n' +
    '    color: White;\n' +
    '    height: 32px;\n' +
    '    font-family: Sans, Arial, Helvetica, sans-serif;\n' +
    '}\n' +
    '\n' +
    '.main-panel {\n' +
    '    margin: auto;\n' +
    '    width: 720px;\n' +
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
    '\n';

const script = '\n' +
    '    <script>\n' +
    'function run(progId) {\n' +
    '    const http = new XMLHttpRequest();\n' +
    '    const url=\'/run?name=\' + progId;\n' +
    '    http.open("GET", url);\n' +
    '    http.send();\n' +
    '    http.onreadystatechange = () => {\n' +
    '        console.debug(http.responseText);\n' +
    '    }\n' +
    '}\n' +
    'function showPanel(prefix, id) {\n' +
    '    const x = document.getElementById(prefix + id);\n' +
    '    if (x.style.display === "none") {\n' +
    '        x.style.display = "block";\n' +
    '    } else {\n' +
    '        x.style.display = "none";\n' +
    '    }\n' +
    '}\n' +
    'function show(id) {\n' +
    '    showPanel(\'panel\', id);\n' +
    '    showPanel(\'next-btn\', id);\n' +
    '}\n' +
    '    </script>\n';

function getCredits(mode) {
    let nextMode = "BW";
    if ("BW" === mode) {
        nextMode = "Dark";
    } else if ("Dark" === mode) {
        nextMode = "";
    }
    return '    <div class="credits" style="width: 780px;">\n' +
        '        <div style="float: left; color: white;"><a style="text-decoration: none;" href="?m=' + nextMode + '">&#9728; &#9788; &#9789;</a></div>\n' +
        '        <div style="float: right; color: white;">Icons by ' +
        '<span style="color:orange;">Freepik</span> from <span style="color:orange;">www.flaticon.com</span></div>\n' +
        '        <div style="clear:both;"></div>\n' +
        '    </div>';
}

const nextButton1 =
    '        <div id="next-btn1" style="width: 30px; font-size: 18pt; color: white; padding: 145px 0; float: right;"\n' +
    '            onclick="show(1); show(2);">&nbsp;&gt;&nbsp;</div>\n';

const nextButton2 =
    '        <div id="next-btn2" style="width: 30px; font-size: 18pt; color: white; padding: 145px 0; display: none; float: left;"\n' +
    '            onclick="show(2); show(1);">&nbsp;&lt;&nbsp;</div>\n';

function buildTiles(commands, mode) {
    let items = '';
    let suffix = ("Dark" === mode) ? '' : '2';
    commands.forEach(value => {
        let bg = ("Dark" === mode) ? '' : ' style="background: ' + value.bg + ';"';
        let color = ("Dark" === mode) ? ' style="color: #e00d0d;"' : '';
        items = items + '\n' +
            '            <div class="tile">\n' +
            '                <div class="tile-img'+ suffix + '"' + bg + ' onclick="run(\'' + value.name + '\');"><img src="img?name=' + value.img + suffix + '" alt="' + value.title + '" class="main-icon"/></div>\n' +
            '                <div class="tile-label" ' + color + '>' + value.title + '</div>\n' +
            '            </div>'
    });
    return items;
}

function getStyle(mode) {
    let css;
    if ("BW" === mode) {
        css = 'html {\n' +
            '    -moz-filter: grayscale(100%);\n' +
            '    -webkit-filter: grayscale(100%);\n' +
            '    filter: gray; /* IE6-9 */\n' +
            '    filter: grayscale(100%);\n' +
            '}\n' + style;
    } else {
        css = style;
    }
    return '    <style>\n' + css +  '    </style>';
}

function processMain(mode) {
    const header = '<head>\n<meta charset="UTF-8">\n' + getStyle(mode) + script +
        '\n    <title>bbn-launcher</title>\n' +
        '\n    <script src = "js?name=swiped-events" type = "text/javascript"></script>\n' +
        '\n    <script>document.addEventListener(\'swiped-left\', function(e) {\n' +
        '        show(1); show(2);\n' +
        '});</script>\n' +
        '\n    <script>document.addEventListener(\'swiped-right\', function(e) {\n' +
        '        show(2); show(1);\n' +
        '});</script>\n' +
        '\n</head>\n';
    const items1 = buildTiles(commands1, mode);
    const panel1 =
        '        <div id="panel1" class="main-panel" style="float: left;">' + items1 + '\n' +
        '        </div>\n';

    const items2 = buildTiles(commands2, mode);
    const panel2 =
        '        <div id="panel2" class="main-panel" style="display: none; float: left;">' + items2  + '\n' +
        '        </div>\n';

    const panel =
        '    <div>\n' +
        nextButton2 + panel1 + panel2 + nextButton1 +
        '    </div>\n' + getCredits(mode);
    const body = '<body style="background: #0C0C0C;">\n' +
        '<div style="width: 780px; height: 360px;" class="desktop">\n' + panel + '\n</div>\n</body>';
    return '<!DOCTYPE html>\n'
        + '<html lang="en">\n' + header + body + '\n</html>';
}

function processSiteReq(name) {
    let site = sites.find(value => {
        if (value.name === name) return value;
    });
    if (!site) {
        site = sites[0];
    }
    return '<!DOCTYPE html>\n' +
        '<html lang="en">\n' +
        '<head>\n' +
        '    <meta charset="UTF-8">\n' +
        '    <title>' + site.name + '</title>\n' +
        '    <style>\n' +
        'body {\n' +
        '    color: white;\n' +
        '    font-family: Sans, Arial, Helvetica, sans-serif;\n' +
        '    font-size: 24pt;\n' +
        '}\n' +
        '.d1 {\n' +
        '    color: white;\n' +
        '    margin-top: 14px;\n' +
        '}\n' +
        'a {\n' +
        '    color:orange;\n' +
        '    text-decoration:none;\n' +
        '}\n' +
        'a:hover, a:focus {\n' +
        '    text-decoration:underline;\n' +
        '}\n' +
        '    </style>\n' +
        '</head>\n' +
        '<body style="background: black;">\n' +
        '<div style="text-align: center; margin-top: 120px; ">\n' +
        ((site.name === 'moorings') ? getMooringsLinks() : '    <div style="color: white;"><a href="' + site.url + '">Press for:&nbsp; ' + site.url + '</a></div>\n') +
        '</div>\n' +
        '</body>\n' +
        '</html>\n';
}

function getMooringsLinks() {
    return '' +
        '    <div class="d1"><a href="https://dockwa.com/">Dockwa &nbsp;(US and around)</a></div>\n' +
        '    <div class="d1"><a href="https://www.snagaslip.com/">Snag-A-Slip &nbsp;(US and around)</a></div>\n' +
        '    <div class="d1"><a href="https://my-sea.com/">My-Sea &nbsp;(Germany and Europe)</a></div>\n' +
        '    <div class="d1"><a href="https://www.marinareservation.com/">MarinaReservation &nbsp;(Europe mostly)</a></div>\n' +
        '    <div class="d1"><a href="https://www.bluewaterapp.com">BlueWaterApp &nbsp;(Nederlands)</a></div>\n';
}
