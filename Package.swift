// swift-tools-version: 5.4

import PackageDescription

let package = Package(
	name: "DSFColorPicker",
	defaultLocalization: "en",
	platforms: [
		.macOS(.v10_13)
	],
	products: [
		.library(
			name: "DSFColorPicker",
			targets: ["DSFColorPicker"]),
	],
	dependencies: [
		.package(url: "https://github.com/dagronf/DSFColorSampler", .upToNextMinor(from: "3.0.0")),
		.package(url: "https://github.com/dagronf/DSFAppearanceManager", .upToNextMinor(from: "3.5.0"))
	],
	targets: [
		.target(
			name: "DSFColorPicker",
			dependencies: ["DSFColorSampler", "DSFAppearanceManager"])
	]
)
