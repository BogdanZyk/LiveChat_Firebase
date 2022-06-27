//
//  MainMessagesViewModel.swift
//  LiveChat
//
//  Created by Богдан Зыков on 04.06.2022.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import SwiftUI

class MainMessagesViewModel: ObservableObject{
    
    @Published var selectedChatUserId: String?
    @Published var errorMessage = ""
    @Published var showAlert: Bool = false
    @Published var recentMessages = [RecentMessages]()
    private var firestoreListener: ListenerRegistration?
    
    init(){
        fetchRecentMessages()
    }
    
    deinit{
        self.recentMessages.removeAll()
        firestoreListener?.remove()
    }
    
   

    
    private func fetchRecentMessages(){
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {return}
        firestoreListener = FirebaseManager.shared.firestore
            .collection(FBConstant.userChats)
            .document(uid)
            .collection(FBConstant.chats)
            .order(by: FBConstant.messageTimeInChat)
            .addSnapshotListener { [weak self] (shapshot, error) in
                guard let self = self else {return}
                if let error = error{
                    Helpers.handleError(error, title: "Failed to listen for recent messages", errorMessage: &self.errorMessage, showAlert: &self.showAlert)
                    return
                }
                shapshot?.documentChanges.forEach({ change in
                    if change.type != .removed{
                        let docId = change.document.documentID
                        if let index = self.recentMessages.firstIndex(where: {$0.id == docId}){
                            self.recentMessages.remove(at: index)
                        }
                        do{
                            let rm = try change.document.data(as: RecentMessages.self)
                            self.recentMessages.insert(rm, at: 0)
                            
                        }catch{
                            print("Failed to decode data \(error.localizedDescription)")
                        }
                    }
                })
            }
    }
    
    public func deleteChat(id: String){
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {return}
        FirebaseManager.shared.firestore
            .collection(FBConstant.userChats)
            .document(uid)
            .collection(FBConstant.chats)
            .document(id)
            .delete { error in
                if let error = error{
                    Helpers.handleError(error, title: "Failed to delete chat", errorMessage: &self.errorMessage, showAlert: &self.showAlert)
                }else{
                    self.deleteMessages(id: id, uid: uid)
                    withAnimation {
                        if let index =  self.recentMessages.firstIndex(where: {$0.uid == id}){
                            self.recentMessages.remove(at: index)
                        }
                    }
                }
            }
    }
    
    private func deleteMessages(id: String, uid: String){
        let room = Helpers.getRoomUid(toId: id, fromId: uid)
        FirebaseManager.shared.firestore
            .collection(FBConstant.chatMessages)
            .document(room)
            .collection(FBConstant.messages)
            .document()
            .delete { error in
                if let error = error{
                    Helpers.handleError(error, title: "Failed to delete all messages", errorMessage: &self.errorMessage, showAlert: &self.showAlert)
                }
                print("delete!!")
            }
    }

}
