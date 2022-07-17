//
//  CreateNewMessageViewModel.swift
//  LiveChat
//
//  Created by Богдан Зыков on 05.06.2022.
//

import Foundation
import Combine

class ContactsViewModel: ObservableObject{
    
    @Published var users = [User]()
    @Published var errorMessage = ""
    @Published var showAlert: Bool = false
    @Published var searchText: String = ""
    @Published var searchResult = [User]()
    
    var cancellable = Set<AnyCancellable>()
    
    init(){
        fetchAllUsers()
        startSubscriptions()
    }
    
    
    func startSubscriptions(){
        $searchText
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .sink { searchText in
                self.searchResult = self.users.filter{$0.firstName.lowercased().contains(searchText.lowercased())}
            }
            .store(in: &cancellable)
    }
    
    
    
    public func fetchAllUsers(){
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {return}
        FirebaseManager.shared.firestore
            .collection("users").whereField("uid", isNotEqualTo: uid)
            .getDocuments { [weak self] (documentSnapshot, error) in
                guard let self = self else {return}
                self.handleError(error, title: "Failed to fetch users")
                documentSnapshot?.documents.forEach({ snapshot in
                    do{
                    let user = try snapshot.data(as: User.self)
                        self.users.append(user)
                    }catch{
                        self.handleError(error, title: "Failed to decode user data")
                    }
                })
            }
    }
    private func handleError(_ error: Error?, title: String){
        Helpers.handleError(error, title: title, errorMessage: &errorMessage, showAlert: &showAlert)
    }
    
    

}
