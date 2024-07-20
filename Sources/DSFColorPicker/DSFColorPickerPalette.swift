//
//  Copyright © 2024 Darren Ford. All rights reserved.
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

// MARK: - Color picker palette

/// A color palette
public class DSFColorPickerPalette {
	/// The name of the palette
	public let name: String

	/// The colors in the palette
	private var colors: [[NSColor?]]

	// MARK: Initializers

	/// Create a color palette with a name and a collection of colors
	/// - Parameters:
	///   - name: The palette name
	///   - rows: The row count
	///   - columns: The column count
	///   - colors: An array of colors
	public init(name: String, rows: Int, columns: Int, colors: [NSColor?]) {
		assert(rows * columns == colors.count)

		self.name = name

		var gridColors: [[NSColor?]] = []
		for row in 0 ..< rows {
			let offset: Int = row * columns
			gridColors.append(Array(colors[offset ..< offset + columns]))
		}

		self.colors = gridColors
	}

	/// Create a palette with a name and a grid of colors
	/// - Parameters:
	///   - name: The palette name
	///   - colors: An array of colors
	public init(name: String, colors: [[NSColor?]]) {
		assert(DSFColorPickerPalette.validateGrid(colors))
		self.name = name
		self.colors = colors
	}

	/// Create a palette with a name and a grid of colors
	public init(name: String, argbValueGrid: [[UInt32]]) {
		assert(DSFColorPickerPalette.validateGrid(argbValueGrid))

		self.name = name
		let colors: [[NSColor?]] = argbValueGrid.map {
			NSColor.argbValuesToColors(argbValues: $0)
		}

		self.colors = colors
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
}

extension DSFColorPickerPalette {

	/// Standard 'empty' palette
	internal static let emptyPalette = DSFColorPickerPalette(name: "", colors: [[NSColor.clear]])

	private static func validateGrid<T>(_ gridData: [[T]]) -> Bool {
		// Check that all the rows have the same column count
		return Set(gridData.map { $0.count }).count == 1
	}

	/// Returns the color at the specified row and column
	internal func colorAt(_ row: Int, _ col: Int) -> NSColor? {
		return self.colors[row][col]
	}
}
