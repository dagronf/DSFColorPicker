//
//  DSFColorPickerPopover.swift
//  DSFColorPicker
//
//  Created by Darren Ford on 4/1/19.
//  Copyright © 2019 Darren Ford. All rights reserved.
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
