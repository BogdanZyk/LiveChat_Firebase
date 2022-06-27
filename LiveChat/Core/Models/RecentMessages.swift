//
//  RecentMessages.swift
//  LiveChat
//
//  Created by Богдан Зыков on 10.06.2022.
//

import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore

struct RecentMessages: Codable, Identifiable{
    
    @DocumentID var id: String?
    let uid, name, profileImageUrl: String
    let message: Message
    //var timestamp: Timestamp = Timestamp()
    
}
