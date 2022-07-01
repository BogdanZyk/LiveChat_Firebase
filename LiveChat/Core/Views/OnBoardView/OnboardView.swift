//
//  OnboardView.swift
//  LiveChat
//
//  Created by Богдан Зыков on 29.06.2022.
//

import SwiftUI

struct OnboardView: View {
    @Environment(\.self) var env
    @Binding var showLoginView: Bool
    var body: some View {
        ZStack{
            Color.bgWhite.ignoresSafeArea()
            VStack(spacing: 40) {
                Image("onBoardImage")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: getRect().height / 2.3)
                VStack(spacing: 20) {
                    Text("Welcome to Chattie!")
                        .font(.urbMedium(size: 26))
                    Text("Chattie provides secure, simple and fast messaging all over the world. Join our team and enjoy online communication :)")
                        .font(.urbMedium(size: 16))
                        .foregroundColor(.secondaryFontGrey)
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, 40)
                buttonSectionView
            }
            .padding(.top, 10)
            .padding(.bottom, 10)
            .hCenter()
        }
    }
}

struct OnboardView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardView( showLoginView: .constant(true))
            .preferredColorScheme(.dark)
    }
}

extension OnboardView{
    private var buttonSectionView: some View{
        VStack(spacing: 20) {
            CustomButtomView(title: "Get Started", isDisabled: false) {
                showLoginView = false
                env.dismiss()
            }
            Button {
                showLoginView = true
                env.dismiss()
            } label: {
                Text("Already have an account?")
                    .font(.urbMedium(size: 16))
                    .foregroundColor(.fontPrimary)
            }
        }
        .padding(.horizontal, 20)
    }
}
