//
//  TextConstants.swift
//  LiveChat
//
//  Created by Богдан Зыков on 02.07.2022.
//

import SwiftUI


class TextConstants {
    
    
    static let settingsRowContent: [SettingRow] = [
        SettingRow(image: "bookmark", title: "Saved Messages", color: .accentBlue),
        SettingRow(image: "Contacts", title: "Recent Calls", color: .secondaryGreen),
        SettingRow(image: "devices", title: "Devices", color: .orange),
        SettingRow(image: "fold", title: "Chat Folders", color: .cyan),
        SettingRow(image: "bell", title: "Notifications and Sounds", color: .destructivRed),
        SettingRow(image: "lock", title: "Privacy and security", color: .gray),
        SettingRow(image: "data", title: "Data and Storage", color: .cyan),
        SettingRow(image: "global", title: "Language", color: .teal),
        SettingRow(image: "chat", title: "Ask a Question", color: .orange),
        SettingRow(image: "lamp", title: "Chattie Features", color: .yellow),
        SettingRow(image: "fqa", title: "Chattie FAQ", color: .cyan),
        
    ]
}


struct SettingRow{
    var id: String = UUID().uuidString
    let image: String
    let title: String
    let color: Color
}
