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
            .collection(FBConstant.rooms)
            .document(FBConstant.room + fromId)
            .collection(FBConstant.messages + toId)
            .order(by: FBConstant.timestamp, descending: false)
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
        let messageData = [FBConstant.fromId:fromId,
                           FBConstant.toId: toId,
                           FBConstant.text: chatText,
                           FBConstant.timestamp: Timestamp()
        ] as [String : Any]
        
        createDocumentForResiverOrRecipient(isResiver: true, messageData: messageData, fromId: fromId, toId: toId)
        createDocumentForResiverOrRecipient(isResiver: false, messageData: messageData, fromId: fromId, toId: toId)
        persistRecentMessage()
       // persistRecentMessage2()
        chatText = ""
        
    }
    
    
    
    private func persistRecentMessage(){
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid, let chatUser = selectedChatUser else {return}
        let toId = chatUser.uid
       let document = FirebaseManager.shared.firestore
            .collection(FBConstant.resentMessages)
            .document(FBConstant.chat + uid)
            .collection("messages")
            .document(toId)
        let data = [
            FBConstant.timestamp: Timestamp(),
            FBConstant.text: chatText,
            FBConstant.fromId: uid,
            FBConstant.toId: toId,
            FBConstant.profileImageUrl: chatUser.profileImageUrl,
            FBConstant.name: chatUser.name
        ] as [String : Any]
        
        document.setData(data) { error in
            if let error = error{
                Helpers.handleError(error, title: "Failed to save persist recent message", errorMessage: &self.errorMessage, showAlert: &self.showAlert)
                return
            }
        }
    }
    
    private func persistRecentMessage2(){
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid, let chatUser = selectedChatUser else {return}
        let toId = chatUser.uid
       let document = FirebaseManager.shared.firestore
            .collection(FBConstant.resentMessages)
            .document(FBConstant.chat + toId)
            .collection("messages")
            .document(uid)
        let data = [
            FBConstant.timestamp: Timestamp(),
            FBConstant.text: chatText,
            FBConstant.fromId: uid,
            FBConstant.toId: toId,
            FBConstant.profileImageUrl: chatUser.profileImageUrl,
            FBConstant.name: chatUser.name
        ] as [String : Any]
        
        document.setData(data) { error in
            if let error = error{
                Helpers.handleError(error, title: "Failed to save persist recent message", errorMessage: &self.errorMessage, showAlert: &self.showAlert)
                return
            }
        }
    }
    
    //MARK: -  create document and save data for resiver recipient
    
    private func createDocumentForResiverOrRecipient(isResiver: Bool, messageData: [String : Any], fromId: String, toId: String){
        let room = FBConstant.room + (isResiver ? fromId : toId)
        let messages = FBConstant.messages + (isResiver ? toId : fromId)
        let document = FirebaseManager.shared.firestore
            .collection(FBConstant.rooms)
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


class FBConstant{
    
    
    //MARK: - For message collection and document
   
    static let rooms: String = "rooms"
    static let room: String = "room_"
    static let messages: String = "messages_"
    static let chat: String = "chat_"
    static let resentMessages = "resent_messages"
    static let fromId = "fromId"
    static let toId = "toId"
    static let timestamp = "timestamp"
    static let text = "text"
    static let profileImageUrl = "profileImageUrl"
    static let name = "name"
}
