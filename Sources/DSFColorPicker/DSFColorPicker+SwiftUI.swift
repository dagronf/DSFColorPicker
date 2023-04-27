//
//  DSFColorPicker+SwiftUI.swift
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

#if canImport(SwiftUI)

import Foundation
import SwiftUI

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
}

@available(macOS 11, *)
public struct DSFColorPickerUI: NSViewRepresentable {

	let name: String
	let showRecents: Bool
	@Binding var selectedColor: Color

	public init(
		named name: String? = nil,
		showRecents: Bool = true,
		selectedColor: Binding<Color>
	) {
		self.name = name ?? ""
		self.showRecents = showRecents
		self._selectedColor = selectedColor
	}

	public class Container: NSView {
		let pickerView = DSFColorPickerView()
		override init(frame frameRect: NSRect) {
			super.init(frame: frameRect)
			self.setup()
		}
		required init?(coder: NSCoder) {
			fatalError()
		}
		func setup() {
			self.translatesAutoresizingMaskIntoConstraints = false
			self.addSubview(pickerView)
			pickerView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
			pickerView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
			pickerView.leadingAnchor.constraint(greaterThanOrEqualTo: self.leadingAnchor).isActive = true
			pickerView.topAnchor.constraint(greaterThanOrEqualTo: self.topAnchor).isActive = true
		}
	}

	public typealias NSViewType = Container
	public func makeNSView(context: Context) -> Container {

		let v = Container()
		let picker = v.pickerView
		picker.name = name
		picker.showRecents = self.showRecents
		picker.selectedTheme = DSFColorPickerView.defaultThemes.theme(named: "default")
		picker.selectedColor = NSColor(cgColor: selectedColor.cgColor ?? .clear)
		picker.colorSelectedCallback = { newColor in
			let rgb = RGBAColor(newColor ?? .clear) ?? RGBAColor()
			let c = Color(.sRGB, red: rgb.R, green: rgb.G, blue: rgb.B, opacity: rgb.A)
			DispatchQueue.main.async {
				self.selectedColor = c
			}
		}

		return v
	}

	public func updateNSView(_ nsView: Container, context: Context) {
		let n1 = nsView.pickerView.selectedColor
		let n2 = NSColor(cgColor: self.selectedColor.cgColor ?? .clear)
		if n1 != n2 {
			nsView.pickerView.selectedColor = n2
		}
	}
}


@available(macOS 11, *)
extension DSFColorPickerUI {
	public func makeCoordinator() -> Coordinator {
		Coordinator()
	}

	public class Coordinator: NSObject {
		weak var parent: DSFColorPickerView?
		public override init() {
			super.init()
		}
	}
}

#endif
