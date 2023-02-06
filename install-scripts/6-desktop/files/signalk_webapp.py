#!/usr/bin/env python3
import webview

def setTheme(window):
	window.evaluate_js('')

if __name__ == '__main__':
	window = webview.create_window('S-K', "http://localhost/admin/#/dashboard", background_color='#000000', frameless=True)
	webview.start(setTheme, window)
