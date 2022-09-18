//
//  TicssViewModel.swift
//  AuthenticationFirebaseSwiftUI
//
//  Created by Nikhil M on 7/11/22.
//

import Foundation
import Combine
import Firebase
import FirebaseFirestore

class TicsListViewModel: ObservableObject {
  @Published var tics = [Tic]()
  
  private var db = Firestore.firestore()
  private var listenerRegistration: ListenerRegistration?
  
  deinit {
    unsubscribe()
  }
  
  func unsubscribe() {
    if listenerRegistration != nil {
      listenerRegistration?.remove()
      listenerRegistration = nil
    }
  }
  
  func subscribe() {
    if listenerRegistration == nil {
        listenerRegistration = db.collection("tics").whereField("userID", isEqualTo: Auth.auth().currentUser!.uid).addSnapshotListener { (querySnapshot, error) in
        guard let documents = querySnapshot?.documents else {
          print("No documents")
          return
        }
        
        self.tics = documents.compactMap { record in
            return Tic(id: record.documentID,
                       dayOfWeek: record["dayOfWeek"] as? String ?? "",
                       timeOfDay: record["timeOfDay"] as? String ?? "",
                       type: record["type"] as? String ?? "",
                       intensity: record["intensity"] as? Int ?? 0,
                       userID: Auth.auth().currentUser!.uid)
        }
      }
    }
  }
  
  func removeTics(atOffsets indexSet: IndexSet) {
    let tics = indexSet.lazy.map { self.tics[$0] }
    tics.forEach { tic in
      if let documentId = tic.id {
        db.collection("tics").document(documentId).delete { error in
          if let error = error {
            print("Unable to remove document: \(error.localizedDescription)")
          }
        }
      }
    }
  }

  
}


