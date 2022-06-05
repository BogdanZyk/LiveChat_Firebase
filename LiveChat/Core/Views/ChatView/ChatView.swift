//
//  ChatView.swift
//  LiveChat
//
//  Created by Богдан Зыков on 05.06.2022.
//

import SwiftUI

struct ChatView: View {
    @EnvironmentObject var chatVM: ChatViewModel
    @State private var text: String = ""
    let columns = [GridItem(.flexible(minimum: 10))]
    var body: some View {
        VStack(spacing: 0){
            ScrollViewReader{ scrollViewReader in
                ReversedScrollView{
                    messagesSection
                }
            }
            chatBottomBar
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(chatVM.selectedChatUser?.name ?? "userName")
                    .font(.system(size: 17, weight: .semibold))
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    
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
            ChatView()
                .environmentObject(ChatViewModel())
        }
    }
}


extension ChatView{
    private var chatBottomBar: some View{
        VStack(spacing: 20) {
            Divider()
            HStack(spacing: 15) {
                Group{
                    TextField("Enter your message...", text: $text)
                }
                .padding(10)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                Button {
                    text = ""
                } label: {
                    Image(systemName: "paperplane.fill")
                        .font(.title3)
                        .foregroundColor(text.isEmpty ? .secondary : .blue)
                }
                .disabled(text.isEmpty)
            }.padding(.horizontal, 15)
        }
        .padding(.bottom, 10)
        .background(Color.gray.opacity(0.3))
    }
    
    
    private var messagesSection: some View{
        LazyVGrid(columns: columns, spacing: 0, pinnedViews: [.sectionHeaders]) {
            ForEach(1...10, id: \.self){ind in
                messageRowView(isRecevied: ind % 2 == 0, ind: ind)
            }
        }.padding(.bottom, 10)
            .padding(.horizontal, 15)
    }
    private func messageRowView(isRecevied: Bool, ind: Int) -> some View{
        HStack {
            VStack {
                Text("message \(ind)")
            }
            .padding(10)
            .padding(.horizontal, 5)
            .background(isRecevied ? Color.blue : Color.cyan.opacity(0.5))
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .padding(.vertical, 4)
        }
        .frame(maxWidth: .infinity, alignment: isRecevied ? .leading : .trailing)
    }
}
