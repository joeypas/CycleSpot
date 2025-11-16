//
//  RackDetailView.swift
//  CycleSpot
//
//  Created by Remy Roel on 11/17/25.
//

import SwiftUI
import PhotosUI
import Firebase
import FirebaseFirestore

struct RackDetailView: View {
    let rack: BikeRack
    
    @State private var reviews: [String] = []
    @State private var newReview: String = ""
    
    @State private var selectedPhotos: [PhotosPickerItem] = []
    @State private var images: [UIImage] = []
    
    let db = Firestore.firestore()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                
                // Rack Info
                VStack(alignment: .leading, spacing: 8) {
                    Text(rack.address)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("Capacity: \(rack.capacity)")
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)
                
                Divider()
                
                // Photos section
                VStack(alignment: .leading, spacing: 12) {
                    Text("Photos")
                        .font(.headline)
                    
                    if images.isEmpty {
                        Text("No photos yet.")
                            .foregroundColor(.secondary)
                    } else {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(images, id: \.self) { img in
                                    Image(uiImage: img)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 120, height: 120)
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                }
                            }
                        }
                    }
                    
                    PhotosPicker(
                        "Add Photos",
                        selection: $selectedPhotos,
                        matching: .images
                    )
                    .onChange(of: selectedPhotos) { _, newItems in
                        Task {
                            for item in newItems {
                                if let data = try? await item.loadTransferable(type: Data.self),
                                   let img = UIImage(data: data) {
                                    images.append(img)
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal)
                
                Divider()
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Reviews")
                        .font(.headline)
                    
                    if reviews.isEmpty {
                        Text("No reviews yet.")
                            .foregroundColor(.secondary)
                    } else {
                        ForEach(reviews.indices, id: \.self) { i in
                            Text(reviews[i])
                                .padding(12)
                                .background(Color(.secondarySystemBackground))
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                    }
                    
                    HStack {
                        TextField("Write a review...", text: $newReview)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        Button {
                            let trimmed = newReview.trimmingCharacters(in: .whitespaces)
                            guard !trimmed.isEmpty else { return }

                            newReview = ""

                            db.collection("racks")
                              .document(rack.id)
                              .collection("reviews")
                              .addDocument(data: [
                                  "text": trimmed,
                                  "timestamp": Timestamp()
                              ]) { error in
                                  if let error = error {
                                      print("Error adding review: \(error.localizedDescription)")
                                  }
                              }
                        } label: {
                            Image(systemName: "paperplane.fill")
                                .foregroundColor(.blue)
                        }


                    }
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .padding(.vertical)
        }
        .onAppear {
            db.collection("racks")
              .document(rack.id)
              .collection("reviews")
              .order(by: "timestamp", descending: true)
              .addSnapshotListener { snapshot, error in
                  if let error = error {
                      print("Error fetching reviews: \(error.localizedDescription)")
                      return
                  }
                  
                  guard let documents = snapshot?.documents else { return }
                  reviews = documents.compactMap { $0.data()["text"] as? String }
              }
        }
    }
}
