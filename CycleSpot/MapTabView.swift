//
//  MapTabView.swift
//  CycleSpot
//
//  Created by Remy Roel on 11/13/25.
//
import SwiftUI

struct MapTabView: View {
    @State private var showMap = false
    @State private var initialSearchText = ""
    @EnvironmentObject var rackView: BikeRackView
    
    var body: some View {
        if showMap {
            MapView(initialSearch: initialSearchText)
                .environmentObject(rackView)
        } else {
            IntroView(showMap: $showMap, initialSearchText: $initialSearchText)
        }
    }
}
