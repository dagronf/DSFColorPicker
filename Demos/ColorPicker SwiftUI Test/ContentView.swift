//
//  ContentView.swift
//  ColorPicker SwiftUI Test
//
//  Created by Darren Ford on 27/4/2023.
//  Copyright © 2023 Darren Ford. All rights reserved.
//

import SwiftUI
import DSFColorPicker

struct ContentView: View {
	@State var selectedColor: Color = .red
	@State var selectedColor2: Color = .green

	var body: some View {
		VStack {
			HStack(spacing: 20) {
				VStack {
					ColorPicker("SwiftUI color picker", selection: $selectedColor)
					Divider()
					DSFColorPickerUI(
						named: "SwiftUI-test",
						cellSize: CGSize(width: 16, height: 16),
						spacing: 1,
						selectedColor: $selectedColor
					)
				}

				Divider()

				DSFColorPickerUI(
					named: "SwiftUI-test2",
					theme: miniColorTheme,
					cellSize: CGSize(width: 20, height: 20),
					spacing: 1.5,
					displaySettings: [.current],
					selectedColor: $selectedColor
				)

				Divider()

				VStack {
					ColorPicker("Secondary picker", selection: $selectedColor2)
					Divider()
					DSFColorPickerUI(
						named: "SwiftUI-test33",
						theme: basicColorTheme,
						cellSize: CGSize(width: 20, height: 20),
						spacing: 1,
						displaySettings: [.current, .titles, .colorPicker, .colorDropper],
						selectedColor: $selectedColor2
					)
				}
			}
		}
		.padding()
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}


/////

let basicColorTheme = DSFColorPickerTheme(name: "Basic Colors", argbValueGrid: [
	[0xFFFFFF, 0xCDCDCD, 0x999999, 0x808080, 0x41464C, 0x000000],
	[0x172E3E, 0x0D002F, 0x2D0517, 0x4A180B, 0x4A3413, 0x253615],
	[0x264664, 0x140149, 0x480D21, 0x7A2516, 0x7C5822, 0x3A5623],
	[0x37638D, 0x1C0469, 0x651231, 0xAF3722, 0xB07C32, 0x537B31],
	[0x457DBC, 0x280789, 0x86183B, 0xD94C2D, 0xE9B245, 0x699D3E],
	[0x5EA9F1, 0x3305D2, 0xBD2A56, 0xDE623F, 0xEBB74F, 0x89C157],
	[0x68BEF2, 0x5517EF, 0xC94D79, 0xE18563, 0xF1CA6B, 0xA2D077],
	[0x8FD4F5, 0x865CEE, 0xDB80A3, 0xE9AB90, 0xF5DA96, 0xC0E19E],
])

let miniColorTheme = DSFColorPickerTheme(name: "Basic Colors", argbValueGrid: [
	[0xF5402C, 0xEB1360, 0x9C1BB1, 0x6634B8, 0x3D4DB7],
	[0x47AE4A, 0x009687, 0x01BBD5, 0x00A6F6, 0x0C93F5],
	[0x89C43F, 0xCCDD1E, 0xFFEC17, 0xFEC001, 0xFF9800],
	[0x000000, 0x5E7C8B, 0x9D9D9D, 0x7A5447, 0xFF5506],
])
