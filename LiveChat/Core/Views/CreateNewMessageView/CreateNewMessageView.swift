//
//  NewMessageView.swift
//  LiveChat
//
//  Created by Богдан Зыков on 04.06.2022.
//

import SwiftUI

struct CreateNewMessageView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var showChatView: Bool
    @Binding var selectedChatUserId: String?
    @EnvironmentObject private var contactVM: ContactsViewModel
    var body: some View {
        NavigationView {
                ContactViewComponent(showChatView: $showChatView, selectedChatUserId: $selectedChatUserId, isDismissAction: true, contactVM: contactVM)
            
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
        CreateNewMessageView(showChatView: .constant(true), selectedChatUserId: .constant("2we"))
            .environmentObject(ContactsViewModel())
            .preferredColorScheme(.dark)
    }
}


extension CreateNewMessageView{
    
    //MARK: -  Toolbar section
    
    private var navTitle: some View{
        Text("New Message")
            .font(.urbMedium(size: 18))
            .foregroundColor(.fontPrimary)
    }
    private var closeButton: some View{
        Button {
            dismiss()
        } label: {
            Text("Cancel")
        }
        .font(.urbMedium(size: 15))
    }
}
