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

import Cocoa

// Internal class used by the color picker view

internal class DSFColorPickerButton: NSButton {
	private var stateObserver: NSKeyValueObservation?
	var showSelected: Bool = false {
		didSet {
			if self.showSelected {
				self.stateObserver = self.observe(\.cell?.state, options: [.new]) { _, state in
					self.drawLayer?.selected = state.newValue == .on
					self.setNeedsDisplay()
				}
			} else {
				self.stateObserver = nil
			}
		}
	}

	fileprivate class Color {
		let color: CGColor?
		let border: CGColor
		let selectedBorder: CGColor
		let pressed: CGColor?

		init(color: NSColor?, border: NSColor, selectedBorder _: NSColor) {
			self.color = color?.cgColor
			self.border = border.cgColor
			self.selectedBorder = color?.flatContrastColor().cgColor ?? border.cgColor
			self.pressed = color?.darker().cgColor
		}

		func emptyColor() -> Bool {
			return self.color == nil
		}
	}

	fileprivate class Layer: CAShapeLayer {
		let colorLayer: CAShapeLayer
		let triangleLayer: CAShapeLayer
		let opacityLayer: CAShapeLayer
		let dropLayer: CAShapeLayer
		let selectedLayer: CAShapeLayer

		var isPressed: Bool = false

		var isSelectedForDrop: Bool = false
		var selected: Bool = false {
			didSet {
				if self.selected {
					self.addSublayer(self.selectedLayer)
				} else {
					self.selectedLayer.removeFromSuperlayer()
				}
			}
		}

		init(layer: Any, color: DSFColorPickerButton.Color) {
			self.triangleLayer = CAShapeLayer()
			self.colorLayer = CAShapeLayer()
			self.dropLayer = CAShapeLayer()
			self.opacityLayer = CAShapeLayer()
			self.selectedLayer = CAShapeLayer()
			super.init(layer: layer)

			self.addSublayer(self.opacityLayer)
			self.addSublayer(self.colorLayer)
			self.addSublayer(self.triangleLayer)
			self.addSublayer(self.dropLayer)

			self.configure(color: color, frame: (layer as! CALayer).frame)
		}

		required init?(coder _: NSCoder) {
			fatalError("init(coder:) has not been implemented")
		}

		func configure(color: DSFColorPickerButton.Color, frame: NSRect) {
			let inset: CGFloat = 3
			var contentFrame = frame

			if self.isSelectedForDrop {
				contentFrame = contentFrame.insetBy(dx: inset, dy: inset)
			}

			if !color.emptyColor() {
				self.opacityLayer.frame = frame

				let tp = CGMutablePath()
				tp.move(to: NSPoint(x: contentFrame.maxX, y: contentFrame.maxY))
				tp.addLine(to: NSPoint(x: contentFrame.minX, y: contentFrame.minY))
				tp.addLine(to: NSPoint(x: contentFrame.maxX, y: contentFrame.minY))
				tp.addLine(to: NSPoint(x: contentFrame.maxX, y: contentFrame.maxY))
				self.opacityLayer.path = tp
				self.opacityLayer.fillColor = color.border.copy(alpha: 1.0)
			}

			// The border
			self.colorLayer.frame = frame
			self.colorLayer.path = CGPath(rect: contentFrame, transform: nil)
			self.colorLayer.fillColor = self.isPressed ? color.pressed : color.color
			self.colorLayer.strokeColor = color.border
			self.colorLayer.lineWidth = 1.0

			self.triangleLayer.isHidden = !color.emptyColor()
			if color.emptyColor() {
				let offset: CGFloat = self.isSelectedForDrop ? inset : 0

				self.triangleLayer.frame = frame

				let tp = CGMutablePath()
				let triangleHeight = min(contentFrame.height / 3, 12)
				tp.move(to: NSPoint(x: contentFrame.width + offset - 1, y: triangleHeight + offset))
				tp.addLine(to: NSPoint(x: contentFrame.width + offset - triangleHeight, y: 1 + offset))
				tp.addLine(to: NSPoint(x: contentFrame.width + offset - 1, y: 1 + offset))
				tp.addLine(to: NSPoint(x: contentFrame.width + offset - 1, y: triangleHeight + offset))
				self.triangleLayer.path = tp
				self.triangleLayer.fillColor = color.border
			}

			// The selection
			let lineDash: [NSNumber] = [1, 1]
			self.selectedLayer.lineDashPattern = lineDash
			self.selectedLayer.frame = frame
			let insetRect = frame.insetBy(dx: 2, dy: 2)
			self.selectedLayer.path = CGPath(rect: insetRect, transform: nil)
			self.selectedLayer.fillColor = nil
			self.selectedLayer.strokeColor = color.selectedBorder
			self.selectedLayer.lineWidth = 1.0

			self.dropLayer.isHidden = !self.isSelectedForDrop
			if self.isSelectedForDrop {
				self.dropLayer.frame = frame
				self.dropLayer.path = CGPath(rect: frame, transform: nil)
				self.dropLayer.strokeColor = NSColor.systemRed.cgColor
				self.dropLayer.fillColor = nil
				self.dropLayer.lineWidth = inset
			}
		}
	}

