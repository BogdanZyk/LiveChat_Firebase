//
//  FirebaseManager.swift
//  LiveChat
//
//  Created by Богдан Зыков on 31.05.2022.
//

import Foundation
import Firebase
import FirebaseStorage
import FirebaseFirestore

class FirebaseManager: NSObject{
    let auth: Auth
    let storage: Storage
    let firestore: Firestore
    static let shared = FirebaseManager()
    
    override init() {
        FirebaseApp.configure()
        self.auth = Auth.auth()
        self.storage = Storage.storage()
        self.firestore = Firestore.firestore()
        super.init()
    }
    
    
    
}
