//
//  ChatViewModel.swift
//  LiveChat
//
//  Created by Богдан Зыков on 05.06.2022.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift
import FirebaseFirestore
import FirebaseStorage

class ChatViewModel: ObservableObject{
    
    @Published var errorMessage = ""
    @Published var showAlert: Bool = false
    @Published var selectedChatUser: User?
    @Published var currentUser: User?
    @Published var chatText: String = ""
    @Published var messageReceive: Int = 0
    @Published var chatMessages = [Message]()
    @Published var imageData: UIImageData?
    @Published var selectedChatMessages: Message?
    @Published var isLoading: Bool = false
    @Published var preloadMessageImage: MessageWithImage?
    
    var selectedChatUserId: String?
    var uploadTask: StorageUploadTask?
    
    var firestoreListener: ListenerRegistration?
    
//    let mockchatMessages: [Message] = [Message(id: "1", fromId: "1", toId: "2", imageURL: "https://firebasestorage.googleapis.com/v0/b/live-chat-6f042.appspot.com/o/imagesChat_8aCkzc9qfCZ4LSjbgvLwYlyFhYa2ZqT9lsCoKFd9dZwcJYaQ3tuZ8nl1%2F4C84DB32-854C-4813-AE56-D69502FD9FBC.jpeg?alt=media&token=d03a696e-a70a-4973-aba1-2a99229e447f", text: "test"), Message(id: "2", fromId: "1", toId: "2", imageURL: "https://firebasestorage.googleapis.com/v0/b/live-chat-6f042.appspot.com/o/imagesChat_8aCkzc9qfCZ4LSjbgvLwYlyFhYa2ZqT9lsCoKFd9dZwcJYaQ3tuZ8nl1%2F4C84DB32-854C-4813-AE56-D69502FD9FBC.jpeg?alt=media&token=d03a696e-a70a-4973-aba1-2a99229e447f", text: ""), Message(id: "3", fromId: "1", toId: "2", imageURL: "", text: "Test test test")]
    
    
    public var isActiveSendButton: Bool{
       return !chatText.isEmpty || imageData != nil
    }
    
    init(selectedChatUserId: String?){
        self.selectedChatUserId = selectedChatUserId
        fetchUser()
        fetchMessages()
    }
    
    deinit{
        print("deinit")
        firestoreListener?.remove()
    }
    
    //MARK: - View all message
    
    public func viewLastMessage(){
        guard let fromId = FirebaseManager.shared.auth.currentUser?.uid, let toId = selectedChatUserId else {return}
        let document = FirebaseManager.shared.firestore
            .collection(FBConstant.userChats)
            .document(fromId)
            .collection(FBConstant.chats)
            .document(toId)
        document.updateData(["message.viewed": true])
    }
    
    
    //MARK: - Fetch chat user
    private func fetchUser(){
        guard let uid = selectedChatUserId else {return}
        FirebaseManager.shared.firestore.collection("users")
            .document(uid).getDocument { [weak self] (snapshot, error) in
                guard let self = self else {return}
                if let error = error{
                    print(error.localizedDescription)
                    Helpers.handleError(error, title: "Failed to fetch user", errorMessage: &self.errorMessage, showAlert: &self.showAlert)
                    
                }
                do{
                    let user = try snapshot?.data(as: User.self)
                    self.selectedChatUser = user
                }catch{
                    print("Failed to decode data \(error.localizedDescription)")
                }
                
            }
    }
    
    
    //MARK: - Fecth all MESSAGES
    
