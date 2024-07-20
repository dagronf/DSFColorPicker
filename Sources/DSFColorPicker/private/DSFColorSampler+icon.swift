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

/// Icon generated using PaintCode

func colorPickerIconImage() -> CGImage {
	let gc = CGContext(data: nil, width: 96, height: 96, bitsPerComponent: 8, bytesPerRow: 0, space: CGColorSpace(name: CGColorSpace.sRGB)!, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
	let nsGc = NSGraphicsContext(cgContext: gc, flipped: false)
	NSGraphicsContext.current = nsGc; do {
		//// Color Declarations
		let fillColor = NSColor(red: 0, green: 0, blue: 0, alpha: 1)
		let color = NSColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1)

		let bezier2Path = NSBezierPath()
		bezier2Path.move(to: NSPoint(x: 9, y: 21))
		bezier2Path.line(to: NSPoint(x: 34, y: 21))
		bezier2Path.line(to: NSPoint(x: 20, y: 7.48))
		bezier2Path.line(to: NSPoint(x: 7, y: 2))
		bezier2Path.line(to: NSPoint(x: 2, y: 5.65))
		bezier2Path.line(to: NSPoint(x: 9, y: 21))
		bezier2Path.close()
		color.setFill()
		bezier2Path.fill()

		//// Bezier Drawing
		let bezierPath = NSBezierPath()
		bezierPath.move(to: NSPoint(x: 95.99, y: 82.37))
		bezierPath.curve(to: NSPoint(x: 88.95, y: 93.57), controlPoint1: NSPoint(x: 95.13, y: 88.45), controlPoint2: NSPoint(x: 91.72, y: 91.55))
		bezierPath.curve(to: NSPoint(x: 78.39, y: 94.96), controlPoint1: NSPoint(x: 85.85, y: 95.82), controlPoint2: NSPoint(x: 81.91, y: 96.35))
		bezierPath.curve(to: NSPoint(x: 69.22, y: 88.03), controlPoint1: NSPoint(x: 74.66, y: 93.57), controlPoint2: NSPoint(x: 71.99, y: 90.8))
		bezierPath.curve(to: NSPoint(x: 59.3, y: 78.11), controlPoint1: NSPoint(x: 66.02, y: 84.61), controlPoint2: NSPoint(x: 62.6, y: 81.41))
		bezierPath.curve(to: NSPoint(x: 51.51, y: 77.46), controlPoint1: NSPoint(x: 55.99, y: 80.24), controlPoint2: NSPoint(x: 54.18, y: 80.03))
		bezierPath.curve(to: NSPoint(x: 46.82, y: 72.77), controlPoint1: NSPoint(x: 49.91, y: 75.86), controlPoint2: NSPoint(x: 48.31, y: 74.37))
		bezierPath.curve(to: NSPoint(x: 46.6, y: 66.58), controlPoint1: NSPoint(x: 45.22, y: 71.06), controlPoint2: NSPoint(x: 45, y: 68.29))
		bezierPath.curve(to: NSPoint(x: 49.48, y: 64.45), controlPoint1: NSPoint(x: 47.35, y: 65.73), controlPoint2: NSPoint(x: 48.42, y: 65.2))
		bezierPath.curve(to: NSPoint(x: 47.35, y: 62.64), controlPoint1: NSPoint(x: 48.31, y: 63.49), controlPoint2: NSPoint(x: 47.78, y: 63.06))
		bezierPath.curve(to: NSPoint(x: 10.98, y: 26.36), controlPoint1: NSPoint(x: 35.3, y: 50.58), controlPoint2: NSPoint(x: 23.14, y: 38.42))
		bezierPath.curve(to: NSPoint(x: 4.9, y: 16.65), controlPoint1: NSPoint(x: 8.21, y: 23.59), controlPoint2: NSPoint(x: 5.97, y: 20.6))
		bezierPath.curve(to: NSPoint(x: 1.91, y: 10.68), controlPoint1: NSPoint(x: 4.37, y: 14.52), controlPoint2: NSPoint(x: 3.09, y: 12.49))
		bezierPath.curve(to: NSPoint(x: 1.27, y: 9.83), controlPoint1: NSPoint(x: 1.7, y: 10.36), controlPoint2: NSPoint(x: 1.49, y: 10.15))
		bezierPath.curve(to: NSPoint(x: 1.7, y: 1.93), controlPoint1: NSPoint(x: -0.54, y: 7.37), controlPoint2: NSPoint(x: -0.43, y: 4.06))
		bezierPath.curve(to: NSPoint(x: 1.91, y: 1.72), controlPoint1: NSPoint(x: 1.81, y: 1.82), controlPoint2: NSPoint(x: 1.91, y: 1.72))
		bezierPath.curve(to: NSPoint(x: 9.7, y: 1.18), controlPoint1: NSPoint(x: 4.05, y: -0.42), controlPoint2: NSPoint(x: 7.25, y: -0.52))
		bezierPath.curve(to: NSPoint(x: 9.81, y: 1.18), controlPoint1: NSPoint(x: 9.7, y: 1.18), controlPoint2: NSPoint(x: 9.7, y: 1.18))
		bezierPath.curve(to: NSPoint(x: 15.35, y: 4.49), controlPoint1: NSPoint(x: 11.62, y: 2.46), controlPoint2: NSPoint(x: 13.33, y: 4.17))
		bezierPath.curve(to: NSPoint(x: 26.45, y: 10.89), controlPoint1: NSPoint(x: 19.83, y: 5.45), controlPoint2: NSPoint(x: 23.35, y: 7.69))
		bezierPath.curve(to: NSPoint(x: 63.03, y: 47.06), controlPoint1: NSPoint(x: 38.82, y: 22.84), controlPoint2: NSPoint(x: 50.87, y: 35))
		bezierPath.curve(to: NSPoint(x: 64.95, y: 48.87), controlPoint1: NSPoint(x: 63.56, y: 47.59), controlPoint2: NSPoint(x: 64.1, y: 48.02))
		bezierPath.curve(to: NSPoint(x: 66.34, y: 46.95), controlPoint1: NSPoint(x: 65.48, y: 48.13), controlPoint2: NSPoint(x: 65.8, y: 47.49))
		bezierPath.curve(to: NSPoint(x: 73.7, y: 46.95), controlPoint1: NSPoint(x: 68.68, y: 44.5), controlPoint2: NSPoint(x: 71.24, y: 44.61))
		bezierPath.curve(to: NSPoint(x: 77.54, y: 50.79), controlPoint1: NSPoint(x: 74.98, y: 48.23), controlPoint2: NSPoint(x: 76.26, y: 49.51))
		bezierPath.curve(to: NSPoint(x: 78.71, y: 59.11), controlPoint1: NSPoint(x: 80.63, y: 53.89), controlPoint2: NSPoint(x: 81.48, y: 55.38))
		bezierPath.curve(to: NSPoint(x: 86.39, y: 66.69), controlPoint1: NSPoint(x: 81.27, y: 61.68), controlPoint2: NSPoint(x: 83.83, y: 64.13))
		bezierPath.curve(to: NSPoint(x: 95.67, y: 78.53), controlPoint1: NSPoint(x: 89.91, y: 70.32), controlPoint2: NSPoint(x: 94.07, y: 73.41))
		bezierPath.curve(to: NSPoint(x: 95.99, y: 82.37), controlPoint1: NSPoint(x: 96.09, y: 79.81), controlPoint2: NSPoint(x: 96.2, y: 81.09))
		bezierPath.close()
		bezierPath.move(to: NSPoint(x: 60.47, y: 50.79))
		bezierPath.curve(to: NSPoint(x: 23.03, y: 13.45), controlPoint1: NSPoint(x: 47.99, y: 38.31), controlPoint2: NSPoint(x: 35.51, y: 25.83))
		bezierPath.curve(to: NSPoint(x: 14.82, y: 8.76), controlPoint1: NSPoint(x: 20.69, y: 11.11), controlPoint2: NSPoint(x: 18.02, y: 9.61))
		bezierPath.curve(to: NSPoint(x: 7.99, y: 5.24), controlPoint1: NSPoint(x: 12.37, y: 8.12), controlPoint2: NSPoint(x: 10.23, y: 6.41))
		bezierPath.curve(to: NSPoint(x: 7.35, y: 4.81), controlPoint1: NSPoint(x: 7.78, y: 5.13), controlPoint2: NSPoint(x: 7.57, y: 4.92))
		bezierPath.curve(to: NSPoint(x: 5.22, y: 4.92), controlPoint1: NSPoint(x: 6.71, y: 4.28), controlPoint2: NSPoint(x: 5.75, y: 4.38))
		bezierPath.line(to: NSPoint(x: 5.22, y: 4.92))
		bezierPath.curve(to: NSPoint(x: 5.11, y: 7.05), controlPoint1: NSPoint(x: 4.69, y: 5.56), controlPoint2: NSPoint(x: 4.58, y: 6.41))
		bezierPath.curve(to: NSPoint(x: 7.25, y: 9.93), controlPoint1: NSPoint(x: 5.86, y: 8.01), controlPoint2: NSPoint(x: 6.61, y: 8.97))
		bezierPath.curve(to: NSPoint(x: 9.17, y: 14.52), controlPoint1: NSPoint(x: 8.1, y: 11.32), controlPoint2: NSPoint(x: 8.85, y: 12.92))
		bezierPath.curve(to: NSPoint(x: 13.33, y: 22.31), controlPoint1: NSPoint(x: 9.81, y: 17.61), controlPoint2: NSPoint(x: 11.19, y: 20.17))
		bezierPath.curve(to: NSPoint(x: 51.83, y: 60.82), controlPoint1: NSPoint(x: 26.23, y: 35.22), controlPoint2: NSPoint(x: 39.14, y: 48.13))
		bezierPath.curve(to: NSPoint(x: 61.11, y: 51.54), controlPoint1: NSPoint(x: 54.92, y: 57.83), controlPoint2: NSPoint(x: 57.91, y: 54.74))
		bezierPath.curve(to: NSPoint(x: 60.47, y: 50.79), controlPoint1: NSPoint(x: 61.11, y: 51.54), controlPoint2: NSPoint(x: 60.79, y: 51.11))
		bezierPath.close()
		fillColor.setFill()
		bezierPath.fill()
	}
	NSGraphicsContext.current = nil
	return gc.makeImage()!
}
