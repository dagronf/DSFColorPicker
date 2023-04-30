//
//  DSFColorPickerViewController.swift
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

// MARK: - Color picker view

@IBDesignable open class DSFColorPickerView: NSView {
	//static let defaultThemes = DSFColorPickerThemes()

//	open override func acceptsFirstMouse(for event: NSEvent?) -> Bool {
//		return true
//	}

	// MARK: - Notification definitions and callbacks

	public class ColorNotification {
		public static let name = "DSFColorPickerViewColorSelected"
		public static let selectedColor = "selectedColor"
	}

	/// Optional callback if you don't want to rely on notifications
	public var colorSelectedCallback: ((NSColor?) -> Void)?

	/// Posted whenever the selected color changes. Dictionary key for selected color
	public static let colorSelectedNotification = NSNotification.Name(ColorNotification.name)

	// MARK: - Inspectable properties

	/// String identifier, used for voiceover to identify which picker is selected and for saving recents
	@IBInspectable public var name: String = "" {
		didSet {
			self.colorPickerStack.setName(name: self.name)
			if !self.name.isEmpty {
				self.recentsUserDefaultsKey = "\(self.name).__RecentColors"
			}
			else {
				self.recentsUserDefaultsKey = nil
			}
		}
	}

	/// The currently assigned theme
	@IBOutlet public var theme: DSFColorPickerTheme! = DSFColorPickerTheme()

	/// Primarily used for inspectable support, to see a palette in interface builder
	@IBInspectable public var namedTheme: String?

	/// Show or hide the themes popup button
	@IBInspectable public var showPalettes: Bool = false

	/// Show or hide the button with the currently selected color
	@IBInspectable public var showCurrent: Bool = true

	/// Show or hide the recent colors list
	@IBInspectable public var showRecents: Bool = true

	/// Show or hide the titles in the control
	@IBInspectable public var showTitles: Bool = true

	/// Show or hide the color dropper
	@IBInspectable public var showColorDropper: Bool = true

	/// Show or hide the 'show colors' button
	@IBInspectable public var showColorPaletteButton: Bool = false

	/// Cell width and height
	@IBInspectable public var cellWidth: CGFloat = 30
	@IBInspectable public var cellHeight: CGFloat = 30

	/// Spacing between the cells
	@IBInspectable public var horizontalSpacing: CGFloat = 4
	@IBInspectable public var verticalSpacing: CGFloat = 4

	// MARK: - Modifiable properties

	/// The theme being used for the picker.  If nil, uses the default built-in theme
	public var selectedPalette: DSFColorPickerPalette? {
		didSet {
			self.updateLayoutForSelectedPalette()
		}
	}

	/// The number of columns in the color grid
	public var colCount: Int {
		// Theme dictates the number of columns
		return self.selectedPalette?.colCount ?? 0
	}

	/// The number of rows in the color grid
	public var rowCount: Int {
		// Theme dictates the number of rows
		return self.selectedPalette?.rowCount ?? 0
	}

	/// The color that's currently selected in the control
	@objc public var selectedColor: NSColor? {
		didSet {
			self.selectedColorButton?.color = self.selectedColor
			self.selectedColorButton?.isEnabled = self.selectedColor != nil

			/// If the color panel button is visible, push the change through to it too
			self.colorPanelButton?.selectedColor = selectedColor ?? .clear

			/// Callback if one is defined
			self.colorSelectedCallback?(self.selectedColor)

			/// Tell anyone that we've changed
			NotificationCenter.default.post(
				name: DSFColorPickerView.colorSelectedNotification,
				object: self,
				userInfo: [ColorNotification.selectedColor: self.selectedColor as Any]
			)

			self.syncButtonsWithSelection()
		}
	}

	// MARK: - Properties

	var selectedColorButton: DSFColorPickerButton?
	var recentColorButtons: [DSFColorPickerButton] = []

	/// The array of colors currently marked as 'recent'
	var recentColors: [NSColor?] = []

	/// Color stack
	let colorPickerStack = DFColorPickerStack()

	///
	var allColorButtons: [DSFColorPickerButton] = []

	/// If the control has 'show color panel' set, the button
	var colorPanelButton: ColorPanelButton?

	/// The recents userDefaults keys
	internal var recentsUserDefaultsKey: String?

	override init(frame frameRect: NSRect) {
		super.init(frame: frameRect)
		self.setup()

		// Set an initial theme for the view
		//self.configureTheme()
	}

	public required init?(coder decoder: NSCoder) {
		super.init(coder: decoder)
		self.setup()
	}
}
