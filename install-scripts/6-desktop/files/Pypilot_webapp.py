#!/usr/bin/env python3
import webview

def setTheme(window):
	window.evaluate_js("setTheme('dark')")

if __name__ == '__main__':
	window = webview.create_window('Pilot', 'http://localhost:8080', background_color='#000000', frameless=True)
	webview.start(setTheme, window)
