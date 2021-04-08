#!/usr/bin/env python3
import webview

def setTheme(window):
	window.evaluate_js('')

if __name__ == '__main__':
	window = webview.create_window('Dash', "http://localhost:80", background_color='#000000',transparent = 'true' )
	webview.start(setTheme, window)
