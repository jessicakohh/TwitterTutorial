//
//  ActionSheetViewModel.swift
//  TwitterTutorial
//
//  Created by juyeong koh on 2023/01/29.
//

import Foundation

struct ActionSheetViewModel {
    
    private let user: User
    
    var options: [ActionSheetOptions] {
        var results = [ActionSheetOptions]()
        
        // 우리가 보고 있는 사용자 트윗이 현재 사용자라면, 삭제 옵션 추가
        if user.isCurrentUser {
            results.append(.delete)
        } else {
            let followOption: ActionSheetOptions = user.isFollowed ?? false ? .unfollow(user) : .follow(user)
            results.append(followOption)
        }
        results.append(.report)
        return results
    }
    
    init(user: User) {
        self.user = user
    }
}

// 뷰 모델에서 우리는 액션시트에 어떤 액션이 들어가야 할지를 결정해야 한다.
enum ActionSheetOptions {
    case follow(User)
    case unfollow(User)
    case report
    case delete
    
    var description: String {
        switch self {
        case .follow(let user): return "Follow @\(user.username)"
        case .unfollow(let user): return "Unfollow @\(user.username)"
        case .report: return "Report Tweet"
        case .delete: return "Delete Tweet"
        }
    }
}
