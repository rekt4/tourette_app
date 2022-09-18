//
//  Book.swift
//  AuthenticationFirebaseSwiftUI
//
//  Created by Nikhil M on 7/11/22.
//

import Foundation
import FirebaseFirestoreSwift

struct Tic: Identifiable, Codable {
    @DocumentID var id: String?
    var dayOfWeek: String
    var timeOfDay: String
    var type: String
    var intensity: Int
    var userID: String
  
    enum CodingKeys: String, CodingKey {
        case dayOfWeek
        case timeOfDay
        case type
        case intensity
        case userID
    }
}
