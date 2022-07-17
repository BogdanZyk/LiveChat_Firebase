//
//  ChatView.swift
//  LiveChat
//
//  Created by Богдан Зыков on 05.06.2022.
//

import SwiftUI

struct ChatView: View {
    let selectedChatUserId: String?
    @EnvironmentObject var userVM: UserManagerViewModel
    @StateObject private var chatVM: ChatViewModel
    let columns = [GridItem(.flexible(minimum: 10))]
    let currentUserId = FirebaseManager.shared.auth.currentUser?.uid ?? ""
    init(selectedChatUserId: String?){
        self.selectedChatUserId = selectedChatUserId
        self._chatVM = StateObject.init(wrappedValue: ChatViewModel(selectedChatUserId: selectedChatUserId))
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
            
            NavigationLink(isActive: $showProfileView) {
                UserProfileView(user: chatVM.selectedChatUser)
            } label: {
                EmptyView()
            }
        }
        .safeAreaInset(edge: .bottom){
            chatBottomBar
        }
        .background(Color.bgWhite)
        .onAppear{
            chatVM.currentUser = userVM.currentUser
        }
        .overlay{
            detailsImageView
        }
        .sheet(isPresented: $showImagePicker, onDismiss: nil) {
            ImagePicker(imageData: $chatVM.imageData)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                navigationAvatarSection
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                navigationActionButton
            }
        }
        .navigationBarBackButtonHidden(showDetailsImageView)
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ChatView(selectedChatUserId: "Ez2lDmtzekf0I4KV8yrcqPLR5jp1")
                .environmentObject(UserManagerViewModel())
                .preferredColorScheme(.light)
        }
    }
}


extension ChatView{
    
    
    private var navigationAvatarSection: some View {
        Group{
            if !showDetailsImageView{
                HStack(spacing: 8) {
                    Button {
                        showProfileView.toggle()
                    } label: {
                        UserAvatarViewComponent(pathImage: chatVM.selectedChatUser?.profileImageUrl)
                    }
                    VStack(alignment: .leading, spacing: 5) {
                        Text(chatVM.selectedChatUser?.firstName ?? "Tester")
                            .font(.urbMedium(size: 16))
                            .foregroundColor(.fontPrimary)
                        Text("Online")
                            .font(.urbMedium(size: 14))
                            .foregroundColor(.secondaryGreen)
                    }
                }
            }
        }
    }
    private var navigationActionButton: some View{
        HStack(spacing: 15){
            CustomIconView(imageName: "video", width: 25, height: 25, color: .accentBlue, opacity: 1)
            CustomIconView(imageName: "Contacts", width: 20, height: 20, color: .accentBlue, opacity: 1)
        }
    }
    
    private var chatBottomBar: some View{
        VStack(alignment: .leading, spacing: 20) {
            Divider()
            imageViewForChatBottomBar
            HStack(spacing: 15) {
                Button {
                    showImagePicker.toggle()
                } label: {
                    CustomIconView(imageName: "pin", width: 22, height: 22, color: .secondaryFontGrey, opacity: 1)
                }
                TextFieldViewComponent(text: $chatVM.chatText, promt: "Enter your message...", font: .urbMedium(size: 16), height: 45, cornerRadius: 10)
                Button {
                    chatVM.sendMessage()
                } label: {
                    Image(systemName: "paperplane.fill")
                        .font(.title3)
                        .foregroundColor(chatVM.isActiveSendButton ? .accentBlue : .secondaryFontGrey)
                }
                .disabled(!chatVM.isActiveSendButton)
            }
            .padding(.horizontal, 15)
        }
        .padding(.bottom, 10)
        .background(Color.secondaryBlueTheme.opacity(0.5))
        .background(.regularMaterial)
    }
    
