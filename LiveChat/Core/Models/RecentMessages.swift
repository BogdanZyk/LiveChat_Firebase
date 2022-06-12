//
//  RecentMessages.swift
//  LiveChat
//
//  Created by Богдан Зыков on 10.06.2022.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct RecentMessages: Codable, Identifiable{
    

    @DocumentID var id: String?
    let text, fromId, toId: String
    let name, profileImageUrl: String
    let timestamp: Date
   
    var timeAgo: String{
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: timestamp, relativeTo: Date())
    }
    
}
