//
//  Photo.swift
//  locale
//
//  Created by Sachin Gala on 7/7/24.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct Photo : Identifiable, Codable {
    @DocumentID var id: String?
    var imageURLString = ""
}
