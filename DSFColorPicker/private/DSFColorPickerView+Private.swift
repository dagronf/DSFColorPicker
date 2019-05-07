//
//  DSFColorPickerView+Private.swift
//  DSFColorPicker
//
//  Created by Darren Ford on 2/1/19.
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

import Cocoa

extension DSFColorPickerView {
	public class DFColorPickerStack: NSStackView, NSAccessibilityGroup {
		override init(frame frameRect: NSRect) {
			super.init(frame: frameRect)
			self.setup()
		}

		required init?(coder decoder: NSCoder) {
			super.init(coder: decoder)
			self.setup()
		}

		func setup() {
			self.translatesAutoresizingMaskIntoConstraints = false
			self.spacing = 2
			self.orientation = .vertical
			self.setContentHuggingPriority(.defaultHigh, for: .horizontal)
			self.setContentHuggingPriority(.defaultHigh, for: .vertical)

			self.setHuggingPriority(.required, for: .horizontal)

			self.setContentCompressionResistancePriority(.required, for: .horizontal)
			self.setContentCompressionResistancePriority(.required, for: .vertical)

			let selColorLabel = NSLocalizedString("Color selector", comment: "Accessibility label")
			self.setAccessibilityLabel(selColorLabel)
			self.setAccessibilityRole(NSAccessibility.Role.group)
		}

		func setName(name: String) {
			let selColorLabel = NSLocalizedString("%1@ Color Selector", comment: "Accessibility label")
			let label = String(format: selColorLabel, name)
			self.setAccessibilityLabel(label)
		}
	}
}

// MARK: - Theme handling

extension DSFColorPickerView {
	@objc open func themes() -> DSFColorPickerThemes {
		// Return the built in theme
		return DSFColorPickerView.defaultThemes
	}

	func configureTheme() {
		if self.selectedTheme == nil, !self.namedTheme.isEmpty {
			self.selectedTheme = self.themes().theme(named: self.namedTheme)
		}
	}
}

// MARK: Handling interactions

private extension DSFColorPickerView {
	private func updateRecents(_ color: NSColor) {
		guard self.showRecents else {
			return
		}

		self.recentColors = self.recentColors.filter { $0 != color }
		self.recentColors.insert(color, at: 0)
		self.recentColors = Array(self.recentColors.prefix(self.colCount))

		self.recentColorButtons.enumerated().forEach {
			$0.element.color = self.recentColors[$0.offset]
		}

		self.saveRecents()
	}

	func loadRecents() {
		if !self.name.isEmpty,
			let data = UserDefaults.standard.data(forKey: "\(self.name).RecentColors"),
			let recents = NSUnarchiver.unarchiveObject(with: data) as? [NSColor?],
			let theme = self.selectedTheme {
			let arrsiz = min(recents.count, theme.colCount)
			self.recentColors = Array(recents[0 ..< arrsiz])
		} else {
			self.recentColors = Array<NSColor?>.init(repeating: nil, count: self.colCount)
		}
	}

	func saveRecents() {
		let data = NSArchiver.archivedData(withRootObject: self.recentColors)
		UserDefaults.standard.set(data, forKey: "\(self.name).RecentColors")
	}

	@objc private func buttonPress(_ sender: DSFColorPickerButton) {
		if let color = sender.color {
			self.selectedColor = color
			self.updateRecents(color)
		}
	}
}

extension DSFColorPickerView {
	open override func awakeFromNib() {
		self.configureTheme()
	}

	func setup() {
		self.translatesAutoresizingMaskIntoConstraints = false
		self.colorPickerStack.frame = self.frame
		self.addSubview(self.colorPickerStack)
		self.colorPickerStack.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
		self.colorPickerStack.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
		self.colorPickerStack.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
		self.colorPickerStack.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true

		NotificationCenter.default.addObserver(
			self,
			selector: #selector(self.themeChanged(_:)),
			name: NSNotification.Name("AppleInterfaceThemeChangedNotification"),
			object: nil
		)
	}

	@objc func themeChanged(_: Notification) {
		self.needsDisplay = true
	}

	open override func prepareForInterfaceBuilder() {
		self.configureTheme()
		self.invalidateIntrinsicContentSize()
		self.frame = self.colorPickerStack.frame
	}

