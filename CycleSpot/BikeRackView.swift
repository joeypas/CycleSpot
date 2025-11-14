import Foundation
import FirebaseFirestore

@MainActor
class BikeRackView: ObservableObject {
    @Published var racks: [BikeRack] = []
    @Published var allRacks: [BikeRack] = []
    
    func fetchRacks(completion: (() -> Void)? = nil) {
        let db = Firestore.firestore()
        db.collection("racks").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching racks: \(error.localizedDescription)")
                return
            }
            guard let documents = snapshot?.documents else { completion?(); return }
            
            self.allRacks = documents.compactMap { doc in
                let data = doc.data()
                guard
                    let address = data["Address"] as? String,
                    let latitude = data["Latitude"] as? Double,
                    let longitude = data["Longitude"] as? Double
                else { return nil }

                return BikeRack(
                    id: doc.documentID,
                    address: address,
                    latitude: latitude,
                    longitude: longitude,
                    capacity: data["Capacity"] as? Int ?? 0
                )
            }
            completion?()
        }
    }
}
