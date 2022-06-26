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
    let name: String
//    let login: String
//    let description: String?
}
