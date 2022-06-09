//
//  NewMessageView.swift
//  LiveChat
//
//  Created by Богдан Зыков on 04.06.2022.
//

import SwiftUI

struct CreateNewMessageView: View {
    @Environment(\.self) var env
    @Binding var showChatView: Bool
    @Binding var selectedChatUser: ChatUser?
    @StateObject private var createMessVM = CreateNewMessageViewModel()
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 0){
                List{
                    ForEach(createMessVM.users, id: \.uid) { user in
                        userRowView(user)
                    }
                }
                .listStyle(.plain)
            }
            .searchable(text: $createMessVM.searchText, prompt: "Search users", suggestions: {
                searchResultSection
            })
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    navTitle
                }
                ToolbarItem(placement: .cancellationAction) {
                    closeButton
                }
            }
        }
    }
}

struct CreateNewMessageView_Previews: PreviewProvider {
    static var previews: some View {
        CreateNewMessageView(showChatView: .constant(true), selectedChatUser: .constant(ChatUser(uid: "1", email: "", profileImageUrl: "", name: "")))
    }
}


extension CreateNewMessageView{
    
    //MARK: -  Toolbar section
    
    private var navTitle: some View{
        Text("Send message")
            .font(.headline).bold()
    }
    private var closeButton: some View{
        Button {
            env.dismiss()
        } label: {
            Text("Cancel")
        }
    }
    private func userRowView(_ user: ChatUser) -> some View{
        Button {
            selectedChatUser = user
            showChatView.toggle()
            env.dismiss()
        } label: {
            HStack{
                UserAvatarViewComponent(pathImage: user.profileImageUrl, size: CGSize.init(width: 50, height: 50))
                Text(user.name)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primary)
            }
            .padding(.vertical, 5)
        }
    }
    
    private var searchResultSection: some View{
        Group{
            if !createMessVM.searchText.isEmpty && createMessVM.searchResult.isEmpty{
                Text("No search user")
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
            }else{
                ForEach(createMessVM.searchResult, id: \.uid) { user in
                    userRowView(user)
                }
            }
        }
    }
}
