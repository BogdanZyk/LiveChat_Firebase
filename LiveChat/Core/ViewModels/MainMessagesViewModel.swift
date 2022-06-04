//
//  MainMessagesViewModel.swift
//  LiveChat
//
//  Created by Богдан Зыков on 04.06.2022.
//

import Foundation


class MainMessagesViewModel: ObservableObject{
    
    @Published var errorMessage = ""
    @Published var showAlert: Bool = false
    @Published var currentUser: ChatUser?

    
    init(){
        fetchCurrentUser()
    }
    
    
    private func fetchCurrentUser(){
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {return}
        FirebaseManager.shared.firestore.collection("users")
            .document(uid).getDocument { [weak self] snapshot, error in
                guard let self = self else {return}
                self.handleError(error, title: "Failed to fetch current user")
                guard let data = snapshot?.data() else {return}
                guard let jsonData = try? JSONSerialization.data(withJSONObject: data) else{return}
                if let decodedResponse = try? JSONDecoder().decode(ChatUser.self, from: jsonData){
                    self.currentUser = decodedResponse
                }
            }
    }
    
    
    private func handleError(_ error: Error?, title: String){
        Helpers.handleError(error, title: title, errorMessage: &errorMessage, showAlert: &showAlert)
    }
}
