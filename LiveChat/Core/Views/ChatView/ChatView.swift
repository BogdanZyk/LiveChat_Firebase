//
//  ChatView.swift
//  LiveChat
//
//  Created by Богдан Зыков on 05.06.2022.
//

import SwiftUI

struct ChatView: View {
    let selectedChatUser: ChatUser?
    @StateObject private var chatVM: ChatViewModel
    let columns = [GridItem(.flexible(minimum: 10))]
    let currentUserId = FirebaseManager.shared.auth.currentUser?.uid ?? ""
    init(selectedChatUser: ChatUser?){
        self.selectedChatUser = selectedChatUser
        self._chatVM = StateObject.init(wrappedValue: ChatViewModel(selectedChatUser: selectedChatUser))
    }
    @State private var showProfileView: Bool = false
    let scrollId = "BOTTOM"
    var body: some View {
        VStack(spacing: 0){
            ScrollViewReader{ scrollViewReader in
                ReversedScrollView{
                    messagesSection
                    emptyBottomAnhor
                }
                .onReceive(chatVM.$messageReceive) { _ in
                    withAnimation {
                        scrollViewReader.scrollTo(scrollId)
                    }
                }
            }
            chatBottomBar
            NavigationLink(isActive: $showProfileView) {
                Text("profile View")
            } label: {
                EmptyView()
            }

        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(chatVM.selectedChatUser?.name ?? "")
                    .font(.system(size: 17, weight: .semibold))
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showProfileView.toggle()
                } label: {
                    UserAvatarViewComponent(pathImage: chatVM.selectedChatUser?.profileImageUrl)
                }
            }
        }
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ChatView(selectedChatUser: ChatUser(uid: "1", email: "test@test.com", profileImageUrl: "", name: "tester"))
        }
    }
}


extension ChatView{
    private var chatBottomBar: some View{
        VStack(spacing: 20) {
            Divider()
            HStack(spacing: 15) {
                Group{
                    TextField("Enter your message...", text: $chatVM.chatText)
                }
                .padding(10)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                Button {
                    if !chatVM.chatText.isEmpty{
                        chatVM.sendMessage()
                    }
                } label: {
                    Image(systemName: "paperplane.fill")
                        .font(.title3)
                        .foregroundColor(chatVM.chatText.isEmpty ? .secondary : .blue)
                }
                .disabled(chatVM.chatText.isEmpty)
            }.padding(.horizontal, 15)
        }
        .padding(.bottom, 10)
        .background(Color.gray.opacity(0.3))
    }
    
    private var emptyBottomAnhor: some View{
        Text("")
            .id(scrollId)
            .padding(0)
    }
    
    private var messagesSection: some View{
        LazyVGrid(columns: columns, spacing: 0, pinnedViews: [.sectionHeaders]) {
            ForEach(chatVM.chatMessages){
                messageRowView(messages: $0)
            }
        }.padding(.bottom, 10)
            .padding(.horizontal, 15)
    }
    private func messageRowView(messages: ChatMessage) -> some View{
        Group {
            let isRecevied = messages.fromId == currentUserId
            HStack {
                VStack {
                    Text(messages.text)
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(isRecevied ? .white : .black)
                }
                .padding(10)
                .padding(.horizontal, 5)
                .background(isRecevied ? Color.blue : Color.cyan.opacity(0.5))
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .padding(.vertical, 4)
            }
            .frame(maxWidth: .infinity, alignment: isRecevied ? .trailing : .leading)
        }
    }
}
