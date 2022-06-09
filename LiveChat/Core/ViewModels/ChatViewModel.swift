//
//  ChatViewModel.swift
//  LiveChat
//
//  Created by Богдан Зыков on 05.06.2022.
//

import Foundation
import Firebase

class ChatViewModel: ObservableObject{
    
    @Published var errorMessage = ""
    @Published var showAlert: Bool = false
    @Published var selectedChatUser: ChatUser?
    @Published var chatText: String = ""
    @Published var messageReceive: Int = 0
    @Published var chatMessages = [ChatMessage]()
    
    init(selectedChatUser: ChatUser?){
        self.selectedChatUser = selectedChatUser
        fetchMessages()
    }
    
    
    //MARK: - Fecth all MESSAGES
    
    public func fetchMessages(){
        guard let fromId = FirebaseManager.shared.auth.currentUser?.uid, let toId = selectedChatUser?.uid else {return}
        FirebaseManager.shared.firestore
            .collection(AppConstants.rooms)
            .document(AppConstants.room + fromId)
            .collection(AppConstants.messages + toId)
            .order(by: "timestamp", descending: false)
            .addSnapshotListener{ [weak self] (shapshot, error) in
                guard let self = self else {return}
                if let error = error{
                    Helpers.handleError(error, title: "Failed to listen for message", errorMessage: &self.errorMessage, showAlert: &self.showAlert)
                    return
                }
                shapshot?.documentChanges.forEach({ change in
                    if change.type == .added{
                        let data = change.document.data()
                        self.chatMessages.append(.init(documentId: change.document.documentID, data: data))
                        
                    }
                })
                DispatchQueue.main.async {
                    self.messageReceive += 1
                }
            }
    }
    
    
    //MARK: - SEND MESSAGES
    
    public func sendMessage(){
        guard let fromId = FirebaseManager.shared.auth.currentUser?.uid, let toId = selectedChatUser?.uid else {return}
        let messageData = ["fromId":fromId, "toId": toId, "text": chatText, "timestamp": Timestamp()] as [String : Any]
        createDocumentForResiverOrRecipient(isResiver: true, messageData: messageData, fromId: fromId, toId: toId)
        createDocumentForResiverOrRecipient(isResiver: false, messageData: messageData, fromId: fromId, toId: toId)
        chatText = ""
    }
    
    
    
    
    
    //MARK: -  create document and save data for resiver recipient
    
    private func createDocumentForResiverOrRecipient(isResiver: Bool, messageData: [String : Any], fromId: String, toId: String){
        let room = AppConstants.room + (isResiver ? fromId : toId)
        let messages = AppConstants.messages + (isResiver ? toId : fromId)
        let document = FirebaseManager.shared.firestore.collection(AppConstants.rooms)
            .document(room)
            .collection(messages)
            .document()
        document.setData(messageData) { error in
            if let error = error{
                Helpers.handleError(error, title: "Failed to save message", errorMessage: &self.errorMessage, showAlert: &self.showAlert)
                return
            }
        }
    }
        
}


class AppConstants{
    
    
    //MARK: - For message collection and document
    
    static let rooms: String = "rooms"
    static let room: String = "room_"
    static let messages: String = "messages_"
   
}
