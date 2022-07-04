//
//  ChangeProfileInfoView.swift
//  LiveChat
//
//  Created by Богдан Зыков on 03.07.2022.
//

import SwiftUI

struct ChangeProfileInfoView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject var editVM =  EditProfileViewModel()
    @ObservedObject var userVM: UserManagerViewModel
    @State private var showImagePicker: Bool = false
    var body: some View {
        VStack(spacing: 0) {
            navigationBar
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 20) {
                    avatarView
                    userInfoInputSection
                }
                .padding(.top, 10)
                .padding(.horizontal, 20)
            }
        }
        .overlay{
            loadingView
        }
        .background(Color.bgWhite)
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
        .onAppear {
            if let user = userVM.currentUser {
                editVM.currentUser = user
            }
        }
        .sheet(isPresented: $showImagePicker, onDismiss: nil) {
            ImagePicker(imageData: $editVM.userAvatar)
        }
        .alert("", isPresented: $editVM.showAlert) {
            Button("OK", role: .cancel, action: {})
        } message: {
            Text(editVM.errorMessage)
        }
    }
}

struct ChangeProfileInfoView_Previews: PreviewProvider {
    static var previews: some View {
        ChangeProfileInfoView(userVM: UserManagerViewModel())
    }
}

extension ChangeProfileInfoView{
    private var navigationBar: some View{
        VStack {
            HStack{
                Button {
                    dismiss()
                } label: {
                    Text("Cancel")
                }
                Spacer()
                Button {
                    editVM.updateUserInfo {
                        dismiss()
                    }
                } label: {
                    Text("Save")
                }
            }
            .padding(.horizontal, 20)
            .font(.urbRegular(size: 16))
           Divider()
        }
    }
    
    private var avatarView: some View{
        ZStack{
            Color.lightGrey
            if let image = editVM.userAvatar?.image{
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }else{
                Image("avatarDefault")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }
        }
        .frame(width: 130, height: 130)
        .clipShape(Circle())
        .overlay(alignment: .bottomTrailing){
            ZStack{
                Circle()
                    .fill(Color.accentBlue)
                    Image(systemName: "plus")
                    .font(.callout)
                    .foregroundColor(.bgWhite)
            }
            .frame(width: 25, height: 25)
            .padding(8)
        }
        .hCenter()
        .onTapGesture {
           showImagePicker.toggle()
        }
    }
    private var userInfoInputSection: some View{
        VStack(alignment: .leading, spacing: 10) {
            TextFieldViewComponent(text: $editVM.currentUser.firstName, promt: "Enter your first name", height: 45, cornerRadius: 10)
            TextFieldViewComponent(text: $editVM.currentUser.lastName, promt: "Enter your last name", height: 45, cornerRadius: 10)
            Text("Your personal details")
            TextFieldViewComponent(text: $editVM.currentUser.bio, promt: "About me", height: 45, cornerRadius: 10)
            Text("User name")
            TextFieldViewComponent(text: $editVM.currentUser.userName, promt: "Enter your user name", height: 45, cornerRadius: 10)
            Text("Phone")
            TextFieldViewComponent(text: $editVM.currentUser.phone, promt: "Enter your phone", height: 45, cornerRadius: 10)
        }
        .font(.urbRegular(size: 16))
        .foregroundColor(.fontPrimary)
    }
    private var loadingView: some View{
        Group{
            if editVM.showLoaderView{
                ZStack{
                    Color.secondaryFontGrey.opacity(0.2).ignoresSafeArea()
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.accentBlue.opacity(0.5))
                        .frame(width: 60, height: 60)
                    ProgressLoader()
                }
                .animation(.easeInOut, value: editVM.showLoaderView)
            }
        }
    }
}
