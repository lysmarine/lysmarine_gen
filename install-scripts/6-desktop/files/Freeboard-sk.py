#!/usr/bin/env python3
import webview

def setTheme(window):
	window.evaluate_js('')

if __name__ == '__main__':
	window = webview.create_window('FreeB', 'http://localhost:81/@signalk/freeboard-sk/', background_color='#000000')
	webview.start(setTheme, window)
