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
	var body: some View {
		VStack {
			HStack {
				VStack {
					ColorPicker("fish", selection: $selectedColor)
					DSFColorPickerUI(
						named: "SwiftUI-test",
						selectedColor: $selectedColor
					)
				}
				DSFColorPickerUI(
					named: "SwiftUI-test2",
					showRecents: false,
					selectedColor: $selectedColor
				)
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
