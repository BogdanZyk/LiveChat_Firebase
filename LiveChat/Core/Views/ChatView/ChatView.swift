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
    init(selectedChatUser: ChatUser?, currentUser: ChatUser?){
        self.selectedChatUser = selectedChatUser
        self._chatVM = StateObject.init(wrappedValue: ChatViewModel(selectedChatUser: selectedChatUser, currentUser: currentUser))
    }
    @State private var showProfileView: Bool = false
    @State private var showImagePicker: Bool = false
    @State private var showDetailsImageView: Bool = false
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
                UserProfileView(userId: chatVM.selectedChatUser?.uid)
            } label: {
                EmptyView()
            }
        }
        .overlay{
            detailsImageView
        }
        .sheet(isPresented: $showImagePicker, onDismiss: nil) {
            ImagePicker(imageData: $chatVM.imageData)
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
            ChatView(selectedChatUser: ChatUser(uid: "1", email: "test@test.com", profileImageUrl: "", name: "tester"), currentUser: ChatUser(uid: "2", email: "test2@test.com", profileImageUrl: "", name: "tester2"))
        }
    }
}


extension ChatView{
    
    private var chatBottomBar: some View{
        VStack(alignment: .leading, spacing: 20) {
            Divider()
            imageViewForChatBottomBar
            HStack(spacing: 15) {
                Button {
                    showImagePicker.toggle()
                } label: {
                    Image(systemName: "photo.on.rectangle.angled")
                        .font(.title3)
                        .foregroundColor(.blue)
                }
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
            }
        }
        .padding(.horizontal, 15)
        .padding(.bottom, 10)
        .background(Color.gray.opacity(0.3))
    }
    
    private var imageViewForChatBottomBar: some View{
        Group{
            if let image = chatVM.imageData?.image{
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
        .overlay(alignment: .topTrailing) {
            Button {
                withAnimation(.easeInOut(duration: 0.15)) {
                    chatVM.imageData = nil
                }
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.white)
                    .font(.callout)
                    .padding(5)
            }
        }
    }
    
    private var emptyBottomAnhor: some View{
        Text("")
            .id(scrollId)
            .padding(0)
    }
    
    private var messagesSection: some View{
        LazyVGrid(columns: columns, spacing: 0, pinnedViews: [.sectionHeaders]) {
            ForEach(chatVM.mockchatMessages){
                messageRowView(messages: $0)
            }
        }.padding(.bottom, 10)
            .padding(.horizontal, 15)
    }
    private func messageRowView(messages: ChatMessage) -> some View{
        Group {
            let isRecevied = messages.fromId == currentUserId
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    if let image = messages.imageURL, let imageUrl = URL(string: image){
                        ImageView(imageUrl: imageUrl)
                            .frame(width: 220, height: 200)
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                    }
                    
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
            .onTapGesture {
                chatVM.selectedChatMessages = messages
                withAnimation {
                    showDetailsImageView.toggle()
                }
            }
        }
    }
    private var detailsImageView: some View{
        Group{
            if showDetailsImageView{
                ZStack{
                    Color.black.opacity(0.7).ignoresSafeArea()
                    if let image =  chatVM.selectedChatMessages?.imageURL, let url = URL(string: image){
                        ImageView(imageUrl: url)
                            .frame(height: 400)
                            .padding(10)
                    }
                }
                .onTapGesture {
                    withAnimation {
                        showDetailsImageView.toggle()
                    }
                }
            }
        }
    }
}
