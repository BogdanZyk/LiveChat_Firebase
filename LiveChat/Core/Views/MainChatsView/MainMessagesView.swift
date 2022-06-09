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
    @State private var showSideBarView: Bool = false
    @State private var showNewMessageView: Bool = false
    @State private var showChatView: Bool = false
    var body: some View {
        NavigationView{
            VStack(spacing: 0) {
//                ScrollView(.horizontal, showsIndicators: false){
//                    HStack{
//                        ForEach(mainMessVM.recentMessages){ resentMessage in
//                            UserAvatarViewComponent(pathImage: resentMessage.profileImageUrl, size: .init(width: 40, height: 40))
//                        }
//                    }
//                    .padding(.leading, 20)
//                }
//
                List{
                    chatRowSection
                }
                .listStyle(.plain)
                userSettingNavigationLink
                chatViewNavigationLink
            }
            .overlay(alignment: .bottomTrailing){
                newMessageButton
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    prorileAvatarNavView
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    navActionButton
                }
            }
            .sheet(isPresented: $showNewMessageView) {
                CreateNewMessageView(showChatView: $showChatView, selectedChatUser: $mainMessVM.selectedChatUser)
            }
        }
    }
}

struct MainMessagesView_Previews: PreviewProvider {
    static var previews: some View {
        MainMessagesView()
            .environmentObject(LoginViewModel())
//            .preferredColorScheme(.dark)
    }
}

extension MainMessagesView{
    
    
    //MARK: - navbar
    private var prorileAvatarNavView: some View{
        HStack {
            UserAvatarViewComponent(pathImage: mainMessVM.currentUser?.profileImageUrl)
            VStack(alignment: .leading, spacing: 2){
                Text("Hey!")
                    .font(.caption)
                Text(mainMessVM.currentUser?.name ?? "")
                    .font(.system(size: 14, weight: .semibold))
            }
        }
        .padding(.leading, 5)
    }
    
    private var userSettingNavigationLink: some View{
        Group{
            NavigationLink(isActive: $showSideBarView) {
                SideBarView(loginVM: loginVM)
            } label: {
                EmptyView()
            }
        }
    }
    
    private var chatViewNavigationLink: some View{
        Group{
            NavigationLink(isActive: $showChatView) {
                ChatView(selectedChatUser: mainMessVM.selectedChatUser)
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
            mainMessVM.selectedChatUser = ChatUser(uid: resentMessage.toId, email: "", profileImageUrl: resentMessage.profileImageUrl, name: resentMessage.name)
            showChatView.toggle()
        } label: {
            HStack(spacing: 15){
                UserAvatarViewComponent(pathImage: resentMessage.profileImageUrl, size: .init(width: 55, height: 55))
                VStack(alignment: .leading, spacing: 8){
                    Text(resentMessage.name)
                        .font(.system(size: 16, weight: .bold))
                    Text(resentMessage.text)
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                }
                .lineLimit(1)
                Spacer()
                Text("22d")
                    .font(.system(size: 14, weight: .semibold))
            }
        }
    }
    
    private var chatRowSection: some View{
        ForEach(mainMessVM.recentMessages){ resentMessage in
            chatRowView(resentMessage)
        }
    }
    
    private var newMessageButton: some View{
        Button {
            showNewMessageView.toggle()
        } label: {
            ZStack{
                Color.blue
                Image(systemName: "message.fill")
                    .foregroundColor(.white)
                    .font(.system(size: 18))
            }
            .frame(width: 60, height: 60)
            .clipShape(Circle())
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
        .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 0)
        .padding()
    }
}
