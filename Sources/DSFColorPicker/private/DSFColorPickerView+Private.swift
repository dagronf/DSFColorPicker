//
//  DSFColorPickerView+Private.swift
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

import DSFColorSampler

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

			let selColorLabel = _NSLS_("picker.title.blank")
			self.setAccessibilityLabel(selColorLabel)
			self.setAccessibilityRole(NSAccessibility.Role.group)
		}

		func setName(name: String) {
			let selColorLabel = _NSLS_("picker.title.named")
			let label = String(format: selColorLabel, name)
			self.setAccessibilityLabel(label)
		}
	}
}

// MARK: - Theme handling

extension DSFColorPickerView {

	func configurePalette() {
		if self.selectedPalette != nil {
			return
		}

		// If the palette is named, attempt to display the named palette
		if let namedPalette = self.namedTheme,
			let palette = self.theme.palette(named: namedPalette)
		{
			self.selectedPalette = palette
		}

		if self.selectedPalette == nil {
			// Last fallback - if the selected palette is still nil just set the first palette found
			self.selectedPalette = self.theme.first()
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

	@objc private func buttonPress(_ sender: DSFColorPickerButton) {
		if let color = sender.color {
			self.selectedColor = color
			self.updateRecents(color)
		}
	}
}

extension DSFColorPickerView {
	private var userDefaultName: String { "\(self.name).RecentColors" }
	/// attempt to load recents for this (named) color picker from the userdefaults
	func loadRecents() {
		guard let recentsDefaultsName = self.recentsUserDefaultsKey else { return }
		if
			let data = UserDefaults.standard.data(forKey: recentsDefaultsName),
			let recents = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [NSColor?],
			recents.count == self.colCount,
			let theme = self.selectedPalette
		{
			let arrsiz = min(recents.count, theme.colCount)
			self.recentColors = Array(recents[0 ..< arrsiz])
		} else {
			self.recentColors = Array<NSColor?>.init(repeating: nil, count: self.colCount)
		}
	}

	/// Save the recents to the userdefaults
	func saveRecents() {
		guard let recentsDefaultsName = self.recentsUserDefaultsKey else { return }
		let data = try! NSKeyedArchiver.archivedData(withRootObject: self.recentColors, requiringSecureCoding: true)
		UserDefaults.standard.set(data, forKey: recentsDefaultsName)
	}

	/// Clear the recent colors
	public func clearRecents() {
		guard let recentsDefaultsName = self.recentsUserDefaultsKey else { return }
		UserDefaults.standard.removeObject(forKey: recentsDefaultsName)
	}
}

extension DSFColorPickerView {
	open override func awakeFromNib() {
		super.awakeFromNib()
		self.configurePalette()
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
		self.configurePalette()
		self.invalidateIntrinsicContentSize()
		self.frame = self.colorPickerStack.frame
	}

	open override var intrinsicContentSize: NSSize {
		return self.colorPickerStack.fittingSize
	}
}

// MARK: - View Configuration

extension DSFColorPickerView {
	func updateLayoutForSelectedPalette() {
		self.allColorButtons.removeAll()
		self.recentColorButtons.removeAll()
		self.colorPickerStack.arrangedSubviews.forEach { $0.removeFromSuperview() }

		self.colorPickerStack.arrangedSubviews.forEach { self.colorPickerStack.removeArrangedSubview($0) }

		let selColorLabel = _NSLS_("picker.label.selected")
		let recColorLabel = _NSLS_("picker.label.recent")
		let preColorLabel = _NSLS_("picker.label.preset")
		let themeColorLabel = _NSLS_("picker.label.themes")

		// If themes are enabled, show the popup

		if self.showPalettes && self.theme.paletteNames.count > 0 {
			if self.showTitles {
				self.colorPickerStack.addArrangedSubview(self.configureLabel(themeColorLabel))
			}
			let popover = self.configureThemeChooser()
			self.colorPickerStack.addArrangedSubview(popover)
		}

		if !self.showTitles {
			// Give a little more breathing room in the stack
			self.colorPickerStack.spacing = 8
		}
		else {
			self.colorPickerStack.spacing = 2
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
				box.translatesAutoresizingMaskIntoConstraints = false
				box.boxType = .separator
				self.colorPickerStack.addArrangedSubview(box)
			}
		}
		self.colorPickerStack.addArrangedSubview(self.configureGrid())
		self.colorPickerStack.needsLayout = true
		self.colorPickerStack.needsUpdateConstraints = true

		self.invalidateIntrinsicContentSize()
	}

	@IBAction func colorPanelChangedColors(_ sender: NSColorPanel?) {
		self.selectedColor = sender?.color
	}

	@IBAction func userChangedTheme(_ sender: NSPopUpButton) {
		let paletteName = sender.title
		if let selectedPalette = self.theme.palette(named: paletteName) {
			self.namedTheme = paletteName
			self.selectedPalette = selectedPalette
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

		// If we need to show the color picker, do it here.
		if self.showColorDropper {
			let fixedSize = CGSize(width: 16, height: 16)
			let picker = NSButton()
			picker.translatesAutoresizingMaskIntoConstraints = false
			picker.isBordered = false
			picker.image = NSImage(cgImage: colorPickerIconImage(), size: fixedSize)
			picker.image!.isTemplate = true
			picker.action = #selector(self.colorPicker(_:))
			picker.target = self
			picker.toolTip = _NSLS_("picker.colorpicker.tooltip")
			hStack.addArrangedSubview(picker)

			let c1 = NSLayoutConstraint.init(
				item: picker, attribute: .width, relatedBy: .equal,
				toItem: nil, attribute: .notAnAttribute,
				multiplier: 1, constant: fixedSize.width)
			let c2 = NSLayoutConstraint.init(
				item: picker, attribute: .height, relatedBy: .equal,
				toItem: nil, attribute: .notAnAttribute,
				multiplier: 1, constant: fixedSize.height)
			picker.addConstraints([c1, c2])
			picker.needsLayout = true
		}

		if self.showColorPaletteButton {
			let c = ColorPanelButton()
			c.colorChange = { [weak self] color in
				CATransaction.begin()
				CATransaction.setDisableActions(true)
				self?.selectedColor = color
				CATransaction.commit()
			}
			hStack.addArrangedSubview(c)
		}

		return hStack
	}

	@objc func colorPicker(_: Any) {
		DSFColorSampler.selectColor { [weak self] selectedColor in
			if let selectedColor = selectedColor {
				self?.selectedColor = selectedColor
				self?.updateRecents(selectedColor)
			}
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

		let names = self.theme.paletteNames.sorted()
		popover.addItems(withTitles: names)

		let named = self.namedTheme ?? self.theme.first().name

		popover.selectItem(withTitle: named)

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
			let color = i < self.recentColors.count ? self.recentColors[i] : .clear
			let bt = self.createButton(color)
			bt.canDrop = false
			bt.color = color
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
				let color = self.selectedPalette?.colorAt(rowCount, colCount)
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
