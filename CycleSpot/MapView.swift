//
//  MapView.swift
//  CycleSpot
//
//  Created by Joseph Liotta on 10/15/25.
//

import SwiftUI
import MapKit
import OSLog

struct MapView: View {
    // List of bike racks Eventually we will need to asynchronysly fetch this data and populate the list
    @State private var racks: [MKMapItem] = []
    // Currently Selected Item
    @State private var selectedItem: MKMapItem?
    // Position that the map is looking at
    @State private var cameraPosition: MapCameraPosition = .automatic
    // Route, Null if we aren't using it
    @State private var mapRoute: MKRoute?
    @State private var searchText: String = ""
    
    private let locationManager = CLLocationManager()
    var body: some View {
        Map(position: $cameraPosition) {
            UserAnnotation()
            ForEach(racks, id: \.self) { item in
                // Create a marker for each rack
                Marker(item: item)
                    .mapItemDetailSelectionAccessory(.callout)
            }
            if let mapRoute {
                // If we have a route display it
                MapPolyline(mapRoute)
                    .stroke(Color.blue, lineWidth: 5)
            }
        }
        .contentMargins(20)
        .overlay(alignment: .top) {
            VStack {
                HStack {
                    Image(systemName: "magnigyingglass")
                        .foregroundStyle(.gray)
                        .padding(.leading, 12)
                    TextField("Search for locations...", text: $searchText)
                        .textFieldStyle(.plain)
                        .padding(.vertical, 12)
                    if !searchText.isEmpty {
                        Button(action: {
                            searchText = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundStyle(.gray)
                        }
                        .padding(.trailing, 12)
                    }
                }
                .background(Color(.systemBackground).opacity(0.95))
                .cornerRadius(25)
                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 2)
                .padding(.horizontal, 16)
                .padding(.top, 16)
            }
        }
        // Callback for when an item is selected
        .onChange(of: selectedItem) {
            if let selectedItem {
                // Get directions from current location to selected map item
                let request = MKDirections.Request()
                request.source = MKMapItem.forCurrentLocation()
                request.destination = selectedItem
                request.transportType = .walking
                let directions = MKDirections(request: request)
                directions.calculate { response, error in
                    guard let response else {
                        // Just for testing
                        let logger = Logger()
                        logger.error("Error calculating directions: \(error!)")
                        return
                    }
                    if let route = response.routes.first {
                        mapRoute = route
                    }
                }
            } else {
                mapRoute = nil
            }
        }
        .onAppear {
            // This should grab the users current location?
            locationManager.requestWhenInUseAuthorization()
        }
    }
}
