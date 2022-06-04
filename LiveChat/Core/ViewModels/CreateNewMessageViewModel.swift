//
//  CreateNewMessageViewModel.swift
//  LiveChat
//
//  Created by Богдан Зыков on 05.06.2022.
//

import Foundation

class CreateNewMessageViewModel: ObservableObject{
    
    @Published var users = [ChatUser]()
    @Published var errorMessage = ""
    @Published var showAlert: Bool = false
    
    init(){
        fetchAllUsers()
    }
    
    
    private func fetchAllUsers(){
        FirebaseManager.shared.firestore.collection("users")
            .getDocuments { [weak self] (documentSnapshot, error) in
                guard let self = self else {return}
                self.handleError(error, title: "Failed to fetch users")
                documentSnapshot?.documents.forEach({ snapshot in
                    guard let userData = Helpers.decodeUserData(snapshot) else {return}
                    self.users.append(userData)
                })
            }
    }
    private func handleError(_ error: Error?, title: String){
        Helpers.handleError(error, title: title, errorMessage: &errorMessage, showAlert: &showAlert)
    }
}
