# DSFColorPicker

A Swift library to display a customizable color picker for macOS.

![](https://img.shields.io/github/v/tag/dagronf/DSFColorPicker) ![](https://img.shields.io/badge/macOS-10.12+-red) ![](https://img.shields.io/badge/Swift-5.0-orange.svg)
![](https://img.shields.io/badge/License-MIT-lightgrey) [![](https://img.shields.io/badge/spm-compatible-brightgreen.svg?style=flat)](https://swift.org/package-manager)

![](https://dagronf.github.io/art/projects/DSFColorPicker/general.gif)

### Features

* Themable, allow your users to change between provided themes.
* Configurable color palettes
* Configurable in Interface Builder or by code.
* Color picker support to allow selecting a color from the screen
* Configurable recent colors support
* Drag and drop support

## Installation

Add `https://github.com/dagronf/DSFColorPicker` to your project

## Configuration

### SwiftUI

You can add a `DSFColorPickerUI` to your SwiftUI view to display a DSFColorPicker in your SwiftUI content.

Parameters

| Parameter         | Desciption                                             |
|-------------------|--------------------------------------------------------|
| `name`            | The name for the picker (eg. 'Stroke color')           |
| `theme`           | The theme to use, or nil to use the default colors     |
| `cellSize`        | The size of each color cell                            |
| `spacing`         | The spacing between each color cell                    |
| `displaySettings` | The components of the color picker to present          |
| `selectedColor`   | A binding to the selected color                        |

#### Example

```swift
struct MyContent: View {
   @State var selectedColor: Color = .red
   var body: some View {
      ...
      DSFColorPickerUI(
         named: "My color picker",
         theme: miniColorTheme,
         selectedColor: $selectedColor
      )
   )
}

let miniColorTheme = DSFColorPickerTheme(name: "Basic Colors", argbValueGrid: [
	[0xF5402C, 0xEB1360, 0x9C1BB1, 0x6634B8, 0x3D4DB7],
	[0x47AE4A, 0x009687, 0x01BBD5, 0x00A6F6, 0x0C93F5],
	[0x89C43F, 0xCCDD1E, 0xFFEC17, 0xFEC001, 0xFF9800],
	[0x000000, 0x5E7C8B, 0x9D9D9D, 0x7A5447, 0xFF5506],
])
```

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
	let theme = DSFColorPickerTheme(name: "My Colors", argbValueGrid: [
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

### Color sampling support

As of macOS 10.15, your app will require Screen Recording permissions to use the color sampler (the eye dropper). 

The first time a user selects the eye-dropper, macOS will display a dialog asking for permission.

You can view the Screen Recording permissions for apps in the system preferences `Security & Privacy` pane.

`System Preferences > Security & Privacy > Privacy > Screen Recording` 

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

# License

```
MIT License

Copyright (c) 2024 Darren Ford

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