    private var imageViewForChatBottomBar: some View{
        Group{
            if let image = chatVM.imageData?.image{
                ZStack {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                    if chatVM.isLoading{
                        Color.black.opacity(0.2)
                        ProgressLoader()
                    }
                }
                .frame(width: 100, height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.leading, 20)
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
            .padding(.vertical, 4)
            preloaderImageMessageView
        }
        .padding(.horizontal, 10)
    }
    
    private var preloaderImageMessageView: some View{
        Group{
            if let preloadMessage = chatVM.preloadMessageImage, chatVM.isLoading{
                ChatBubble(direction: .right) {
                    VStack(alignment: .leading, spacing: 0) {
                        Image(uiImage: preloadMessage.uiImage)
                            .centerCropped()
                            .frame(width: 220, height: 200)
                        if !preloadMessage.text.isEmpty{
                            Text(preloadMessage.text)
                                .font(.urbRegular(size: 14))
                                .foregroundColor(.white)
                                .padding(EdgeInsets.init(top: 10, leading: 15, bottom: 10, trailing: 15))
                        }
                    }
                    .overlay{
                        Color.secondaryFontGrey.opacity(0.6)
                        ProgressLoader(color: .white, scaleEffect: 2)
                        Button {
                            withAnimation {
                                chatVM.deleteImage()
                            }
                        } label: {
                            Image(systemName: "xmark")
                                .font(.urbMedium(size: 10))
                                .foregroundColor(.white)
                                .padding(20)
                        }
                    }
                    .background(.blue)
                }
                .padding(.vertical, 4)
            }
        }
    }
    
    private func messageRowView(messages: Message) -> some View{
        ChatBubble(direction: messages.fromId == currentUserId ? .right : .left) {
            let isRecevied = messages.fromId == currentUserId
            if let image = messages.image.imageURL, let imageURL = URL(string: image){
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
        .onAppear{
            if messages.id == chatVM.chatMessages.last?.id{
                chatVM.viewLastMessage()
            }
        }
    }
    
    private func textMessageView(_ message: Message, isRecevied: Bool) -> some View{
        let recivedColorBg: LinearGradient = LinearGradient(colors: [.messBlueLight, .messBlueDark], startPoint: .topTrailing, endPoint: .bottomLeading)
        let messBg: LinearGradient = LinearGradient(colors: [.secondaryBlue], startPoint: .trailing, endPoint: .leading)
        var bgColor: LinearGradient{
            isRecevied ? recivedColorBg : messBg
        }
          return  HStack(alignment: .bottom, spacing: 5) {
                Text(message.text)
                  .font(.urbRegular(size: 14))
                  .foregroundColor(isRecevied ? .white : .whiteOrGray)
                Text(message.messageTime)
                    .font(.urbRegular(size: 10))
                    .foregroundColor(isRecevied ? .white : .whiteOrGray).opacity(0.8)
            }
            .padding(EdgeInsets.init(top: 10, leading: 15, bottom: 10, trailing: 15))
            .background(bgColor)
    }
    
    private func textAndImageMessageView(_ message: Message, isRecevied: Bool, imageURL: URL) -> some View{
        let recivedColorBg: LinearGradient = LinearGradient(colors: [.messBlueLight, .messBlueDark], startPoint: .topTrailing, endPoint: .bottomLeading)
        let messBg: LinearGradient = LinearGradient(colors: [.secondaryBlue], startPoint: .trailing, endPoint: .leading)
        var bgColor: LinearGradient{
            isRecevied ? recivedColorBg : messBg
        }
        return VStack(alignment: .leading, spacing: 0){
            ImageView(imageUrl: imageURL)
                .frame(width: 220, height: 200)
            if !message.text.isEmpty{
                Text(message.text)
                    .font(.urbRegular(size: 14))
                    .foregroundColor(isRecevied ? .white : .whiteOrGray)
                    .padding(EdgeInsets.init(top: 10, leading: 15, bottom: 10, trailing: 15))
            }
        }
        .background(bgColor)
    }
    private var detailsImageView: some View{
        Group{
            if showDetailsImageView{
                VStack{
                    if let image = chatVM.selectedChatMessages?.image.imageURL, let url = URL(string: image){
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