	open override var intrinsicContentSize: NSSize {
		return self.colorPickerStack.fittingSize
	}
}

// MARK: - View Configuration

extension DSFColorPickerView {
	func updateLayoutForTheme() {
		self.allColorButtons.removeAll()
		self.recentColorButtons.removeAll()
		self.colorPickerStack.arrangedSubviews.forEach { $0.removeFromSuperview() }

		self.colorPickerStack.arrangedSubviews.forEach { self.colorPickerStack.removeArrangedSubview($0) }

		let selColorLabel = NSLocalizedString("Selected", comment: "The currently selected color")
		let recColorLabel = NSLocalizedString("Recent", comment: "The set of previously selected colors")
		let preColorLabel = NSLocalizedString("Preset", comment: "The set of predefined colors")
		let themeColorLabel = NSLocalizedString("Themes", comment: "The available themes to choose from")

		if self.showThemes && self.themes().themeNames().count > 0 {
			self.colorPickerStack.addArrangedSubview(self.configureLabel(themeColorLabel))
			let popover = self.configureThemeChooser()
			self.colorPickerStack.addArrangedSubview(popover)
		}

		if self.showCurrent {
			if self.showTitles {
				self.colorPickerStack.addArrangedSubview(self.configureLabel(selColorLabel))
			}
			self.colorPickerStack.addArrangedSubview(self.configureCurrent())
		}
		if self.showRecents {
			if self.showTitles {
				self.colorPickerStack.addArrangedSubview(self.configureLabel(recColorLabel))
			}
			self.colorPickerStack.addArrangedSubview(self.configureRecents())
		}
		if self.showRecents || self.showCurrent {
			if self.showTitles {
				self.colorPickerStack.addArrangedSubview(self.configureLabel(preColorLabel))
			} else {
				let box = NSBox(frame: NSRect(x: 0, y: 0, width: 20, height: 1))
				box.boxType = .separator
				self.colorPickerStack.addArrangedSubview(box)
			}
		}
		self.colorPickerStack.addArrangedSubview(self.configureGrid())

		self.colorPickerStack.needsLayout = true
		self.colorPickerStack.needsUpdateConstraints = true

		self.invalidateIntrinsicContentSize()
	}

	@IBAction func userChangedTheme(_ sender: NSPopUpButton) {
		let themeName = sender.title
		if let newTheme = self.themes().theme(named: themeName) {
			self.namedTheme = themeName
			self.selectedTheme = newTheme
		}
	}

	/// Create a text label for use in the color grid
	private func configureLabel(_ labelText: String) -> NSTextField {
		let label = NSTextField()
		label.stringValue = labelText
		label.isBordered = false
		label.isEditable = false
		label.isSelectable = false
		label.font = NSFont.systemFont(ofSize: 11)
		label.drawsBackground = false
		label.setContentHuggingPriority(
			NSLayoutConstraint.Priority.fittingSizeCompression,
			for: .horizontal
		)
		return label
	}

	/// Set up the button style for the 'currently selected' color button
	private func configureCurrent() -> NSStackView {
		let hStack = NSStackView()
		hStack.translatesAutoresizingMaskIntoConstraints = false
		hStack.orientation = .horizontal
		hStack.spacing = 4.0

		let button = DSFColorPickerButton(frame: NSMakeRect(0, 0, self.cellWidth, self.cellHeight))
		button.title = ""
		button.bezelStyle = .texturedSquare
		button.isBordered = false // Important
		button.wantsLayer = true
		button.action = #selector(self.buttonPress(_:))
		button.target = self
		button.canDrop = true

		button.addConstraint(
			NSLayoutConstraint(
				item: button,
				attribute: .height,
				relatedBy: .equal,
				toItem: nil,
				attribute: .notAnAttribute,
				multiplier: 1,
				constant: self.cellHeight
			)
		)

		button.setContentHuggingPriority(
			NSLayoutConstraint.Priority.fittingSizeCompression,
			for: .horizontal
		)
		self.selectedColorButton = button
		hStack.addArrangedSubview(button)

		if showColorDropper {
			let picker = NSButton()
			picker.translatesAutoresizingMaskIntoConstraints = false
			picker.isBordered = false
			picker.image = NSImage(cgImage: colorPickerIconImage(), size: NSSize(width: 16, height: 16))
			picker.image!.isTemplate = true
			picker.action = #selector(self.colorPicker(_:))
			picker.target = self
			picker.toolTip = NSLocalizedString("Pick a color on the screen", comment: "Displays a color loupe to allow the user to select a color on the screen")
			hStack.addArrangedSubview(picker)
		}

		return hStack
	}

