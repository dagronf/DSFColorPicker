//
//  DSFColorPickerTheme.swift
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

// MARK: - Color picker theme

public class DSFColorPickerTheme {
	let name: String
	private var colors: [[NSColor?]]

	// MARK: Initializers

	public init(name: String, rows: Int, columns: Int, colors: [NSColor?]) {
		self.name = name

		/// Must have exact
		assert(rows * columns == colors.count)

		var gridColors: [[NSColor?]] = []
		for row in 0 ..< rows {
			let offset: Int = row * columns
			gridColors.append(Array(colors[offset ..< offset + columns]))
		}

		self.colors = gridColors
	}

	public init(name: String, colors: [[NSColor?]]) {
		assert(DSFColorPickerTheme.validateGrid(colors))

		self.name = name
		self.colors = colors
	}

	public init(name: String, argbValueGrid: [[UInt32]]) {
		assert(DSFColorPickerTheme.validateGrid(argbValueGrid))

		self.name = name
		let colors: [[NSColor?]] = argbValueGrid.map {
			NSColor.argbValuesToColors(argbValues: $0)
		}

		self.colors = colors
	}

	// MARK: Utility functions

	private static func validateGrid<T>(_ gridData: [[T]]) -> Bool {
		// Check that all the rows have the same column count
		return Set(gridData.map { $0.count }).count == 1
	}

	/// Converts a raw UInt32 into an ARGB NSColor
	private static func argbToColor(_ argbValue: UInt32) -> NSColor {
		let hasAlpha = argbValue > 0x00FF_FFFF
		let alpha = UInt8(truncatingIfNeeded: argbValue >> 24)
		let red = UInt8(truncatingIfNeeded: argbValue >> 16)
		let green = UInt8(truncatingIfNeeded: argbValue >> 8)
		let blue = UInt8(truncatingIfNeeded: argbValue)
		return NSColor(
			red: CGFloat(red) / 256.0,
			green: CGFloat(green) / 256.0,
			blue: CGFloat(blue) / 256.0,
			alpha: hasAlpha ? CGFloat(alpha) / 256.0 : 1.0
		)
	}

	// MARK: Getters

	/// The number of rows in the theme
	public var rowCount: Int {
		return self.colors.count
	}

	/// The number of columns in the theme
	public var colCount: Int {
		return self.colors[0].count
	}

	func colorAt(_ row: Int, _ col: Int) -> NSColor? {
		return self.colors[row][col]
	}
}
