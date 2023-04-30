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

					HStack(spacing: 20) {
						VStack {
							DSFColorPickerUI(
								named: "default-settings",
								cellSize: CGSize(width: 16, height: 16),
								spacing: 1,
								selectedColor: $selectedColor
							)
						}

						VStack {
							DSFColorPickerUI(
								named: "all-components",
								theme: customTheme,
//								cellSize: CGSize(width: 16, height: 16),
//								spacing: 1,
								displaySettings: [.colorDropper, .colorPicker, .current, .palettes, .recents, .titles],
								selectedColor: $selectedColor
							)
						}

						DSFColorPickerUI(
							named: "mini-color-theme",
							theme: miniColorTheme,
							cellSize: CGSize(width: 20, height: 20),
							spacing: 1.5,
							displaySettings: [.current],
							selectedColor: $selectedColor
						)
					}
				}

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
