//
//  NSColor+dsfextensions.swift
//  DSFColorPicker
//
//  Created by Darren Ford on 4/1/19.
//  Copyright © 2019 Darren Ford. All rights reserved.
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

import Foundation

extension NSColor
{
	/// Returns a flat contrasting color for this color
	func flatContrastColor() -> NSColor
	{
		if let rgbColor = self.usingColorSpace(.genericRGB),
			rgbColor != NSColor.clear
		{
			let r = 0.299 * rgbColor.redComponent
			let g = 0.587 * rgbColor.greenComponent
			let b = 0.114 * rgbColor.blueComponent
			let avgGray: CGFloat = 1 - (r + g + b)
			return (avgGray >= 0.45) ? .white : .black
		}
		return .textColor
	}

	/// Returns a slightly darker version of this color
	func darker() -> NSColor
	{
		let rgbColor = self.usingColorSpace(.genericRGB)

		var h: CGFloat = 0
		var s: CGFloat = 0
		var b: CGFloat = 0
		var a: CGFloat = 0

		rgbColor?.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
		return NSColor.init(hue: h, saturation: s, brightness: max(b - 0.1, 0.0), alpha: a)
	}

	/// Converts a raw UInt32 into an ARGB NSColor
	static func argbToColor(_ argbValue: UInt32) -> NSColor
	{
		let hasAlpha = argbValue > 0x00FFFFFF
		let alpha = UInt8(truncatingIfNeeded: argbValue >> 24)
		let red = UInt8(truncatingIfNeeded: argbValue >> 16)
		let green = UInt8(truncatingIfNeeded: argbValue >> 8)
		let blue = UInt8(truncatingIfNeeded: argbValue)
		return NSColor(red: CGFloat(red) / 256.0,
					   green: CGFloat(green) / 256.0,
					   blue: CGFloat(blue) / 256.0,
					   alpha: hasAlpha ? CGFloat(alpha) / 256.0 : 1.0)
	}

	/// Converts an array of UInt32 colors to an array of NSColor
	static func argbValuesToColors(argbValues: [UInt32]) -> [NSColor]
	{
		return argbValues.map { argbToColor($0) }
	}
}
