//
//  TicGraphViewModel.swift
//  AuthenticationFirebaseSwiftUI
//
//  Created by Nikhil M on 7/19/22.
//

import Foundation
import Firebase
import CoreGraphics
import Combine

class TicGraphViewModel: ObservableObject {

    @Published var arr: [[Int]] = [
        [0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0]
    ]

    func getData() {
        let db = Firestore.firestore()
        
        let DayLookup = [
            "sunday": 0,
            "monday": 1,
            "tuesday": 2,
            "wednesday": 3,
            "thursday": 4,
            "friday": 5,
            "saturday": 6
        ]
        
        let TimeLookup = [
            "morning": 0,
            "afternoon": 1,
            "evening": 2
        ]
        
        db.collection("tics").getDocuments { snapshot, error in
            if error == nil {
                if let snapshot = snapshot {
                    DispatchQueue.main.async {
                        for doc in snapshot.documents {
                            let uid = doc["userID"] as? String ?? ""
                            if (uid == Auth.auth().currentUser?.uid) {
                                let timeOfDay = doc["timeOfDay"] as! String
                                let dayOfWeek = doc["dayOfWeek"] as! String
                                
                                let timeOfDayId:Int = TimeLookup[timeOfDay.lowercased()]!
                                let dayOfWeekId:Int = DayLookup[dayOfWeek.lowercased()]!
                                
                                self.arr[timeOfDayId][dayOfWeekId] += 1;
                            }
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
