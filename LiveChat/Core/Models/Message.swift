//
//  ChatMessage.swift
//  LiveChat
//
//  Created by Богдан Зыков on 05.06.2022.
//

import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore


struct Message: Codable, Identifiable{
    var id: String = UUID().uuidString
    let fromId, toId, text: String
    var image: ImageData = ImageData()
    var viewed: Bool = false
    var timestamp: Timestamp = Timestamp()
    
    
    var messageTime: String{
        timestamp.dateValue().formatted(date: .omitted, time: .shortened)
    }
}

struct ImageData: Codable, Identifiable{
    var id: String = UUID().uuidString
    var imageURL: String = ""
}

