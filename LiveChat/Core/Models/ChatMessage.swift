//
//  ChatMessage.swift
//  LiveChat
//
//  Created by Богдан Зыков on 05.06.2022.
//

import Foundation
import FirebaseFirestoreSwift

struct ChatMessage: Codable, Identifiable{
    @DocumentID var id: String?
    let fromId, toId, imageURL, text: String
}
