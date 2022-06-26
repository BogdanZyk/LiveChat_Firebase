//
//  Helpers.swift
//  LiveChat
//
//  Created by Богдан Зыков on 04.06.2022.
//


import Firebase
import SwiftUI

final class Helpers{
    
    
    static func handleError(_ error: Error?, title: String, errorMessage: inout String, showAlert: inout Bool){
        if let error = error {
            errorMessage = "\(title) \(error.localizedDescription)"
            showAlert = true
        }
    }
    
    static func decodeUserData(_ snapshot: DocumentSnapshot?) -> User?{
        guard let data = snapshot?.data() else {return nil}
        guard let jsonData = try? JSONSerialization.data(withJSONObject: data) else{return nil}
        return try? JSONDecoder().decode(User.self, from: jsonData)
    }
    
    static func getRoomUid(toId: String, fromId: String) -> String{
        toId > fromId ? (fromId + toId) : (toId + fromId)
    }
    
    
    
    static func preparingImageforUpload(_ image: UIImage?, compressionQuality: CGFloat = 0.9) -> Data?{
        guard let image = image, let imageData = image.jpegData(compressionQuality: compressionQuality) else {return nil}
        return imageData
    }
    
    

}
