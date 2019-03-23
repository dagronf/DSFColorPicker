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

import Foundation

// MARK: - Color picker

public class DSFColorPickerPopover: NSObject, NSPopoverDelegate
{
	public var popover: NSPopover?

	var controller: DSFColorPickerPopoverViewController?

	class DSFColorPickerPopoverViewController: NSViewController
	{
		var colorView: DSFColorPickerView?

		func configure(name: String)
		{
			self.view = NSView()
			self.view.translatesAutoresizingMaskIntoConstraints = false

			self.colorView = DSFColorPickerView()
			self.colorView!.name = name
			self.view.addSubview(self.colorView!)

			self.colorView!.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 8).isActive = true
			self.colorView!.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 8).isActive = true
			self.colorView!.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -8).isActive = true
			self.colorView!.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -8).isActive = true
		}
	}

	public func showPopover(named name: String, theme: DSFColorPickerTheme, sender: NSView, preferredEdge: NSRectEdge)
	{
		if let openPopover = self.popover
		{
			openPopover.close()
			self.popover = nil
		}

		self.popover = NSPopover()

		let viewController = DSFColorPickerPopoverViewController()
		viewController.configure(name: name)
		viewController.colorView?.selectedTheme = theme

		self.popover?.contentViewController = viewController
		self.popover?.behavior = .semitransient
		self.popover?.delegate = self

		self.popover?.contentSize = viewController.colorView!.fittingSize

		self.popover?.show(relativeTo: sender.bounds, of: sender, preferredEdge: preferredEdge)
	}

	public func popoverDidClose(_ notification: Notification)
	{
		self.popover = nil
	}
}
