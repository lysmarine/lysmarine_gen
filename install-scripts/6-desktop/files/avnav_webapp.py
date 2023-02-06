#!/usr/bin/env python3
import webview

def setTheme(window):
	window.evaluate_js('')

if __name__ == '__main__':
	window = webview.create_window('avnav', "http://localhost:8099", background_color='#000000',transparent = 'true' , frameless=True)
	webview.start(setTheme, window)
