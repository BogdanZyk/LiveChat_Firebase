//
//  CustomButtomView.swift
//  LiveChat
//
//  Created by Богдан Зыков on 28.06.2022.
//

import SwiftUI

struct CustomButtomView: View {
    var title: String
    var isDisabled: Bool = false
    var action: () -> Void
    var body: some View {
        Button {
            action()
        } label: {
            VStack{
                Text(title)
                    .font(.urbMedium(size: 18))
                    .foregroundColor(.white)
            }
            .hCenter()
            .frame(height: 50)
            .background(Color.accentBlue, in: RoundedRectangle(cornerRadius: 10))
        }
        .shadow(color: .secondaryFontGrey.opacity(0.2), radius: 6, x: 0, y: 6)
        .opacity(isDisabled ? 0.5 : 1)
        .disabled(isDisabled)
    }
}

struct CustomButtomView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            CustomButtomView(title: "Next", action: {})
            SocialButton(isGoogleBtn: true, action: {})
            SocialButton(isGoogleBtn: false, action: {})
        }
        .padding()
    }
}



struct SocialButton: View{
    var title: String {
        isGoogleBtn ? "Continue with Google" : "Continue with Facebook"
    }
    var isGoogleBtn: Bool = false
    var action: () -> Void
    var body: some View {
        Button {
            action()
        } label: {
            HStack(spacing: 10){
                Image(isGoogleBtn ? "Google" : "Facebook")
                    .resizable()
                    .frame(width: 24, height: 24)
                Text(title)
                    .font(.urbMedium(size: 16))
                    .foregroundColor(.fontPrimary)
            }
            .hCenter()
            .frame(height: 50)
            .background(Color.lightGrey, in: RoundedRectangle(cornerRadius: 10))
        }
        .shadow(color: .secondaryFontGrey.opacity(0.2), radius: 6, x: 0, y: 6)

    }
}
