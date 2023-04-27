//
//  ColorPickerButton.swift
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

import Foundation
import AppKit

import DSFAppearanceManager

// Internal class for displaying the system color panel and handling the
// well interactions
internal class ColorPickerButton: NSButton, DSFAppearanceCacheNotifiable {
	override init(frame frameRect: NSRect) {
		super.init(frame: frameRect)
		self.setup()
	}
	required init?(coder: NSCoder) {
		fatalError()
	}

	// Color change handling
	var colorObserver: NSKeyValueObservation?
	var colorChange: ((NSColor) -> Void)?

	// A 'fake' colorwell for handling color well
	private let fakeWell = FakeColorWell()

	func setup() {
		self.translatesAutoresizingMaskIntoConstraints = false
		self.wantsLayer = true

		self.toolTip = NSLocalizedString("Show the system color panel", comment: "")

		self.layer!.cornerRadius = 4
		self.layer!.borderWidth = 3

		let fixedSize = CGSize(width: 22, height: 22)
		let filter = CIFilter(
			name: "CIHueSaturationValueGradient",
			parameters: [
				"inputValue": 1.0,
				"inputRadius": 24.0,
				"inputSoftness": 1.0,
				"inputDither": 1.0
			]
		)!
		let output = filter.outputImage!
		let rep = NSCIImageRep(ciImage: output)
		let updateImage = NSImage(size: .init(width: 15, height: 15))
		updateImage.addRepresentation(rep)

		self.isBordered = false

		self.bezelStyle = .regularSquare
		self.setButtonType(.onOff)
		self.image = updateImage
		self.imageScaling = .scaleNone
		self.imagePosition = .imageOnly
		self.action = #selector(self.userClickedShowColors(_:))
		self.target = self

		let c1 = NSLayoutConstraint.init(
			item: self, attribute: .width, relatedBy: .equal,
			toItem: nil, attribute: .notAnAttribute,
			multiplier: 1, constant: fixedSize.width)
		let c2 = NSLayoutConstraint.init(
			item: self, attribute: .height, relatedBy: .equal,
			toItem: nil, attribute: .notAnAttribute,
			multiplier: 1, constant: fixedSize.height)
		self.addConstraints([c1, c2])

		// Listen to see if the well is deactivated, and update accordingly
		self.fakeWell.didDeactivate = { [weak self] in
			guard let `self` = self else { return }
			self.state = .off
			self.deactivate()
		}

		// Listen for changes to the color in our fake well
		self.colorObserver = self.fakeWell.observe(\.color, options: [.old, .new], changeHandler: { [weak self] obj, change in
			if let value = change.newValue {
				self?.colorChange?(value)
			}
		})

		self.updateForCurrentState()

		// Register for theme updates so we can re-draw
		DSFAppearanceCache.shared.register(self)
	}

	// Called when the system appearance changes
	func appearanceDidChange() {
		self.usingEffectiveAppearance {
			if self.fakeWell.isActive {
				self.layer!.borderColor = NSColor.secondaryLabelColor.cgColor
			}
			else {
				self.layer!.borderColor = .clear
			}
		}
	}

	/// Called when the user clicks on the button
	@objc func userClickedShowColors(_ sender: NSButton) {
		self.updateForCurrentState()
	}

	func activate() {
		self.usingEffectiveAppearance {
			self.layer!.borderColor = NSColor.secondaryLabelColor.cgColor
		}
		self.fakeWell.activate(true)
	}

	func deactivate() {
		self.layer!.borderColor = .clear
	}

	func updateForCurrentState() {
		if self.state == .off {
			self.fakeWell.deactivate()
			self.deactivate()
		}
		else {
			self.activate()
		}
	}
}

private extension ColorPickerButton {
	// A fake color well that observes its activated state
	// (it appears we can't directly observe \.isActivated via KVO)
	private class FakeColorWell: NSColorWell {
		fileprivate var didDeactivate: (() -> Void)?
		override func deactivate() {
			super.deactivate()
			self.didDeactivate?()
		}
	}
}
