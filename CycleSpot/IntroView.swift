//
//  IntroView.swift
//  CycleSpot
//
//  Created by Remy Roel on 11/13/25.
//

import SwiftUI

struct IntroView: View {
    @Binding var showMap: Bool
    @State private var searchText: String = ""
    @Binding var initialSearchText: String
    
    private let backgroundColor = Color(red: 0.231, green: 0.455, blue: 0.686)
    
    var body: some View {
        ZStack {
            backgroundColor
                .ignoresSafeArea()
            
            VStack(spacing: 40) {
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                VStack(spacing: 10) {
                    TextField("Enter location...", text: $searchText, onCommit: {
                        if !searchText.isEmpty {
                            initialSearchText = searchText
                            showMap = true
                        }
                    })
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, 40)
                    Text("Where are you headed?")
                        .foregroundColor(.white)
                }
            }
            .padding()
        }
    }
            
}
    
