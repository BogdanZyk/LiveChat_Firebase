//
//  ChatUser.swift
//  LiveChat
//
//  Created by Богдан Зыков on 04.06.2022.
//

import Foundation

struct User: Codable{
    let uid: String
    let email: String
    let profileImageUrl: String?
    let userName: String
    let firstName: String
    let lastName: String
    let bio: String
    let userBannerUrl: String
    let phone: String
}
