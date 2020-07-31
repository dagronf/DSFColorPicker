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
class AppDelegate: NSObject, NSApplicationDelegate, NSPopoverDelegate {
	@IBOutlet var window: NSWindow!

	@IBOutlet var colorPickerView: DSFColorPickerView!
	@IBOutlet var colorPickerViewSelectedColorWell: NSColorWell!
	@IBOutlet var colorPickerByNotificationColorWell: NSColorWell!
	@IBOutlet var syncedColor: NSColorWell!

	@IBOutlet var second: DSFColorPickerView!
	@IBOutlet var third: DSFColorPickerView!

	@IBOutlet var changeable: CustomPickerView!

	@objc var showThemes: Bool = true
	@objc var showRecents: Bool = true
	@objc var showCurrent: Bool = true
	@objc var showTitles: Bool = true
	@objc var showPicker: Bool = true

	// For testing popover support
	public var popover: DSFColorPickerPopover = DSFColorPickerPopover()

	func applicationDidFinishLaunching(_: Notification) {
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
											   queue: nil) { [weak self] notification in
												if let dict = notification.userInfo,
													let color = dict[DSFColorPickerView.ColorNotification.selectedColor] as? NSColor? {
													self?.colorPickerByNotificationColorWell.color = color!
												}
		}
	}

	@IBAction func userDidChangeSyncColor(_ sender: NSColorWell) {
		self.colorPickerView.selectedColor = sender.color
	}

	func applicationWillTerminate(_: Notification) {
		// Insert code here to tear down your application
		NotificationCenter.default.removeObserver(self)
	}

	@IBAction func showPopover(_ sender: NSButton) {
		let ps = DefaultPickerViewThemes()
		if let theme = ps.theme(named: "default") {
			self.popover.showPopover(
				named: "popover1",
				theme: theme,
				showThemes: self.showThemes,
				showCurrent: self.showCurrent,
				showRecents: self.showRecents,
				showTitles: self.showTitles,
				showColorDropper: self.showPicker,
				showColorPanelButton: true,
				sender: sender,
				preferredEdge: .maxX
			)
		}
	}
}