	// MARK: Implementation

	private var drawLayer: DSFColorPickerButton.Layer?

	var startDragPoint: NSPoint?
	var canDrop: Bool = false
	var isDrop: Bool = false {
		didSet {
			self.drawLayer?.isSelectedForDrop = self.isDrop
			self.setNeedsDisplay()
		}
	}

	var color: NSColor? {
		didSet {
			self.isEnabled = self.color != nil
			self.setNeedsDisplay()
		}
	}

	override init(frame frameRect: NSRect) {
		super.init(frame: frameRect)
		self.setup()
	}

	required init?(coder: NSCoder) {
		super.init(coder: coder)
		self.setup()
	}

	func setup() {
		self.wantsLayer = true
		self.focusRingType = .default
		self.isBordered = false

		let buttonColor = DSFColorPickerButton.Color(
			color: self.color,
			border: self.borderColor(),
			selectedBorder: self.selectedBorderColor()
		)

		self.drawLayer = DSFColorPickerButton.Layer(
			layer: self.layer!,
			color: buttonColor
		)

		if let drawer = self.drawLayer {
			drawer.frame = self.layer!.bounds
			self.layer?.addSublayer(drawer)
			drawer.setNeedsDisplay()
			self.layer?.setNeedsDisplay()
		}

		self.registerForDraggedTypes([.color])
		self.setAccessibilityRole(NSAccessibility.Role.radioButton)
		self.needsDisplay = true
	}
}

// MARK: Drawing

extension DSFColorPickerButton {
	private func isHighContrast() -> Bool {
		return NSWorkspace.shared.accessibilityDisplayShouldIncreaseContrast
	}

	private func isDarkMode() -> Bool {
		if #available(*, macOS 10.14) {
			let appearance = self.effectiveAppearance.bestMatch(from: [.aqua, .darkAqua])
			return appearance == .darkAqua
		}
		return self.effectiveAppearance.name != .aqua && self.effectiveAppearance.name != .vibrantLight
	}

	private func selectedBorderColor() -> NSColor {
		return NSColor.textColor
	}

	private func borderColor() -> NSColor {
		if self.isHighContrast() {
			return NSColor.textColor
		} else {
			return NSColor.secondaryLabelColor
		}
	}

	override func updateLayer() {
		let buttonColor = DSFColorPickerButton.Color(
			color: self.color,
			border: self.borderColor(),
			selectedBorder: self.selectedBorderColor()
		)
		self.drawLayer?.configure(color: buttonColor, frame: self.bounds)
	}
}

// MARK: Focus ring handling

extension DSFColorPickerButton {
	override func drawFocusRingMask() {
		self.bounds.fill()
	}

