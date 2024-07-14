//
//  PostComment.swift
//  locale
//
//  Created by Sachin Gala on 7/8/24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct PostComment: Identifiable, Codable {
    @DocumentID var id : String? = UUID().uuidString
    var userCreator : String
    var comment : String
}
