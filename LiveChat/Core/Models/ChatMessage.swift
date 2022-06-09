//
//  ChatMessage.swift
//  LiveChat
//
//  Created by Богдан Зыков on 05.06.2022.
//

import Foundation

struct ChatMessage: Identifiable{
    var id: String { documentId }
    
    let documentId: String
    let fromId, toId, text: String
    
    
    init(documentId: String, data: [String: Any]){
        self.documentId = documentId
        self.fromId = data["fromId"] as? String ?? ""
        self.toId = data["toId"] as? String ?? ""
        self.text = data["text"] as? String ?? ""
    }
}
