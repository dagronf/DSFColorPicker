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
	var body: some View {
		VStack {
			Image(systemName: "globe")
				.imageScale(.large)
				.foregroundColor(.accentColor)
			Text("Hello, world!")
			DSFColorPickerUI()
		}
		.padding()
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
