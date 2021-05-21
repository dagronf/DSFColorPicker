//
//  DSFColorPickerPopover.swift
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

import AppKit

// MARK: - Color picker

public class DSFColorPickerPopover: NSObject, NSPopoverDelegate {
	public var popover: NSPopover?

	var controller: DSFColorPickerPopoverViewController?

	class DSFColorPickerPopoverViewController: NSViewController {
		var colorView: DSFColorPickerView?

		internal func configure(name: String) -> DSFColorPickerView {
			self.view = NSView()
			self.view.translatesAutoresizingMaskIntoConstraints = false

			let colorpickerView = DSFColorPickerView()

			colorpickerView.name = name
			self.view.addSubview(colorpickerView)

			colorpickerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 8).isActive = true
			colorpickerView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 8).isActive = true
			colorpickerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -8).isActive = true
			colorpickerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -8).isActive = true

			self.colorView = colorpickerView

			return colorpickerView
		}
	}

	public func showPopover(
		named name: String, theme: DSFColorPickerTheme,
		showThemes: Bool = false,
		showCurrent: Bool = true,
		showRecents: Bool = true,
		showTitles: Bool = true,
		showColorDropper: Bool = true,
		showColorPanelButton: Bool = false,
		sender: NSView, preferredEdge: NSRectEdge) {

		if let openPopover = self.popover {
			openPopover.close()
			self.popover = nil
		}

		self.popover = NSPopover()

		let viewController = DSFColorPickerPopoverViewController()

		// Configure the color picker view

		let colorView = viewController.configure(name: name)
		colorView.selectedTheme = theme
		colorView.showThemes = showThemes
		colorView.showCurrent = showCurrent
		colorView.showRecents = showRecents
		colorView.showTitles = showTitles
		colorView.showColorDropper = showColorDropper
		colorView.showColorPaletteButton = showColorPanelButton

		colorView.updateLayoutForTheme()

		// Configure the popover

		let colorPickerPopover = NSPopover()
		self.popover = colorPickerPopover

		colorPickerPopover.contentViewController = viewController
		colorPickerPopover.behavior = .semitransient
		colorPickerPopover.delegate = self
		colorPickerPopover.contentSize = colorView.fittingSize

		// And show it!

		colorPickerPopover.show(relativeTo: sender.bounds, of: sender, preferredEdge: preferredEdge)
	}

	public func popoverDidClose(_: Notification) {
		self.popover = nil
		NSColorPanel.shared.setTarget(nil)
	}
}
