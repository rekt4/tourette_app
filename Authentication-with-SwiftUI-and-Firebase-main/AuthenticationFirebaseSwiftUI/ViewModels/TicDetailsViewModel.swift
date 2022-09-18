//
//  TicViewModel.swift
//  AuthenticationFirebaseSwiftUI
//
//  Created by Nikhil M on 7/11/22.
//

import Foundation
import Combine
import Firebase
import FirebaseFirestore

class TicDetailsViewModel: ObservableObject {
  // MARK: - Public properties
  
  @Published var tic: Tic
  @Published var modified = false
  let userID = Auth.auth().currentUser!.uid
  
  // MARK: - Internal properties
  
  private var cancellables = Set<AnyCancellable>()
  
  // MARK: - Constructors
  
    init(tic: Tic = Tic(dayOfWeek: "", timeOfDay: "", type: "", intensity: 0, userID: Auth.auth().currentUser!.uid)) {
    self.tic = tic
    
    self.$tic
      .dropFirst()
      .sink { [weak self] tic in
        self?.modified = true
      }
      .store(in: &self.cancellables)
  }
  
  // MARK: - Firestore
  
  private var db = Firestore.firestore()
  
  private func addTic(_ tic: Tic) {
    do {
        let _ = try db.collection("tics").addDocument(from: tic)
    }
    catch {
      print(error)
    }
  }
  
  private func updateTic(_ tic: Tic) {
    if let documentId = tic.id {
      do {
        try db.collection("tics").document(documentId).setData(from: tic)
      }
      catch {
        print(error)
      }
    }
  }
  
  private func updateOrAddTic() {
    if let _ = tic.id {
      self.updateTic(self.tic)
    }
    else {
      addTic(tic)
    }
  }
  
  private func removeTic() {
    if let documentId = tic.id {
        db.collection("tics").document(documentId).delete { error in
        if let error = error {
          print(error.localizedDescription)
        }
      }
    }
  }
  
  // MARK: - UI handlers
  
  func handleDoneTapped() {
    self.updateOrAddTic()
  }
  
  func handleDeleteTapped() {
    self.removeTic()
  }
  
}
