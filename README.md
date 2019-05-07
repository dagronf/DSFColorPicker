# DSFColorPicker

A Swift UI class to display a customizable color picker for macOS.

![](https://dagronf.github.io/art/projects/DSFColorPicker/general.gif)

### Features

* Themable, allow your users to change between provided themes.
* Configurable color palettes
* Configurable in Interface Builder or by code.
* Color picker support to allow selecting a color from the screen
* Configurable recent colors support
* Drag and drop support

## Configuration

### Interface builder

You can configure your control in interface builder completely.  Drop in a custom view, change the custom type to DSFColorView (or an overload) and choose your display theme using the 'Named Theme' setting in the custom types

<img src="https://dagronf.github.io/art/projects/DSFColorPicker/interface_builder.png" alt="drawing" width="600"/>

[Full size](https://dagronf.github.io/art/projects/DSFColorPicker/interface_builder.png)

### In Code

Configurable using a 2d array of colors, for example 

#### A 5x4 grid

<img src="https://dagronf.github.io/art/projects/DSFColorPicker/default.png" alt="drawing" width="200"/>

[Full size](https://dagronf.github.io/art/projects/DSFColorPicker/default.png)

```swift
	let theme = DSFColorPickerTheme(name: "default", argbValueGrid: [
		[0xF5402C, 0xEB1360, 0x9C1BB1, 0x6634B8, 0x3D4DB7],
		[0x47AE4A, 0x009687, 0x01BBD5, 0x00A6F6, 0x0C93F5],
		[0x89C43F, 0xCCDD1E, 0xFFEC17, 0xFEC001, 0xFF9800],
		[0x000000, 0x5E7C8B, 0x9D9D9D, 0x7A5447, 0xFF5506]]
	)
	self.colorView.selectedTheme = theme
```

#### A single row with no recents

<img src="https://dagronf.github.io/art/projects/DSFColorPicker/transparency.png" alt="drawing" width="200"/>

[Full size](https://dagronf.github.io/art/projects/DSFColorPicker/transparency.png)

```swift
	let theme = DSFColorPickerTheme(name: "Simple Line", argbValueGrid: [
		[0xE0BA4240, 0xE0F0C976, 0xE096A873, 0xE089C9B8, 0xE0AFE6E4, 0xE07AA3C0, 0xE08B719F, 0xE0DB849A]]
	)
	self.showRecents = false
	self.colorView.selectedTheme = theme
```

The number of recent colors (if shown) is the same as the number of columns in the color grid

* Show or hide the themes in the control
* Show or hide the 'selected' button
* Show or hide recent colors
* Show or hide titles within the control
* Set the cell width and height
* Set the spacing between the color cells

### Theme support

Supply a set of themes, and configure the control to display the theme selector.

![](https://dagronf.github.io/art/projects/DSFColorPicker/theme_selector.gif)

### Drag and drop support

* Drag from the picker to any other component (eg. a color well) that supports dropping colors
* Drag colors into the control

### Dark mode support

Automatically adjusts to light and dark modes dynamically

### High contrast support

Dynamically adjusts to high-contrast display modes

<img src="https://dagronf.github.io/art/projects/DSFColorPicker/popover.png" alt="drawing" width="200"/>

[Full size](https://dagronf.github.io/art/projects/DSFColorPicker/popover.png)

### Accessibility support (preliminary)

* High contrast support
* VoiceOver reads out 'named' color views as they are interacted with ("<name> Color Selector")
