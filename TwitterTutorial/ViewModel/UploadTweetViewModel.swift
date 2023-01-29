//
//  UploadTweetViewModel.swift
//  TwitterTutorial
//
//  Created by juyeong koh on 2023/01/27.
//

import UIKit

// 멘션달기
enum UploadTweetConfiguration {
    case tweet
    case reply(Tweet)
}

struct UploadTweetViewModel {
    let actionButtonTitle: String
    let placeholderText: String
    var shouldShowReplyLabel: Bool
    var replyText: String?
    
    init(config: UploadTweetConfiguration) {
        switch config {
        case .tweet:
            actionButtonTitle = "트윗"
            placeholderText = "무슨일이 일어나고 있나요?"
            shouldShowReplyLabel = false
        case .reply(let tweet):
            actionButtonTitle = "답글"
            placeholderText = "답글 트윗하기"
            replyText = "@\(tweet.user.username)님에게 보내는 답글"
            shouldShowReplyLabel = true
        }
    }
}
