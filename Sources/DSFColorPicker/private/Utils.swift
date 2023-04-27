//
//  Utils.swift
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

import AppKit
import CoreGraphics
import Foundation

extension BinaryFloatingPoint {
	/// Do a floating point equality check with an accuracy value
	@inlinable func equal(to right: Self, accuracy: Self) -> Bool {
		abs(self - right) <= accuracy
	}
}

/// A simple NSColor->sRGBA components container
struct RGBAColor {
	let R: CGFloat
	let G: CGFloat
	let B: CGFloat
	let A: CGFloat
	let rgbaColor: NSColor

	init() {
		R = 0.0
		G = 0.0
		B = 0.0
		A = 0.0
		rgbaColor = .clear
	}

	init?(_ color: NSColor) {
		guard let c = color.usingColorSpace(.extendedSRGB) else { return nil }
		R = c.redComponent
		G = c.greenComponent
		B = c.blueComponent
		A = c.alphaComponent
		rgbaColor = c
	}

	/// Very simple method for detecting whether two colors are 'the same'
	@inlinable func isMostlyEqualTo(_ right: RGBAColor) -> Bool {
		R.equal(to: right.R, accuracy: 1e-4)
		&& G.equal(to: right.G, accuracy: 1e-4)
		&& B.equal(to: right.B, accuracy: 1e-4)
		&& A.equal(to: right.A, accuracy: 1e-4)
	}
}

extension NSColor {
	/// Is this color _mostly_ equal to the provided color
	func isMostlyEqualTo(_ color2: NSColor?) -> Bool {
		guard
			let color2 = color2,
			let n1 = RGBAColor(self),
			let n2 = RGBAColor(color2)
		else {
			return false
		}
		return n1.isMostlyEqualTo(n2)
	}
}
