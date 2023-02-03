//
//  EditProfileViewModel.swift
//  TwitterTutorial
//
//  Created by juyeong koh on 2023/02/03.
//

import Foundation

enum EditProfileOptions: Int, CaseIterable {
case fullname
case username
case bio
    
    var description: String {
        switch self {
        case .username: return "Username"
        case .fullname: return "Name"
        case .bio: return "Bio"
        }
    }
}


