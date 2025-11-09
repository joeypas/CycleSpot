import Foundation
import FirebaseFirestore

@MainActor
class BikeRackView: ObservableObject {
    @Published var racks: [BikeRack] = []

    func fetchRacks() {
        let db = Firestore.firestore()
        db.collection("racks").getDocuments { snapshot, error in
        if let error = error {
                print("Error fetching racks: \(error.localizedDescription)")
                return
            }
            guard let documents = snapshot?.documents else { return }

            self.racks = documents.compactMap { doc in
                let data = doc.data()
                
                guard
                    let address = data["Address"] as? String,
                    let capacity = data["Capacity"] as? Int,
                    let latitude = data["Latitude"] as? Double,
                    let longitude = data["Longitude"] as? Double
                else {
                    print("Error decoding document: \(doc.documentID)")
                    return nil
                }

                let features = data["Features"] as? String
                return BikeRack(
                    id: doc.documentID,
                    address: address,
                    latitude: latitude,
                    longitude: longitude,
                    capacity: data["Capacity"] as? Int ?? 0
                )
            }
        }
    }
}
