//
//  HomeTextViewModel.swift
//  AuthenticationFirebaseSwiftUI
//
//  Created by Nikhil M on 7/28/22.
//

import Foundation
import Firebase
import CoreGraphics
import Combine

class HomeTextViewModel: ObservableObject {
    
    static var arr: [String] = []

    func getData() {
        let db = Firestore.firestore()
        
        db.collection("welcomeText").getDocuments { snapshot, error in
            if error == nil {
                if let snapshot = snapshot {
                    DispatchQueue.main.async {
                        print(snapshot.documents)
                        for doc in snapshot.documents {
                            print(doc)
                            let txt = doc["text"] as? String ?? ""
                            print(txt)
                            HomeTextViewModel.arr.append(txt)
                        }
                    }
                }
                else {
                    print("Snapshot is null")
                }
            }
            else {
                print("There is an ERROR")
            }
        }
    }
}
