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
    // Currently Selected Item
    @State private var selectedItem: MKMapItem?
    // Position that the map is looking at
    @State private var cameraPosition: MapCameraPosition = .automatic
    // Route, Null if we aren't using it
    @State private var mapRoute: MKRoute?
    @EnvironmentObject var rackView: BikeRackView
    @State private var searchText = ""
    var initialSearch: String = ""
    @State private var selectedRack: BikeRack?
    
    
    private let locationManager = CLLocationManager()
    private let logger = Logger(subsystem: "com.cyclespot", category: "MapView")
    
    var body: some View {
        ZStack {
            Map(position: $cameraPosition) {
                UserAnnotation()
                ForEach(rackView.racks) { rack in
                    // Create a marker for each rack
                    Annotation(rack.address, coordinate: rack.coordinate) {
                        Image(systemName: "mappin.circle.fill")
                            .font(.title)
                            .foregroundStyle(.blue)
                            .onTapGesture {
                                selectedRack = rack
                            }
                    }
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
                            rackView.racks.removeAll()
                            cameraPosition = .userLocation(fallback: .automatic)
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
        .onAppear {
            locationManager.requestWhenInUseAuthorization()
            cameraPosition = .userLocation(fallback: .automatic)
            rackView.fetchRacks{
                if !initialSearch.isEmpty {
                    searchText = initialSearch
                    performSearch()
                }
            }
        }
        .sheet(item: $selectedRack) { rack in
            RackDetailView(rack: rack)
        }
    }
    
    private func performSearch() {
        guard !searchText.isEmpty else { return }
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            if let error = error {
                logger.error("Search error: \(error.localizedDescription)")
                return
            }
            
            guard let items = response?.mapItems, let first = items.first else { return }
            
            cameraPosition = .region(
                MKCoordinateRegion(
                    center: first.placemark.coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
                )
            )
            
            let searchedLocation = CLLocation(latitude: first.placemark.coordinate.latitude,
                                              longitude: first.placemark.coordinate.longitude)
            let radiusInMeters = 400.00
            
            rackView.racks = rackView.allRacks.filter { rack in
                let rackLocation = CLLocation(latitude: rack.latitude, longitude: rack.longitude)
                return rackLocation.distance(from: searchedLocation) <= radiusInMeters
            }
        }
    }
}
