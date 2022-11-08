#!/usr/bin/env python3
import webview

def setTheme(window):
	window.evaluate_js('')

if __name__ == '__main__':
	window = webview.create_window("Muz", "http://localhost:6680/musicbox_webclient", background_color='#000000')
	webview.start(setTheme, window)