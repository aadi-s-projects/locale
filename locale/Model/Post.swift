//
//  Post.swift
//  locale
//
//  Created by Sachin Gala on 7/1/24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Post: Identifiable, Codable, Hashable {
    @DocumentID var id : String? = UUID().uuidString
    var userCreator : String
    var name : String
    var title : String
    var coordinate : GeoPoint
    var tag : String
    var description : String
}