	override var focusRingMaskBounds: NSRect {
		return bounds
	}
}

// MARK: Drag drop support

extension DSFColorPickerButton: NSDraggingSource, NSPasteboardItemDataProvider {
	override func acceptsFirstMouse(for _: NSEvent?) -> Bool {
		return true
	}

	override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
		guard self.canDrop else {
			return []
		}

		self.isDrop = true

		let dragSourceMask = sender.draggingSourceOperationMask
		let pasteboard = sender.draggingPasteboard

		if let ptypes = pasteboard.types,
			ptypes.contains(.color),
			dragSourceMask.contains(.generic) {
			self.setNeedsDisplay()
			return [.generic]
		}

		return []
	}

	override func draggingExited(_: NSDraggingInfo?) {
		self.isDrop = false
		self.setNeedsDisplay()
	}

	override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
		self.isDrop = false
		self.setNeedsDisplay()

		let dragSourceMask = sender.draggingSourceOperationMask
		let pasteboard = sender.draggingPasteboard
		if let ptypes = pasteboard.types,
			ptypes.contains(.color),
			dragSourceMask.contains(.generic) {
			self.color = NSColor(from: pasteboard)
			self.performClick(self)
			return true
		}
		return false
	}

	func pasteboard(_ pasteboard: NSPasteboard?, item _: NSPasteboardItem, provideDataForType type: NSPasteboard.PasteboardType) {
		if type == .color,
			let color = self.color {
			color.write(to: pasteboard!)
		}
	}

	func draggingSession(_: NSDraggingSession, sourceOperationMaskFor _: NSDraggingContext) -> NSDragOperation {
		return .generic
	}

	override func mouseDown(with event: NSEvent) {
		self.drawLayer?.isPressed = true
		self.drawLayer?.setNeedsDisplay()
		self.startDragPoint = self.convert(event.locationInWindow, to: nil)
		self.highlight(true)
	}

	override func mouseUp(with _: NSEvent) {
		self.drawLayer?.isPressed = false
		self.drawLayer?.setNeedsDisplay()
		self.startDragPoint = nil
		self.performClick(self)
	}

	private func swatchWithColor(_ color: NSColor, size: NSSize) -> NSImage {
		let im = NSImage(size: size)
		im.lockFocus()
		color.drawSwatch(in: NSMakeRect(0, 0, size.width, size.height))
		im.unlockFocus()
		return im
	}

	private func snapshot() -> NSImage {
		let rep = self.bitmapImageRepForCachingDisplay(in: self.bounds)!
		self.cacheDisplay(in: self.bounds, to: rep)

		let img = NSImage(size: self.bounds.size)
		img.addRepresentation(rep)
		return img
	}

	private func hasDraggedEnough(_ event: NSEvent) -> Bool {
		let pointInView = self.convert(event.locationInWindow, to: nil)
		let xdist = abs(self.startDragPoint!.x - pointInView.x)
		let ydist = abs(self.startDragPoint!.y - pointInView.y)
		return xdist > 2 || ydist > 2
	}

	override func mouseDragged(with event: NSEvent) {
		if self.startDragPoint != nil,
			self.color != nil,
			self.hasDraggedEnough(event) {
			self.drawLayer?.isPressed = false
			self.drawLayer?.setNeedsDisplay()

			let pasteboardItem = NSPasteboardItem()
			pasteboardItem.setDataProvider(self, forTypes: [.color])

			let draggingItem = NSDraggingItem(pasteboardWriter: pasteboardItem)
			draggingItem.setDraggingFrame(
				NSMakeRect(0, 0, 15, 15), // self.bounds,
				contents: self.swatchWithColor(self.color!, size: NSMakeSize(15, 15))
			)

			let draggingSession = beginDraggingSession(with: [draggingItem], event: event, source: self)
			draggingSession.animatesToStartingPositionsOnCancelOrFail = true
			draggingSession.draggingFormation = .none
		}

		super.mouseDragged(with: event)
	}
}
