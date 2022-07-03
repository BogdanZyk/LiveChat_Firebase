//
//  ChatUser.swift
//  LiveChat
//
//  Created by Богдан Зыков on 04.06.2022.
//

import Foundation

struct User: Codable{
    let uid: String
    var email: String
    var profileImageUrl: String?
    var userName: String
    var firstName: String
    var lastName: String
    var bio: String
    var userBannerUrl: String
    var phone: String
}
