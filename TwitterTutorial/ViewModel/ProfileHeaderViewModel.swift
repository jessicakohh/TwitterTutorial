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
