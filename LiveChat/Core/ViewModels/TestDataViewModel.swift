//
//  TestDataViewModel.swift
//  LiveChat
//
//  Created by Богдан Зыков on 26.06.2022.
//

import Foundation

class TestDataViewModel: ObservableObject{
    
    
    @Published var messages: Message2?
    
    func createTestMessage(){
        let message = Message2(id: nil, fromId: nil, toId: nil, imageURL: nil, text: "HIIIIIII!!!")
        do {
            try  FirebaseManager.shared.firestore.collection("testMessage").document("messages").setData(from: message)
        } catch let error {
            print("Error writing city to Firestore: \(error.localizedDescription)")
        }
    }
    
    func fetchTestMessage(){
        let docRef = FirebaseManager.shared.firestore.collection("testMessage").document("messages")
        
        docRef.getDocument(as: Message2.self) { result in
            switch result{
            case .success(let res):
                self.messages = res
            case .failure(let error):
                print(error)
            }
        }
    }
}
