//
//  AppDelegate.swift
//  ColorPicker
//
//  Created by Darren Ford on 12/9/18.
//  Copyright © 2018 QSR International. All rights reserved.
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

import DSFColorPicker

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSPopoverDelegate
{
	@IBOutlet weak var window: NSWindow!

	@IBOutlet weak var colorPickerView: DSFColorPickerView!
	@IBOutlet weak var colorPickerViewSelectedColorWell: NSColorWell!
	@IBOutlet weak var colorPickerByNotificationColorWell: NSColorWell!
	@IBOutlet weak var syncedColor: NSColorWell!

	@IBOutlet weak var second: DSFColorPickerView!
	@IBOutlet weak var third: DSFColorPickerView!

	@IBOutlet weak var changeable: CustomPickerView!
	
	// For testing popover support
	public var popover: DSFColorPickerPopover = DSFColorPickerPopover()

	func applicationDidFinishLaunching(_ aNotification: Notification) {
		// Insert code here to initialize your application

		// Need to set this, or else drag/drop loses alpha
		NSColor.ignoresAlpha = false

		// Set up for direct callbacks
		self.colorPickerViewSelectedColorWell.color = NSColor.clear
		self.colorPickerView.colorSelectedCallback = { [weak self] color in
			self?.colorPickerViewSelectedColorWell.color = color ?? NSColor.clear
		}

		// Set up to observe notifications
		self.colorPickerByNotificationColorWell.color = NSColor.clear
		NotificationCenter.default.addObserver(forName: DSFColorPickerView.colorSelectedNotification,
											   object: self.colorPickerView,
											   queue: nil)
		{ [weak self] (notification) in
			if let dict = notification.userInfo,
				let color = dict[DSFColorPickerView.ColorNotification.selectedColor] as? NSColor?
			{
				self?.colorPickerByNotificationColorWell.color = color!
			}
		}
	}

	@IBAction func userDidChangeSyncColor(_ sender: NSColorWell)
	{
		self.colorPickerView.selectedColor = sender.color
	}

	func applicationWillTerminate(_ aNotification: Notification)
	{
		// Insert code here to tear down your application
		NotificationCenter.default.removeObserver(self)
	}

	@IBAction func showPopover(_ sender: NSButton)
	{
		let ps = DefaultPickerViewThemes()
		if let theme = ps.theme(named: "default")
		{
			self.popover.showPopover(
				named: "popover1",
				theme: theme,
				sender: sender,
				preferredEdge: .maxX)
		}
	}

}
