//
//  CustomColorPicker.swift
//  DSFColorPickerDemo
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
import DSFColorPicker

@IBDesignable class CustomPickerView: DSFColorPickerView
{
	let customTheme = CustomThemes()
	override func themes() -> DSFColorPickerThemes
	{
		return self.customTheme
	}
}

class CustomThemes: DSFColorPickerThemes
{
	override func loadThemes() -> [DSFColorPickerTheme]
	{
		let themes: [DSFColorPickerTheme] =
		[
			DSFColorPickerTheme(name: "Unique", argbValueGrid: [
				[0xAC7982, 0xD5946A, 0x7B978C, 0x63758A, 0xA7806D],
				[0xD7A7BA, 0xE4B999, 0x658AA1, 0x847BA6, 0x9B9869],
				[0xE6BCC7, 0xEAC5A7, 0xA2BE84, 0x93B0D6, 0xAEAAA1]
			]),
			DSFColorPickerTheme(name: "Gorgeous", argbValueGrid: [
				[0x2C5A72, 0xBA3C3C, 0x872D4E, 0x55235E, 0x222120],
				[0x3B808C, 0xD89933, 0xD38C7A, 0x72317C, 0x4C4C4C],
				[0x95C3D8, 0xE9C27F, 0xDDA9B1, 0xC0A7C8, 0xC8C8C8]
			]),
			DSFColorPickerTheme(name: "Colorful", argbValueGrid: [
				[0x3550A0, 0x4DA051, 0xE7B83D, 0xC53A33, 0xB32D6E],
				[0x387BC3, 0x74B04B, 0xF6DD48, 0xCC6431, 0xC5318C],
				[0x50AAED, 0xA0C243, 0xFDF14F, 0xD6862E, 0xD68CB7]
			]),
		 	DSFColorPickerTheme(name: "Cool", argbValueGrid: [
				[0x153745, 0x73669E, 0x2D5B96, 0x4CA2BB, 0x64A68B],
				[0x658AA1, 0x8082B4, 0x78A9DB, 0x8CBFD5, 0x96BFA4],
				[0x95B8D3, 0xB0A8CD, 0x79B8DF, 0xB1D5E9, 0xA9CBB7]
			])
		]
		return themes
	}
}

@IBDesignable class DefaultPickerView: DSFColorPickerView
{
	let customTheme = DefaultPickerViewThemes()
	override func themes() -> DSFColorPickerThemes
	{
		return self.customTheme
	}
}

class DefaultPickerViewThemes: DSFColorPickerThemes
{
	override func loadThemes() -> [DSFColorPickerTheme]
	{
		var themes: [DSFColorPickerTheme] =
		[
			DSFColorPickerTheme(name: "default", argbValueGrid: [
				[0xFFFFFF, 0xCDCDCD, 0x999999, 0x808080, 0x41464C, 0x000000],
				[0x172E3E, 0x0D002F, 0x2D0517, 0x4A180B, 0x4A3413, 0x253615],
				[0x264664, 0x140149, 0x480D21, 0x7A2516, 0x7C5822, 0x3A5623],
				[0x37638D, 0x1C0469, 0x651231, 0xAF3722, 0xB07C32, 0x537B31],
				[0x457DBC, 0x280789, 0x86183B, 0xD94C2D, 0xE9B245, 0x699D3E],
				[0x5EA9F1, 0x3305D2, 0xBD2A56, 0xDE623F, 0xEBB74F, 0x89C157],
				[0x68BEF2, 0x5517EF, 0xC94D79, 0xE18563, 0xF1CA6B, 0xA2D077],
				[0x8FD4F5, 0x865CEE, 0xDB80A3, 0xE9AB90, 0xF5DA96, 0xC0E19E]
			]),

			DSFColorPickerTheme(name: "simple", argbValueGrid: [
				[0xE0BA4240, 0xE0F0C976, 0xE096A873, 0xE089C9B8, 0xE0AFE6E4, 0xE07AA3C0, 0xE08B719F, 0xE0DB849A]
			]),
			DSFColorPickerTheme(name: "muted", argbValueGrid: [
				[0xD7E0E8, 0xE3E9E0, 0xFDEBC6, 0xF0B297, 0xE7938C, 0xB0ABC0],
				[0xA7BBCF, 0x98A68D, 0xE3C07F, 0xEA8C60, 0xB93E40, 0x807798],
				[0x4B7196, 0x4C683D, 0xA3793B, 0xDD5822, 0x912122, 0x615878],
				[0x395570, 0x324923, 0x5B422A, 0xB34A00, 0x6E0A01, 0x423C51],
				[0xFFFFFF, 0xA9A9A9, 0x797979, 0x424242, 0x000000, 0xFF000000]
			])
		]

		let lineColors: [UInt32] = [
			0xFF00FF,
			0xBF00FF,
			0x7F00FF,
			0x3F00FF,
			0x0000FF,
			0x003FFF,
			0x007FFF,
			0x00BFFF,
			0x00FFFF,
			0x00FFBF,
			0x00FF7F,
			0x00FF3F,
			0x00FF00,
			0x3FFF00,
			0x7FFF00,
			0xBFFF00,
			0xFFFF00,
			0xFFBF00,
			0xFF7F00,
			0xFF3F00];

		let line = lineColors.map{ [$0] }
		let lineRev = lineColors.reversed().map{ [$0] }

		themes.append(DSFColorPickerTheme(name: "line", argbValueGrid: line))
		themes.append(DSFColorPickerTheme(name: "linereversed", argbValueGrid: lineRev))

		return themes
	}


}
