//
//  NewMessageView.swift
//  LiveChat
//
//  Created by Богдан Зыков on 04.06.2022.
//

import SwiftUI

struct CreateNewMessageView: View {
    @Environment(\.self) var env
    @State private var text: String = ""
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 0){
                List{
                    Text("test")
                }
            }
            .searchable(text: $text, prompt: "Search users")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Send message")
                        .font(.headline).bold()
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        env.dismiss()
                    } label: {
                        Text("Cancel")
                    }

                }
        }
        }
    }
}

struct CreateNewMessageView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CreateNewMessageView()
        }
    }
}
