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
    @StateObject private var rackView = BikeRackView()
    
    private let locationManager = CLLocationManager()
    private let logger = Logger(subsystem: "com.cyclespot", category: "MapView")
    
    var body: some View {
        ZStack {
            Map(position: $cameraPosition) {
                UserAnnotation()
                ForEach(rackView.racks) { rack in
                    // Create a marker for each rack
                    Marker(rack.address, coordinate: rack.coordinate)
                        .tint(Color.blue)
                }
                if let mapRoute {
                    // If we have a route display it
                    MapPolyline(mapRoute)
                        .stroke(Color.blue, lineWidth: 5)
                }
            }
            .contentMargins(20)
            .edgesIgnoringSafeArea(.all)
            
            VStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(.gray)
                        .padding(.leading, 12)
                    TextField("Search for locations...", text: $searchText, onCommit: {
                        performSearch()
                    })
                    .textFieldStyle(.plain)
                    .padding(.vertical, 12)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    if !searchText.isEmpty {
                        Button(action: {
                            searchText = ""
                            racks.removeAll()
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
                Spacer()
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
            locationManager.requestWhenInUseAuthorization()
            cameraPosition = .userLocation(fallback: .automatic)
            rackView.fetchRacks()
        }
    }
    
    
    private func performSearch() {
        guard !searchText.isEmpty else { return }
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        request.region = MKCoordinateRegion(.world) // you can limit region later if you want
        
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            if let error = error {
                logger.error("Search error: \(error.localizedDescription)")
                return
            }
            
            if let items = response?.mapItems {
                racks = items
                if let first = items.first {
                    cameraPosition = .userLocation(fallback: .region(MKCoordinateRegion(center: first.placemark.coordinate, span: MKCoordinateSpan(latitudeDelta: 44.475695, longitudeDelta: -122.406417))))
                }
            }
        }
    }
    
    private func getDirections(to destination: MKMapItem) {
        let request = MKDirections.Request()
        request.source = MKMapItem.forCurrentLocation()
        request.destination = destination
        request.transportType = .walking
        
        let directions = MKDirections(request: request)
        directions.calculate { response, error in
            if let error = error {
                logger.error("Error calculating directions: \(error.localizedDescription)")
                return
            }
            
            if let route = response?.routes.first {
                mapRoute = route
            }
        }
    }
}