	@objc func colorPicker(_: Any) {
		DSFColorPickerLoupe.shared.pick { selectedColor in
			self.selectedColor = selectedColor
			self.updateRecents(selectedColor)
		}
	}

	private func configureThemeChooser() -> NSPopUpButton {
		let popover = NSPopUpButton(frame: NSMakeRect(0, 0, self.cellWidth, self.cellHeight))
		popover.addConstraint(
			NSLayoutConstraint(
				item: popover,
				attribute: .height,
				relatedBy: .equal,
				toItem: nil,
				attribute: .notAnAttribute,
				multiplier: 1,
				constant: self.cellHeight
			))

		popover.removeAllItems()

		let names = self.themes().themeNames().sorted()
		popover.addItems(withTitles: names)
		popover.selectItem(withTitle: self.namedTheme)

		popover.action = #selector(self.userChangedTheme(_:))
		popover.target = self

		return popover
	}

	private func configureRecents() -> NSView {
		self.recentColors = Array<NSColor?>.init(repeating: nil, count: self.colCount)
		self.loadRecents()

		var grid: [[NSView]] = []
		var row: [NSView] = []
		for i in 0 ..< self.colCount {
			let bt = self.createButton(self.recentColors[i])
			bt.canDrop = false
			bt.color = self.recentColors[i]
			self.recentColorButtons.append(bt)
			row.append(bt)
		}
		grid.append(row)

		let gridView = NSGridView(views: grid)
		gridView.rowSpacing = self.verticalSpacing
		gridView.columnSpacing = self.horizontalSpacing
		gridView.translatesAutoresizingMaskIntoConstraints = false
		return gridView
	}

	func syncButtonsWithSelection() {
		for button in self.allColorButtons {
			let curState = (button.state == .on)
			let newState = (self.selectedColor == button.color)
			if curState != newState {
				button.state = newState ? .on : .off
				button.needsDisplay = true
			}
		}
	}

	private func configureGrid() -> NSView {
		var colorButtons: [[NSView]] = []
		var count = 0
		for rowCount in 0 ..< self.rowCount {
			var row: [NSView] = []
			for colCount in 0 ..< self.colCount {
				let color = self.selectedTheme?.colorAt(rowCount, colCount)
				let button = self.createButton(color)
				button.showSelected = true
				self.allColorButtons.append(button)
				row.append(button)
				count += 1
			}
			colorButtons.append(row)
		}

		let gridView = NSGridView(views: colorButtons)
		gridView.wantsLayer = true
		gridView.rowSpacing = self.verticalSpacing
		gridView.columnSpacing = self.horizontalSpacing
		gridView.translatesAutoresizingMaskIntoConstraints = false
		return gridView
	}

	private func createButton(_ color: NSColor?) -> DSFColorPickerButton {
		let button = DSFColorPickerButton(frame: NSMakeRect(0, 0, self.cellWidth, self.cellHeight))
		button.title = ""
		button.bezelStyle = .texturedSquare
		button.isBordered = false // Important
		button.wantsLayer = true
		button.action = #selector(self.buttonPress(_:))
		button.target = self
		button.color = color

		button.addConstraint(
			NSLayoutConstraint(
				item: button,
				attribute: .height,
				relatedBy: .equal,
				toItem: nil,
				attribute: .notAnAttribute,
				multiplier: 1,
				constant: self.cellHeight
			)
		)

		button.addConstraint(
			NSLayoutConstraint(
				item: button,
				attribute: .width,
				relatedBy: .equal,
				toItem: nil,
				attribute: .notAnAttribute,
				multiplier: 1,
				constant: self.cellWidth
			)
		)

		button.needsDisplay = true
		return button
	}
}
