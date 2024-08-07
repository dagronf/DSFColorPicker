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

#if canImport(SwiftUI)

import Foundation
import SwiftUI

/// A configurable color picker
@available(macOS 11, *)
public struct DSFColorPickerUI: NSViewRepresentable {
	/// The currently selected color
	@Binding var selectedColor: Color
	/// Create a color picker
	/// - Parameters:
	///   - name: The name for the picker (eg. 'Stroke color')
	///   - theme: The theme to use, or nil to use the default colors
	///   - cellSize: The size of each color cell
	///   - spacing: The spacing between each color cell
	///   - displaySettings: The components of the color picker to present
	///   - selectedColor: A binding to the selected color
	public init(
		named name: String? = nil,
		theme: DSFColorPickerTheme = DSFColorPickerTheme(),
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
	/// - Parameters:
	///   - name: The name for the picker (eg. 'Stroke color')
	///   - theme: The theme to use, or nil to use the default colors
	///   - cellSize: The size of each color cell
	///   - spacing: The spacing between each color cell
	///   - displaySettings: The components of the color picker to present
	///   - selectedColor: A binding to the selected color
	public init(
		named name: String? = nil,
		theme: DSFColorPickerTheme = DSFColorPickerTheme(),
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
	let theme: DSFColorPickerTheme
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
		/// Show the palette picker
		public static let palettes = DisplaySettings(rawValue: 1 << 6)
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
		picker.showPalettes = self.displaySettings.contains(.palettes)
		picker.theme = self.theme
		picker.selectedPalette = self.theme.first()
		picker.colorSelectedCallback = { newColor in
			let rgb = RGBAColor(newColor ?? .clear) ?? RGBAColor()
			let c = Color(.sRGB, red: rgb.R, green: rgb.G, blue: rgb.B, opacity: rgb.A)
			DispatchQueue.main.async {
				self.selectedColor = c
			}
		}

		// Select the first palette in the theme
		picker.selectedPalette = theme.first()

		// Lastly, set the selected color
		picker.selectedColor = NSColor(self.selectedColor)

		return v
	}

	public func updateNSView(_ nsView: Container, context: Context) {
		let n1 = nsView.pickerView.selectedColor
		let n2 = NSColor(self.selectedColor)
		if n1?.isMostlyEqualTo(n2) == false {
			nsView.pickerView.selectedColor = n2
		}
	}

	/// A default color theme for the SwiftUI color picker
	public static let DefaultPalette: DSFColorPickerPalette = {
		let colorLiterals = [
			[#colorLiteral(red: 0.880, green: 0.929, blue: 0.831, alpha: 1), #colorLiteral(red: 0.970, green: 0.983, blue: 0.859, alpha: 1), #colorLiteral(red: 0.991, green: 0.994, blue: 0.862, alpha: 1), #colorLiteral(red: 0.997, green: 0.949, blue: 0.831, alpha: 1), #colorLiteral(red: 1.000, green: 0.928, blue: 0.833, alpha: 1), #colorLiteral(red: 1.000, green: 0.886, blue: 0.837, alpha: 1), #colorLiteral(red: 0.998, green: 0.857, blue: 0.848, alpha: 1), #colorLiteral(red: 0.971, green: 0.829, blue: 0.876, alpha: 1), #colorLiteral(red: 0.941, green: 0.790, blue: 0.998, alpha: 1), #colorLiteral(red: 0.846, green: 0.791, blue: 0.999, alpha: 1), #colorLiteral(red: 0.832, green: 0.887, blue: 0.998, alpha: 1), #colorLiteral(red: 0.791, green: 0.941, blue: 0.999, alpha: 1)],
			[#colorLiteral(red: 0.799, green: 0.912, blue: 0.711, alpha: 1), #colorLiteral(red: 0.950, green: 0.964, blue: 0.720, alpha: 1), #colorLiteral(red: 1.000, green: 0.979, blue: 0.726, alpha: 1), #colorLiteral(red: 1.000, green: 0.893, blue: 0.664, alpha: 1), #colorLiteral(red: 0.999, green: 0.851, blue: 0.660, alpha: 1), #colorLiteral(red: 1.000, green: 0.772, blue: 0.672, alpha: 1), #colorLiteral(red: 0.996, green: 0.713, blue: 0.682, alpha: 1), #colorLiteral(red: 0.958, green: 0.638, blue: 0.753, alpha: 1), #colorLiteral(red: 0.890, green: 0.576, blue: 0.996, alpha: 1), #colorLiteral(red: 0.693, green: 0.549, blue: 0.995, alpha: 1), #colorLiteral(red: 0.657, green: 0.777, blue: 0.998, alpha: 1), #colorLiteral(red: 0.584, green: 0.890, blue: 0.992, alpha: 1)],
			[#colorLiteral(red: 0.694, green: 0.868, blue: 0.543, alpha: 1), #colorLiteral(red: 0.923, green: 0.950, blue: 0.562, alpha: 1), #colorLiteral(red: 1.000, green: 0.972, blue: 0.585, alpha: 1), #colorLiteral(red: 1.000, green: 0.845, blue: 0.465, alpha: 1), #colorLiteral(red: 0.999, green: 0.778, blue: 0.466, alpha: 1), #colorLiteral(red: 1.000, green: 0.647, blue: 0.492, alpha: 1), #colorLiteral(red: 0.995, green: 0.552, blue: 0.510, alpha: 1), #colorLiteral(red: 0.932, green: 0.441, blue: 0.620, alpha: 1), #colorLiteral(red: 0.827, green: 0.340, blue: 0.995, alpha: 1), #colorLiteral(red: 0.526, green: 0.306, blue: 0.995, alpha: 1), #colorLiteral(red: 0.455, green: 0.659, blue: 0.993, alpha: 1), #colorLiteral(red: 0.327, green: 0.837, blue: 0.988, alpha: 1)],
			[#colorLiteral(red: 0.590, green: 0.827, blue: 0.374, alpha: 1), #colorLiteral(red: 0.897, green: 0.936, blue: 0.396, alpha: 1), #colorLiteral(red: 1.000, green: 0.969, blue: 0.420, alpha: 1), #colorLiteral(red: 0.995, green: 0.796, blue: 0.246, alpha: 1), #colorLiteral(red: 1.000, green: 0.704, blue: 0.248, alpha: 1), #colorLiteral(red: 0.998, green: 0.524, blue: 0.276, alpha: 1), #colorLiteral(red: 0.998, green: 0.383, blue: 0.315, alpha: 1), #colorLiteral(red: 0.903, green: 0.228, blue: 0.480, alpha: 1), #colorLiteral(red: 0.744, green: 0.218, blue: 0.957, alpha: 1), #colorLiteral(red: 0.367, green: 0.188, blue: 0.920, alpha: 1), #colorLiteral(red: 0.224, green: 0.534, blue: 0.995, alpha: 1), #colorLiteral(red: 0.000, green: 0.778, blue: 0.988, alpha: 1)],
			[#colorLiteral(red: 0.465, green: 0.733, blue: 0.256, alpha: 1), #colorLiteral(red: 0.850, green: 0.926, blue: 0.216, alpha: 1), #colorLiteral(red: 0.997, green: 0.986, blue: 0.251, alpha: 1), #colorLiteral(red: 0.998, green: 0.780, blue: 0.011, alpha: 1), #colorLiteral(red: 0.998, green: 0.667, blue: 0.024, alpha: 1), #colorLiteral(red: 0.995, green: 0.423, blue: 0.000, alpha: 1), #colorLiteral(red: 1.000, green: 0.254, blue: 0.077, alpha: 1), #colorLiteral(red: 0.723, green: 0.175, blue: 0.365, alpha: 1), #colorLiteral(red: 0.599, green: 0.165, blue: 0.738, alpha: 1), #colorLiteral(red: 0.301, green: 0.133, blue: 0.705, alpha: 1), #colorLiteral(red: 0.008, green: 0.380, blue: 0.999, alpha: 1), #colorLiteral(red: 0.000, green: 0.639, blue: 0.846, alpha: 1)],
			[#colorLiteral(red: 0.404, green: 0.610, blue: 0.208, alpha: 1), #colorLiteral(red: 0.764, green: 0.819, blue: 0.092, alpha: 1), #colorLiteral(red: 0.958, green: 0.926, blue: 0.000, alpha: 1), #colorLiteral(red: 0.827, green: 0.618, blue: 0.006, alpha: 1), #colorLiteral(red: 0.833, green: 0.521, blue: 0.000, alpha: 1), #colorLiteral(red: 0.850, green: 0.315, blue: 0.000, alpha: 1), #colorLiteral(red: 0.888, green: 0.136, blue: 0.002, alpha: 1), #colorLiteral(red: 0.599, green: 0.147, blue: 0.311, alpha: 1), #colorLiteral(red: 0.483, green: 0.128, blue: 0.621, alpha: 1), #colorLiteral(red: 0.220, green: 0.101, blue: 0.579, alpha: 1), #colorLiteral(red: 0.001, green: 0.341, blue: 0.836, alpha: 1), #colorLiteral(red: 0.003, green: 0.548, blue: 0.705, alpha: 1)],
			[#colorLiteral(red: 0.306, green: 0.478, blue: 0.151, alpha: 1), #colorLiteral(red: 0.601, green: 0.649, blue: 0.069, alpha: 1), #colorLiteral(red: 0.766, green: 0.737, blue: 0.000, alpha: 1), #colorLiteral(red: 0.652, green: 0.482, blue: 0.000, alpha: 1), #colorLiteral(red: 0.664, green: 0.405, blue: 0.000, alpha: 1), #colorLiteral(red: 0.680, green: 0.239, blue: 0.001, alpha: 1), #colorLiteral(red: 0.708, green: 0.106, blue: 0.003, alpha: 1), #colorLiteral(red: 0.475, green: 0.097, blue: 0.240, alpha: 1), #colorLiteral(red: 0.381, green: 0.089, blue: 0.488, alpha: 1), #colorLiteral(red: 0.173, green: 0.075, blue: 0.465, alpha: 1), #colorLiteral(red: 0.004, green: 0.260, blue: 0.666, alpha: 1), #colorLiteral(red: 0.010, green: 0.429, blue: 0.561, alpha: 1)],
			[#colorLiteral(red: 0.217, green: 0.339, blue: 0.103, alpha: 1), #colorLiteral(red: 0.432, green: 0.463, blue: 0.035, alpha: 1), #colorLiteral(red: 0.554, green: 0.524, blue: 0.006, alpha: 1), #colorLiteral(red: 0.473, green: 0.341, blue: 0.001, alpha: 1), #colorLiteral(red: 0.476, green: 0.291, blue: 0.004, alpha: 1), #colorLiteral(red: 0.485, green: 0.161, blue: 0.002, alpha: 1), #colorLiteral(red: 0.515, green: 0.067, blue: 0.000, alpha: 1), #colorLiteral(red: 0.334, green: 0.062, blue: 0.166, alpha: 1), #colorLiteral(red: 0.270, green: 0.052, blue: 0.354, alpha: 1), #colorLiteral(red: 0.101, green: 0.038, blue: 0.323, alpha: 1), #colorLiteral(red: 0.000, green: 0.184, blue: 0.480, alpha: 1), #colorLiteral(red: 0.000, green: 0.302, blue: 0.397, alpha: 1)],
			[#colorLiteral(red: 0.151, green: 0.240, blue: 0.059, alpha: 1), #colorLiteral(red: 0.312, green: 0.337, blue: 0.012, alpha: 1), #colorLiteral(red: 0.405, green: 0.378, blue: 0.000, alpha: 1), #colorLiteral(red: 0.338, green: 0.240, blue: 0.000, alpha: 1), #colorLiteral(red: 0.338, green: 0.207, blue: 0.000, alpha: 1), #colorLiteral(red: 0.357, green: 0.107, blue: 0.000, alpha: 1), #colorLiteral(red: 0.365, green: 0.027, blue: 0.000, alpha: 1), #colorLiteral(red: 0.232, green: 0.031, blue: 0.111, alpha: 1), #colorLiteral(red: 0.180, green: 0.027, blue: 0.245, alpha: 1), #colorLiteral(red: 0.068, green: 0.018, blue: 0.229, alpha: 1), #colorLiteral(red: 0.001, green: 0.118, blue: 0.342, alpha: 1), #colorLiteral(red: 0.002, green: 0.215, blue: 0.289, alpha: 1)],
			[#colorLiteral(red: 0.000, green: 0.000, blue: 0.004, alpha: 1), #colorLiteral(red: 0.574, green: 0.568, blue: 0.573, alpha: 1), #colorLiteral(red: 1.000, green: 1.000, blue: 1.000, alpha: 1), #colorLiteral(red: 0.667, green: 0.476, blue: 0.256, alpha: 1), #colorLiteral(red: 0.574, green: 0.132, blue: 0.571, alpha: 1), #colorLiteral(red: 1.000, green: 0.251, blue: 1.000, alpha: 1), #colorLiteral(red: 0.020, green: 0.199, blue: 0.998, alpha: 1), #colorLiteral(red: 0.000, green: 0.993, blue: 0.999, alpha: 1), #colorLiteral(red: 0.045, green: 0.975, blue: 0.001, alpha: 1), #colorLiteral(red: 0.997, green: 0.986, blue: 0.000, alpha: 1), #colorLiteral(red: 0.997, green: 0.577, blue: 0.016, alpha: 1), #colorLiteral(red: 1.000, green: 0.146, blue: 0.003, alpha: 1)],
			[#colorLiteral(red: 0.000, green: 0.000, blue: 0.004, alpha: 1), #colorLiteral(red: 0.137, green: 0.137, blue: 0.137, alpha: 1), #colorLiteral(red: 0.262, green: 0.267, blue: 0.267, alpha: 1), #colorLiteral(red: 0.376, green: 0.376, blue: 0.376, alpha: 1), #colorLiteral(red: 0.478, green: 0.478, blue: 0.478, alpha: 1), #colorLiteral(red: 0.572, green: 0.573, blue: 0.572, alpha: 1), #colorLiteral(red: 0.672, green: 0.667, blue: 0.667, alpha: 1), #colorLiteral(red: 0.753, green: 0.753, blue: 0.753, alpha: 1), #colorLiteral(red: 0.839, green: 0.839, blue: 0.835, alpha: 1), #colorLiteral(red: 0.917, green: 0.922, blue: 0.922, alpha: 1), #colorLiteral(red: 1.000, green: 1.000, blue: 1.000, alpha: 1), #colorLiteral(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)],
		]

		// Map to top left
		let colors: [[NSColor]] =
		colorLiterals.reversed().map { row in
			row.reversed().map { colorLiteral in
				return colorLiteral
			}
		}

		return DSFColorPickerPalette(name: "Preview", colors: colors)
	}()

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
