//
//  ChatMessage.swift
//  LiveChat
//
//  Created by Богдан Зыков on 05.06.2022.
//

import Foundation
import FirebaseFirestore
//struct Message: Codable, Identifiable{
//    @DocumentID var id: String?
//    let fromId, toId, imageURL, text: String
//}


struct Message: Codable, Identifiable{
    var id: String = UUID().uuidString
    let fromId, toId, text: String
    var image: ImageData = ImageData()
    var viewed: Bool = false
    var timestamp: Timestamp = Timestamp()
}

struct ImageData: Codable, Identifiable{
    var id: String = UUID().uuidString
    var imageURL: String = ""
}

