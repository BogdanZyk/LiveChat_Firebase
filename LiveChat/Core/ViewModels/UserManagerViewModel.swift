//
//  UserManager.swift
//  LiveChat
//
//  Created by Богдан Зыков on 12.06.2022.
//

import Foundation


class UserManagerViewModel: ObservableObject{
    
    @Published var errorMessage = ""
    @Published var showAlert: Bool = false
    @Published var currentUser: User?
    
    init(){
        fetchCurrentUser()
    }
    
    private func fetchCurrentUser(){
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {return}
        FirebaseManager.shared.firestore.collection("users")
            .document(uid)
            .addSnapshotListener { documentSnapshot, error in
                if let error = error{
                    self.handleError(error, title: "Failed to fetch current user")
                }
                do{
                    self.currentUser = try documentSnapshot?.data(as: User.self)
                }catch{
                    print("Failed to decode user data \(error.localizedDescription)")
                }
            }
    }
    
    private func handleError(_ error: Error?, title: String){
        Helpers.handleError(error, title: title, errorMessage: &errorMessage, showAlert: &showAlert)
    }
}
