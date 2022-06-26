//
//  ChatMessage.swift
//  LiveChat
//
//  Created by Богдан Зыков on 05.06.2022.
//

import Foundation
import FirebaseFirestoreSwift

struct Message: Codable, Identifiable{
    @DocumentID var id: String?
    let fromId, toId, imageURL, text: String
}


//struct Message: Codable, Identifiable{
//    var id: String = UUID().uuidString
//    let fromId, toId, text: String
//    var image: [MessageImage] = []
//    var viewed: Bool = false
//
//
//
//
//}
//
//struct MessageImage: Codable, Identifiable{
//    var id: String = UUID().uuidString
//    var imageURL: String
//}

