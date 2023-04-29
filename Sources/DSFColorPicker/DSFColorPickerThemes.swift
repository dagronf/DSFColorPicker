//
//  DSFColorPickerThemes.swift
//
//  Copyright © 2023 Darren Ford. All rights reserved.
//
//  MIT license
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
//  documentation files (the "Software"), to deal in the Software without restriction, including without limitation the
//  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to
//  permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial
//  portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
//  WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS
//  OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
//  OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

import Cocoa

// MARK: - Color picker themes container

@objc open class DSFColorPickerThemes: NSObject {
	private var defaultThemes: [DSFColorPickerTheme] = []

	/// Default is a simple theme
	static var defaultThemes: [DSFColorPickerTheme] =
		[
			DSFColorPickerTheme(name: "default", argbValueGrid: [
				[0xF5402C, 0xEB1360, 0x9C1BB1, 0x6634B8, 0x3D4DB7],
				[0x47AE4A, 0x009687, 0x01BBD5, 0x00A6F6, 0x0C93F5],
				[0x89C43F, 0xCCDD1E, 0xFFEC17, 0xFEC001, 0xFF9800],
				[0x000000, 0x5E7C8B, 0x9D9D9D, 0x7A5447, 0xFF5506],
			]),
		]

	/// Standard 'empty' theme
	static var emptyTheme = DSFColorPickerTheme(name: "", colors: [[NSColor.clear]])

	// MARK: Overridables

	/// Override to use custom themes
	open func loadThemes() -> [DSFColorPickerTheme] {
		return DSFColorPickerThemes.defaultThemes
	}

	// MARK: - Getters

	/// Returns the available theme names
	public func themeNames() -> [String] {
		return self.defaultThemes.map { $0.name }
	}

	/// Returns a theme with the supplied theme name
	///
	/// - Parameter theme: the name of the theme to return
	/// - Returns: the theme, or nil if the theme wasn't found
	public func theme(named name: String) -> DSFColorPickerTheme? {
		if self.defaultThemes.count == 0 {
			self.defaultThemes = self.loadThemes()
		}

		let theme = self.defaultThemes.filter { $0.name == name }
		guard !theme.isEmpty else {
			/// If the specified theme wasn't found by name, just return an empty theme
			return DSFColorPickerThemes.emptyTheme
		}
		return theme.first
	}
}
