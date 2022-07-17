//
//  ContactsView.swift
//  LiveChat
//
//  Created by Богдан Зыков on 25.06.2022.
//

import SwiftUI

struct ContactsView: View {
    @EnvironmentObject var contactVM: ContactsViewModel
    var body: some View {
        ContactViewComponent(showChatView: .constant(true), selectedChatUserId: .constant("1"), isDismissAction: false, contactVM: contactVM)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    navTitle
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    addContactButton
                }
            }
    }
}

struct ContactsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ContactsView()
                .environmentObject(ContactsViewModel())
        }
    }
}
extension ContactsView{
    private var navTitle: some View{
        Text("Contacts")
            .font(.urbMedium(size: 18))
            .foregroundColor(.fontPrimary)
    }
    private var addContactButton: some View{
        Button {
            
        } label: {
            Image(systemName: "plus")
        }

    }
}
