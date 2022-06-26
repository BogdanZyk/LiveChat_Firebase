//
//  ChatView.swift
//  LiveChat
//
//  Created by Богдан Зыков on 05.06.2022.
//

import SwiftUI

struct ChatView: View {
    let selectedChatUser: User?
    @StateObject private var chatVM: ChatViewModel
    let columns = [GridItem(.flexible(minimum: 10))]
    let currentUserId = FirebaseManager.shared.auth.currentUser?.uid ?? ""
    init(selectedChatUser: User?, currentUser: User?){
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
                if !showDetailsImageView{
                    Text(chatVM.selectedChatUser?.name ?? "")
                        .font(.system(size: 17, weight: .semibold))
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                if !showDetailsImageView{
                    Button {
                        showProfileView.toggle()
                    } label: {
                        UserAvatarViewComponent(pathImage: chatVM.selectedChatUser?.profileImageUrl)
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(showDetailsImageView)
    }
}

//struct ChatView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationView {
//            ChatView(selectedChatUser: User(uid: "1", email: "test@test.com", profileImageUrl: "", name: "tester"), currentUser: User(uid: "2", email: "test2@test.com", profileImageUrl: "", name: "tester2"))
//        }
//    }
//}


extension ChatView{
    
    
//    private var navigationTitle: some View{
//        Group{
//
//        }
//    }
    
//    private var userAvatarButton: some View{
//        Group{
//
//        }
//    }
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
                    chatVM.sendMessage()
                } label: {
                    Image(systemName: "paperplane.fill")
                        .font(.title3)
                        .foregroundColor(chatVM.isActiveSendButton ? .blue : .secondary)
                }
                .disabled(!chatVM.isActiveSendButton)
            }
        }
        .padding(.horizontal, 15)
        .padding(.bottom, 10)
        .background(Color.gray.opacity(0.3))
    }
    
    private var imageViewForChatBottomBar: some View{
        Group{
            if let image = chatVM.imageData?.image{
                ZStack {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                    if chatVM.isLodaing{
                        Color.black.opacity(0.2)
                        ProgressView().tint(.white)
                            .scaleEffect(1.5)
                    }
                }
                .frame(width: 100, height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
        .overlay(alignment: .topTrailing) {
            Button {
                withAnimation(.easeInOut(duration: 0.15)) {
                    chatVM.deleteImage()
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
            ForEach(chatVM.chatMessages){
                messageRowView(messages: $0)
            }
        }
        .padding(.horizontal, 10)
    }
    private func messageRowView(messages: Message) -> some View{
        ChatBubble(direction: messages.fromId == currentUserId ? .right : .left) {
            let isRecevied = messages.fromId == currentUserId
            if let image = messages.imageURL, let imageURL = URL(string: image){
                textAndImageMessageView(messages, isRecevied: isRecevied, imageURL: imageURL)
                .onTapGesture {
                    chatVM.selectedChatMessages = messages
                    withAnimation {
                        showDetailsImageView.toggle()
                    }
                }
            }else{
                textMessageView(messages, isRecevied: isRecevied)
            }
        }
        .padding(.vertical, 4)
    }
    
    private func textMessageView(_ message: Message, isRecevied: Bool) -> some View{
            VStack(alignment: .leading, spacing: 5) {
                Text(message.text)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(isRecevied ? .white : .black)
            }
            .padding(EdgeInsets.init(top: 10, leading: 15, bottom: 10, trailing: 15))
            .background(isRecevied ? Color.blue : Color.cyan.opacity(0.5))
    }
    
    private func textAndImageMessageView(_ message: Message, isRecevied: Bool, imageURL: URL) -> some View{
        VStack(alignment: .leading, spacing: 0){
            ImageView(imageUrl: imageURL)
                .frame(width: 220, height: 200)
            if !message.text.isEmpty{
                Text(message.text)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(isRecevied ? .white : .black)
                    .padding(EdgeInsets.init(top: 10, leading: 15, bottom: 10, trailing: 15))
            }
        }
        .background(isRecevied ? Color.blue : Color.cyan.opacity(0.5))
    }
    private var detailsImageView: some View{
        Group{
            if showDetailsImageView{
                VStack{
                    if let image = chatVM.selectedChatMessages?.imageURL, let url = URL(string: image){
                        ImageView(imageUrl: url)
                            .frame(height: 400)
                            .padding(10)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.white)
                .toolbar{
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            withAnimation {
                                showDetailsImageView.toggle()
                            }
                        } label: {
                            Image(systemName: "chevron.left")
                        }
                        .foregroundColor(.black)
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
