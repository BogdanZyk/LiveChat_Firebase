//
//  UserProfileViewModel.swift
//  LiveChat
//
//  Created by Богдан Зыков on 12.06.2022.
//

import Foundation


class UserProfileViewModel: ObservableObject {
    
    let userId: String?
    @Published var errorMessage = ""
    @Published var showAlert: Bool = false
    @Published var profileUser: User?
    
    init(userId: String?){
        self.userId = userId
        getUserInfo()
    }
    
    
    private func getUserInfo(){
        guard let userId = userId else {return}
        FirebaseManager.shared.firestore.collection("users")
            .document(userId).getDocument { [weak self] (snapshot, error) in
                guard let self = self else {return}
                self.handleError(error, title: "Failed to fetch user")
                guard let userData = Helpers.decodeUserData(snapshot) else {return}
                self.profileUser = userData
            }
    }
    
    private func handleError(_ error: Error?, title: String){
        Helpers.handleError(error, title: title, errorMessage: &errorMessage, showAlert: &showAlert)
    }
}
