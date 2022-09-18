//
//  Resource.swift
//  AuthenticationFirebaseSwiftUI
//
//  Created by Nikhil M on 9/10/22.
//

import Foundation
import FirebaseFirestoreSwift

struct Resource: Identifiable {
    @DocumentID var id: String?
    var name: String
    var link: String
}
