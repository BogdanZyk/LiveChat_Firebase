//
//  MainMessagesViewModel.swift
//  LiveChat
//
//  Created by Богдан Зыков on 04.06.2022.
//

import Foundation
import Firebase

class MainMessagesViewModel: ObservableObject{
    
    @Published var errorMessage = ""
    @Published var showAlert: Bool = false
    @Published var currentUser: ChatUser?
    @Published var selectedChatUser: ChatUser?
    @Published var recentMessages = [RecentMessages]()
    
    
    init(){
        fetchCurrentUser()
        fetchRecentMessages()
    }
    
    
    private func fetchCurrentUser(){
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {return}
        FirebaseManager.shared.firestore.collection("users")
            .document(uid).getDocument { [weak self] (snapshot, error) in
                guard let self = self else {return}
                self.handleError(error, title: "Failed to fetch current user")
                guard let userData = Helpers.decodeUserData(snapshot) else {return}
                self.currentUser = userData
            }
    }
    
    private func fetchRecentMessages(){
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {return}
        FirebaseManager.shared.firestore
            .collection(FBConstant.resentMessages)
            .document(FBConstant.chat + uid)
            .collection("messages")
            .order(by: FBConstant.timestamp)
            .addSnapshotListener { [weak self] (shapshot, error) in
                guard let self = self else {return}
                if let error = error{
                    Helpers.handleError(error, title: "Failed to listen for recent messages", errorMessage: &self.errorMessage, showAlert: &self.showAlert)
                    return
                }
                shapshot?.documentChanges.forEach({ change in
                        let docId = change.document.documentID
                    if let index = self.recentMessages.firstIndex(where: {$0.documentId == docId}){
                        self.recentMessages.remove(at: index)
                    }
                    self.recentMessages.insert(.init(documentId: docId, data: change.document.data()), at: 0)
                        //self.recentMessages.append()
                })
            }
    }
    
    private func handleError(_ error: Error?, title: String){
        Helpers.handleError(error, title: title, errorMessage: &errorMessage, showAlert: &showAlert)
    }
}
