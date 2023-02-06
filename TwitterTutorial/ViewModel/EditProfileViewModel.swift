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

struct EditProfileViewModel {
    
    private let user: User
    let option: EditProfileOptions
    
    var titleText: String {
        return option.description
    }
    
    var optionValue: String? {
        switch option {
        case .username: return user.username
        case .fullname: return user.fullname
        case .bio: return user.bio
        }
    }
    
    // 기본적으로 옵션이 바이오와 같으면 텍스트 필드를 숨김
    var shouldHideTextField: Bool {
        return option == .bio
    }
    
    var shouldHidTextView: Bool {
        return option != .bio
    }
    
    var shouldHidePlaceholderLabel: Bool {
        return user.bio != nil
    }
    
    init(user: User, option: EditProfileOptions) {
        self.user = user
        self.option = option
    }
}
