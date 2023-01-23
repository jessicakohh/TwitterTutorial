//
//  ProfileHeaderViewModel.swift
//  TwitterTutorial
//
//  Created by juyeong koh on 2023/01/23.
//

import UIKit

// 이 열거형을 사용하여 컬렉션 뷰 셀을 채울 것
enum ProfileFilterOptions: Int, CaseIterable {
    case tweets
    case replies
    case likes
    
    var description: String {
        switch self {
        case .tweets: return "Tweets"
        case .replies: return "Tweets & Replies"
        case .likes: return "Likes"
        }
    }
}


struct ProfileHeaderViewModel {
    
    private let user: User
    
    let usernameText: String
    
    var followersString: NSAttributedString? {
        return attributedText(withValue: 0, text: " 팔로워")
    }
    
    var followingString: NSAttributedString? {
        return attributedText(withValue: 2, text: " 팔로잉")
        
    }
    
    var actionButtonTitle: String {
        // 사용자가 현재 사용자인 경우 프로필을 편집하도록 설정
        // 아니라면 팔로우 여부 파악
        if user.isCurrentUser {
            return "프로필 수정"
        }
        
        if !user.isFollowed && !user.isCurrentUser {
            return "팔로우"
        }
        
        if user.isFollowed {
            return "팔로잉"
        }
        return "로딩"
    }
    
    init(user: User) {
        self.user = user
        self.usernameText = "@" + user.username
    }
    
    fileprivate func attributedText(withValue value: Int, text: String) -> NSAttributedString {
        let attributedTitle = NSMutableAttributedString(string: "\(value)",
                                                        attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedTitle.append(NSAttributedString(string: "\(text)",
                                                  attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),
                                                               NSAttributedString.Key.foregroundColor: UIColor.lightGray]))
        return attributedTitle
    }
}
