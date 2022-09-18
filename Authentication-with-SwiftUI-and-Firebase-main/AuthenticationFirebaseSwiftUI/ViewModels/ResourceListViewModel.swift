//
//  ResourceListViewModel.swift
//  AuthenticationFirebaseSwiftUI
//
//  Created by Nikhil M on 9/10/22.
//

import Foundation
import Combine
import Firebase
import FirebaseFirestore

class ResourceListViewModel: ObservableObject {
  @Published var resources = [Resource]()
  
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
        listenerRegistration = db.collection("resources").addSnapshotListener { (querySnapshot, error) in
        guard let documents = querySnapshot?.documents else {
          print("No documents")
          return
        }
        
        self.resources = documents.compactMap { record in
            return Resource(id: record.documentID,
                       name: record["name"] as? String ?? "Google",
                       link: record["link"] as? String ?? "www.google.com")
        }
      }
    }
  }

  
}
