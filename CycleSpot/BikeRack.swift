import Foundation
import CoreLocation

struct BikeRack: Identifiable {
    let id: String
    let address: String
    let latitude: Double
    let longitude: Double
    let capacity: Int

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
