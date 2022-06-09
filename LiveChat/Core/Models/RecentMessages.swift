//
//  RecentMessages.swift
//  LiveChat
//
//  Created by Богдан Зыков on 10.06.2022.
//

import Foundation
import Firebase

struct RecentMessages: Identifiable{
    var id : String {documentId}
    let documentId: String
    let text, fromId, toId: String
    let name, profileImageUrl: String
    let timestamp: Timestamp
   
    init(documentId: String, data: [String: Any]){
        self.documentId = documentId
        self.text = data[FBConstant.text] as? String ?? ""
        self.toId = data[FBConstant.toId] as? String ?? ""
        self.profileImageUrl = data[FBConstant.profileImageUrl] as? String ?? ""
        self.name = data[FBConstant.name] as? String ?? ""
        self.fromId = data[FBConstant.fromId] as? String ?? ""
        self.timestamp = data[FBConstant.timestamp] as? Timestamp ?? Timestamp(date: .now)
    }
    
}
