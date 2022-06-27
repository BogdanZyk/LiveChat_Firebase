//
//  MainMessagesView.swift
//  LiveChat
//
//  Created by Богдан Зыков on 04.06.2022.
//

import SwiftUI

struct MainMessagesView: View {
    @EnvironmentObject private var loginVM: LoginViewModel
    @StateObject private var mainMessVM = MainMessagesViewModel()
    @EnvironmentObject var userVM: UserManagerViewModel
    @State private var showSideBarView: Bool = false
    @State private var showNewMessageView: Bool = false
    @State private var showChatView: Bool = false
    @State private var searchText: String = ""
    @FocusState var isSearchFocused: Bool
    var body: some View {

            VStack(spacing: 0) {
                searchChatTextFieldView
                List{
                    chatRowSection
                }
                .listStyle(.plain)
                
                //userSettingNavigationLink
                chatViewNavigationLink
            }
            .foregroundColor(.fontPrimary)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    navigationTile
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    newMessageBtn
                }
            }
            .sheet(isPresented: $showNewMessageView) {
                CreateNewMessageView(showChatView: $showChatView, selectedChatUserId: $mainMessVM.selectedChatUserId)
            }
        
    }
}

struct MainMessagesView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MainMessagesView()
                .environmentObject(LoginViewModel())
                .environmentObject(UserManagerViewModel())
        }
//            .preferredColorScheme(.dark)
    }
}

extension MainMessagesView{
    
    
    private var navigationTile: some View{
        Text("Chatroom")
            .font(.urbMedium(size: 24))
            .foregroundColor(.fontPrimary)
    }
    private var newMessageBtn: some View{
        Button {
            showNewMessageView.toggle()
        } label: {
            CustomIconView(imageName: "create", width: 23, height: 23, color: .accentBlue, opacity: 1)
        }

    }
    
    private var searchChatTextFieldView: some View{
        HStack {
            TextFieldViewComponent(text: $searchText, promt: "Search your chat here", font: .urbRegular(size: 18), height: 50, cornerRadius: 20)
                .focused($isSearchFocused)
            if isSearchFocused{
                Button {
                    searchText = ""
                    withAnimation{
                        isSearchFocused = false
                    }
                } label: {
                    Text("Cancel")
                        .font(.urbRegular(size: 16))
                        .foregroundColor(.accentBlue)
                }
            }
        }
        .animation(.easeInOut, value: isSearchFocused)
        .padding(.top, 10)
        .padding(.horizontal, 15)
    }
    
    private var chatViewNavigationLink: some View{
        Group{
            NavigationLink(isActive: $showChatView) {
                ChatView(selectedChatUserId: mainMessVM.selectedChatUserId)
                    .environmentObject(userVM)
            } label: {
                EmptyView()
            }
        }
    }
    private var navActionButton: some View{
        HStack(spacing: 0){
            Button {
                
            } label: {
                Image(systemName: "magnifyingglass")
            }

            Button {
                showSideBarView.toggle()
            } label: {
                Image(systemName: "text.justify")
            }
        }
        .foregroundColor(.primary)
        .font(.system(size: 14, weight: .semibold))
    }
    
    private func chatRowView(_ resentMessage: RecentMessages) -> some View{
        Button {
            mainMessVM.selectedChatUserId = resentMessage.uid
            showChatView.toggle()
        } label: {
            HStack(spacing: 20){
                UserAvatarViewComponent(pathImage: resentMessage.profileImageUrl, size: .init(width: 55, height: 55))
                VStack(alignment: .leading, spacing: 6){
                    HStack {
                        Text(resentMessage.name)
                            .font(.urbMedium(size: 16))
                        Spacer()
                        Text(resentMessage.message.messageTime)
                            .font(.urbMedium(size: 12))
                            .foregroundColor(.gray)
                    }
                    Text(resentMessage.message.text)
                        .font(.urbMedium(size: 14))
                        .foregroundColor(.gray)
                }
                .lineLimit(1)
            }
            .padding(.vertical, 4)
            
       }
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            Button("Delete Chat", role: .destructive) {
                mainMessVM.deleteChat(id: resentMessage.uid)
            }
        }
    }
    
    private var chatRowSection: some View{
        Group {
            Text("Recent")
                .font(.urbMedium(size: 18))
            ForEach(mainMessVM.recentMessages){ resentMessage in
                chatRowView(resentMessage)
            }
        }
        .listRowSeparator(.hidden)
    }
    

}
