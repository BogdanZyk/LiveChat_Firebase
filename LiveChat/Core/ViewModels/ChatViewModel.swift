//
//  ChatViewModel.swift
//  LiveChat
//
//  Created by Богдан Зыков on 05.06.2022.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

class ChatViewModel: ObservableObject{
    
    @Published var errorMessage = ""
    @Published var showAlert: Bool = false
    @Published var selectedChatUser: ChatUser?
    @Published var currentUser: ChatUser?
    @Published var chatText: String = ""
    @Published var messageReceive: Int = 0
    @Published var chatMessages = [ChatMessage]()
    
    
    var firestoreListener: ListenerRegistration?
    
    
    init(selectedChatUser: ChatUser?, currentUser: ChatUser?){
        print("init")
        self.currentUser = currentUser
        self.selectedChatUser = selectedChatUser
        fetchMessages()
    }
    
    deinit{
        print("deinit")
        firestoreListener?.remove()
    }
    
    //MARK: - Fecth all MESSAGES
    
     func fetchMessages(){
        guard let fromId = FirebaseManager.shared.auth.currentUser?.uid, let toId = selectedChatUser?.uid else {return}
         let room = Helpers.getRoomUid(toId: toId, fromId: fromId)
        firestoreListener = FirebaseManager.shared.firestore
             .collection(FBConstant.chatMessages)
             .document(room)
             .collection(FBConstant.messages)
            .order(by: FBConstant.timestamp, descending: false)
            .addSnapshotListener{ [weak self] (shapshot, error) in
                guard let self = self else {return}
                if let error = error{
                    Helpers.handleError(error, title: "Failed to listen for message", errorMessage: &self.errorMessage, showAlert: &self.showAlert)
                    return
                }
                shapshot?.documentChanges.forEach({ change in
                    if change.type == .added{
                        do{
                            let message = try change.document.data(as: ChatMessage.self)
                            self.chatMessages.append(message)
                            print("add new message now ->>>>>>>>>")
                        }catch{
                            print("Failed to decode data \(error.localizedDescription)")
                        }
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
        
        createChatMessages(fromId: fromId, toId: toId, messageData: messageData)
        createUserChats(isResiver: true)
        createUserChats(isResiver: false)
        chatText = ""
        
    }
    
   
    
    //MARK: -  create User Chats
    
    private func createUserChats(isResiver: Bool){
        guard let fromId = FirebaseManager.shared.auth.currentUser?.uid, let chatUser = selectedChatUser, let currentUser = currentUser else {return}
        let toId = chatUser.uid
        let document = FirebaseManager.shared.firestore
            .collection(FBConstant.userChats)
            .document(isResiver ? fromId : toId)
            .collection(FBConstant.chats)
            .document(isResiver ? toId : fromId)
        let data = [
            FBConstant.timestamp: Timestamp(),
            FBConstant.text: chatText,
            FBConstant.fromId: fromId,
            FBConstant.toId: isResiver ? toId : fromId,
            FBConstant.profileImageUrl: isResiver ? chatUser.profileImageUrl : currentUser.profileImageUrl,
            FBConstant.name: isResiver ? chatUser.name : currentUser.name
        ] as [String : Any]
        
        document.setData(data) { error in
            if let error = error{
                Helpers.handleError(error, title: "Failed to save persist recent message", errorMessage: &self.errorMessage, showAlert: &self.showAlert)
                return
            }
        }
    }
    
    //MARK: - create messages
    private func createChatMessages(fromId: String, toId: String, messageData: [String : Any]){
        let room = Helpers.getRoomUid(toId: toId, fromId: fromId)
        let document = FirebaseManager.shared.firestore
            .collection(FBConstant.chatMessages)
            .document(room)
            .collection(FBConstant.messages)
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
    static let chats = "Chats"
    static let chatMessages = "ChatMessages"
    static let userChats = "UserChats"
    static let messages: String = "messages"
    static let resentMessages = "resent_messages"
    static let fromId = "fromId"
    static let toId = "toId"
    static let timestamp = "timestamp"
    static let text = "text"
    static let profileImageUrl = "profileImageUrl"
    static let name = "name"
}
