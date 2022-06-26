//
//  TestMessage.swift
//  LiveChat
//
//  Created by Богдан Зыков on 26.06.2022.
//

import Foundation



struct Message2: Codable, Identifiable{
    let id, fromId, toId, imageURL, text: String?
}




//public struct City: Codable {
//
//    let name: String
//    let state: String?
//    let country: String?
//    let isCapital: Bool?
//    let population: Int64?
//
//    enum CodingKeys: String, CodingKey {
//        case name
//        case state
//        case country
//        case isCapital = "capital"
//        case population
//    }
//
//}