    private func fetchMessages(){
        guard let fromId = FirebaseManager.shared.auth.currentUser?.uid, let toId = selectedChatUserId else {return}
         let room = Helpers.getRoomUid(toId: toId, fromId: fromId)
        FirebaseManager.shared.firestore
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
                            let message = try change.document.data(as: Message.self)
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
    
    //MARK: - Delete Image for upload
    public func deleteImage(){
        if isLoading{
            uploadTask?.cancel()
        }
        preloadMessageImage = nil
        imageData = nil
    }
    

    
    //MARK: - SEND MESSAGES
    
    public func sendMessage(){
        guard let fromId = FirebaseManager.shared.auth.currentUser?.uid, let toId = selectedChatUser?.uid else {return}
        let messageText = chatText
        let image = imageData
        resetInputs()
        createPrelodaImageMessage(image: image?.image, text: messageText)
        createMessage(fromId: fromId, toId: toId, messageText: messageText, imageData: image)
    }
    private func createPrelodaImageMessage(image: UIImage?, text: String){
        guard let image = image else {return}
        DispatchQueue.main.async {
            self.preloadMessageImage = MessageWithImage(text: text, uiImage: image)
            self.messageReceive += 1
        }
    }
    
    private func resetInputs(){
        chatText = ""
        withAnimation(.easeInOut(duration: 0.15)){
            imageData = nil
        }
    }
    
    private func createMessage(fromId: String, toId: String, messageText: String, imageData: UIImageData?){
       let path = Helpers.getRoomUid(toId: toId, fromId: fromId)
        let ref = FirebaseManager.shared.storage.reference().child("imagesChat_\(path)").child(imageData?.imageName ?? "noName")
        uploadImage(ref: ref, image: imageData?.image) { url in
            let image = ImageData(imageURL: url?.absoluteString ?? "")
            let messageData = Message(fromId: fromId, toId: toId, text: messageText, image: image)
            self.saveMessageInFirebasestore(fromId: fromId, toId: toId, messageData: messageData) { [weak self] message in
                guard let self = self else {return}
                self.createUserChats(isResiver: true, message: message)
                self.createUserChats(isResiver: false, message: message)
            }
        }
    }

   
    
    //MARK: -  create User Chats
    
    private func createUserChats(isResiver: Bool, message: Message){
        guard let fromId = FirebaseManager.shared.auth.currentUser?.uid, let chatUser = selectedChatUser, let currentUser = currentUser else {return}
        let toId = chatUser.uid
        let document = FirebaseManager.shared.firestore
            .collection(FBConstant.userChats)
            .document(isResiver ? fromId : toId)
            .collection(FBConstant.chats)
            .document(isResiver ? toId : fromId)
        
        let chatData = RecentMessages(uid: isResiver ? toId : fromId, name: isResiver ? chatUser.firstName : currentUser.firstName, profileImageUrl: (isResiver ? chatUser.profileImageUrl : currentUser.profileImageUrl) ?? "", message: message)
        do {
            try document.setData(from: chatData, completion: { error in
                if let error = error{
                    Helpers.handleError(error, title: "Failed to save persist recent message", errorMessage: &self.errorMessage, showAlert: &self.showAlert)
                    return
                }
                })
        } catch {
            Helpers.handleError(error, title: "Failed to save persist recent message", errorMessage: &self.errorMessage, showAlert: &self.showAlert)
        }
    }
    
    //MARK: - create messages
    private func saveMessageInFirebasestore(fromId: String, toId: String, messageData: Message, completion: @escaping (_ message: Message) -> Void){
        let room = Helpers.getRoomUid(toId: toId, fromId: fromId)
        let document = FirebaseManager.shared.firestore
            .collection(FBConstant.chatMessages)
            .document(room)
            .collection(FBConstant.messages)
            .document()
        try? document.setData(from: messageData, completion: { error in
            if let error = error{
                Helpers.handleError(error, title: "Failed to save message", errorMessage: &self.errorMessage, showAlert: &self.showAlert)
                return
            }
            completion(messageData)
        })
    }
    
    
    private func uploadImage(ref: StorageReference, image: UIImage?, completion: @escaping (_ url: URL?) -> Void){
        guard let imageData = Helpers.preparingImageforUpload(image) else {return completion(nil)}
        self.uploadTask = ref.putData(imageData, metadata: nil) { [weak self] (metadate, error) in
            guard let self = self else {return completion(nil)}
            if let error = error{
                Helpers.handleError(error, title: "Failed to upload image:", errorMessage: &self.errorMessage, showAlert: &self.showAlert)
                return
            }
            ref.downloadURL {[weak self]  (url, error) in
                guard let self = self else {return completion(nil)}
                if let error = error{
                    Helpers.handleError(error, title: "Failed to load image url:", errorMessage: &self.errorMessage, showAlert: &self.showAlert)
                    return
                }
                completion(url)
            }
        }
        uploadTask?.observe(.progress) { snapshot in
            self.isLoading = snapshot.status == .progress
        }
    }
    
 
}



struct MessageWithImage {
    let text: String
    let uiImage: UIImage
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
    static let messageTimeInChat = "message.timestamp"
}
