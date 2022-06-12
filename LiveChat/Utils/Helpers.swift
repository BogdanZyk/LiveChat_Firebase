//
//  Helpers.swift
//  LiveChat
//
//  Created by Богдан Зыков on 04.06.2022.
//


import Firebase

final class Helpers{
    
    
    static func handleError(_ error: Error?, title: String, errorMessage: inout String, showAlert: inout Bool){
        if let error = error {
            errorMessage = "\(title) \(error.localizedDescription)"
            showAlert = true
        }
    }
    
    static func decodeUserData(_ snapshot: DocumentSnapshot?) -> ChatUser?{
        guard let data = snapshot?.data() else {return nil}
        guard let jsonData = try? JSONSerialization.data(withJSONObject: data) else{return nil}
        return try? JSONDecoder().decode(ChatUser.self, from: jsonData)
    }
    
    static func getRoomUid(toId: String, fromId: String) -> String{
        toId > fromId ? (fromId + toId) : (toId + fromId)
    }
}
