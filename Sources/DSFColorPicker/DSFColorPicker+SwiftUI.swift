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

/// A configurable color picker
@available(macOS 11, *)
public struct DSFColorPickerUI: NSViewRepresentable {
	/// The currently selected color
	@Binding var selectedColor: Color
	/// Create a color picker
	public init(
		named name: String? = nil,
		theme: DSFColorPickerTheme? = nil,
		cellSize: CGSize? = nil,
		spacing: CGSize? = nil,
		displaySettings: DisplaySettings = .default,
		selectedColor: Binding<Color>
	) {
		self.name = name ?? ""
		self.theme = theme
		self.cellSize = cellSize
		self.spacing = spacing
		self.displaySettings = displaySettings
		self._selectedColor = selectedColor
	}

	/// Create a color picker
	public init(
		named name: String? = nil,
		theme: DSFColorPickerTheme? = nil,
		cellSize: CGSize? = nil,
		spacing: CGFloat,
		displaySettings: DisplaySettings = .default,
		selectedColor: Binding<Color>
	) {
		self.init(
			named: name,
			theme: theme,
			cellSize: cellSize,
			spacing: CGSize(width: spacing, height: spacing),
			displaySettings: displaySettings,
			selectedColor: selectedColor
		)
	}

	// Private
	public typealias NSViewType = Container
	let name: String
	let cellSize: CGSize?
	let spacing: CGSize?
	let displaySettings: DisplaySettings
	let theme: DSFColorPickerTheme?
}

@available(macOS 11, *)
extension DSFColorPickerUI {
	/// The components of the color picker to display
	public struct DisplaySettings: OptionSet {
		/// Show the recents line
		public static let recents = DisplaySettings(rawValue: 1 << 0)
		/// Show titles on each of the colorpicker components
		public static let titles = DisplaySettings(rawValue: 1 << 1)
		/// Show the color picker
		public static let colorDropper = DisplaySettings(rawValue: 1 << 3)
		/// Show the current color
		public static let current = DisplaySettings(rawValue: 1 << 4)
		/// Show the system color picker
		public static let colorPicker = DisplaySettings(rawValue: 1 << 5)
		/// The default settings
		public static let `default`: DisplaySettings = [.recents, .titles, .colorDropper, .current]

		public let rawValue: Int
		public init(rawValue: Int) { self.rawValue = rawValue }
	}
}

@available(macOS 11, *)
extension DSFColorPickerUI {
	public func makeNSView(context: Context) -> Container {
		let v = Container()
		let picker = v.pickerView
		picker.name = name
		if let sz = self.cellSize {
			picker.cellWidth = sz.width
			picker.cellHeight = sz.height
		}
		if let spacing = self.spacing {
			picker.verticalSpacing = spacing.width
			picker.horizontalSpacing = spacing.height
		}
		picker.showRecents = self.displaySettings.contains(.recents)
		picker.showTitles = self.displaySettings.contains(.titles)
		picker.showCurrent = self.displaySettings.contains(.current)
		picker.showColorDropper = self.displaySettings.contains(.colorDropper)
		picker.showColorPaletteButton = self.displaySettings.contains(.colorPicker)
		picker.selectedTheme = DSFColorPickerView.defaultThemes.theme(named: "default")
		picker.selectedColor = NSColor(self.selectedColor)
		picker.colorSelectedCallback = { newColor in
			let rgb = RGBAColor(newColor ?? .clear) ?? RGBAColor()
			let c = Color(.sRGB, red: rgb.R, green: rgb.G, blue: rgb.B, opacity: rgb.A)
			DispatchQueue.main.async {
				self.selectedColor = c
			}
		}

		if let theme = self.theme {
			picker.selectedTheme = theme
		}

		return v
	}

	public func updateNSView(_ nsView: Container, context: Context) {
		let n1 = nsView.pickerView.selectedColor
		let n2 = NSColor(self.selectedColor)
		if n1?.isMostlyEqualTo(n2) == false {
			nsView.pickerView.selectedColor = n2
		}
	}
}

@available(macOS 11, *)
extension DSFColorPickerUI {
	/// Simple container for the picker to center within the available space
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
}

#endif
