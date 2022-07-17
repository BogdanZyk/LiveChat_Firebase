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
        
        
    }
}

struct ContactsView_Previews: PreviewProvider {
    static var previews: some View {
        ContactsView()
            .environmentObject(ContactsViewModel())
    }
}
