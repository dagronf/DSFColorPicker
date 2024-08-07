//
//  CustomThemes.swift
//  ColorPicker SwiftUI Test
//
//  Created by Darren Ford on 30/4/2023.
//  Copyright © 2023 Darren Ford. All rights reserved.
//

import Foundation
import DSFColorPicker

let customTheme: DSFColorPickerTheme = {
	DSFColorPickerTheme(
		palettes: [
			DSFColorPickerPalette(name: "Unique", argbValueGrid: [
				[0xAC7982, 0xD5946A, 0x7B978C, 0x63758A, 0xA7806D],
				[0xD7A7BA, 0xE4B999, 0x658AA1, 0x847BA6, 0x9B9869],
				[0xE6BCC7, 0xEAC5A7, 0xA2BE84, 0x93B0D6, 0xAEAAA1],
			]),
			DSFColorPickerPalette(name: "Gorgeous", argbValueGrid: [
				[0x2C5A72, 0xBA3C3C, 0x872D4E, 0x55235E, 0x222120],
				[0x3B808C, 0xD89933, 0xD38C7A, 0x72317C, 0x4C4C4C],
				[0x95C3D8, 0xE9C27F, 0xDDA9B1, 0xC0A7C8, 0xC8C8C8],
			]),
			DSFColorPickerPalette(name: "Colorful", argbValueGrid: [
				[0x3550A0, 0x4DA051, 0xE7B83D, 0xC53A33, 0xB32D6E],
				[0x387BC3, 0x74B04B, 0xF6DD48, 0xCC6431, 0xC5318C],
				[0x50AAED, 0xA0C243, 0xFDF14F, 0xD6862E, 0xD68CB7],
			]),
			DSFColorPickerPalette(name: "Cool", argbValueGrid: [
				[0x153745, 0x73669E, 0x2D5B96, 0x4CA2BB, 0x64A68B],
				[0x658AA1, 0x8082B4, 0x78A9DB, 0x8CBFD5, 0x96BFA4],
				[0x95B8D3, 0xB0A8CD, 0x79B8DF, 0xB1D5E9, 0xA9CBB7],
			])
		])
}()

let basicColorTheme: DSFColorPickerTheme = {
	DSFColorPickerTheme(palette: DSFColorPickerPalette(
		name: "Basic Colors",
		argbValueGrid: [
			[0xFFFFFF, 0xCDCDCD, 0x999999, 0x808080, 0x41464C, 0x000000],
			[0x172E3E, 0x0D002F, 0x2D0517, 0x4A180B, 0x4A3413, 0x253615],
			[0x264664, 0x140149, 0x480D21, 0x7A2516, 0x7C5822, 0x3A5623],
			[0x37638D, 0x1C0469, 0x651231, 0xAF3722, 0xB07C32, 0x537B31],
			[0x457DBC, 0x280789, 0x86183B, 0xD94C2D, 0xE9B245, 0x699D3E],
			[0x5EA9F1, 0x3305D2, 0xBD2A56, 0xDE623F, 0xEBB74F, 0x89C157],
			[0x68BEF2, 0x5517EF, 0xC94D79, 0xE18563, 0xF1CA6B, 0xA2D077],
			[0x8FD4F5, 0x865CEE, 0xDB80A3, 0xE9AB90, 0xF5DA96, 0xC0E19E],
		])
	)
}()

let gray16Theme: DSFColorPickerTheme = {
	DSFColorPickerTheme(
		palette: DSFColorPickerPalette(
			name: "Gray16",
			colors: [
				[ #colorLiteral(red: 0.000, green: 0.000, blue: 0.000, alpha: 1.000), #colorLiteral(red: 0.094, green: 0.094, blue: 0.094, alpha: 1.000), #colorLiteral(red: 0.157, green: 0.157, blue: 0.157, alpha: 1.000), #colorLiteral(red: 0.220, green: 0.220, blue: 0.220, alpha: 1.000) ],
				[ #colorLiteral(red: 0.278, green: 0.278, blue: 0.278, alpha: 1.000), #colorLiteral(red: 0.337, green: 0.337, blue: 0.337, alpha: 1.000), #colorLiteral(red: 0.392, green: 0.392, blue: 0.392, alpha: 1.000), #colorLiteral(red: 0.443, green: 0.443, blue: 0.443, alpha: 1.000) ],
				[ #colorLiteral(red: 0.494, green: 0.494, blue: 0.494, alpha: 1.000), #colorLiteral(red: 0.549, green: 0.549, blue: 0.549, alpha: 1.000), #colorLiteral(red: 0.608, green: 0.608, blue: 0.608, alpha: 1.000), #colorLiteral(red: 0.671, green: 0.671, blue: 0.671, alpha: 1.000) ],
				[ #colorLiteral(red: 0.741, green: 0.741, blue: 0.741, alpha: 1.000), #colorLiteral(red: 0.820, green: 0.820, blue: 0.820, alpha: 1.000), #colorLiteral(red: 0.906, green: 0.906, blue: 0.906, alpha: 1.000), #colorLiteral(red: 1.000, green: 1.000, blue: 1.000, alpha: 1.000) ]
			]
		)
	)
}()

let miniColorTheme: DSFColorPickerTheme = {
	DSFColorPickerTheme(palette: DSFColorPickerPalette(
		name: "Basic Colors",
		argbValueGrid: [
			[0xF5402C, 0xEB1360, 0x9C1BB1, 0x6634B8, 0x3D4DB7],
			[0x47AE4A, 0x009687, 0x01BBD5, 0x00A6F6, 0x0C93F5],
			[0x89C43F, 0xCCDD1E, 0xFFEC17, 0xFEC001, 0xFF9800],
			[0x000000, 0x5E7C8B, 0x9D9D9D, 0x7A5447, 0xFF5506],
		])
	)
}()
