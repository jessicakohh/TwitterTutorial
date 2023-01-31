//
//  Notification.swift
//  TwitterTutorial
//
//  Created by juyeong koh on 2023/01/31.
//

import Foundation

enum NotificationType: Int {
    case follow
    case like
    case reply
    case retweet
    case mention
}

struct Notification {
    let tweetID: String
    var timestamp: Date!
    let user: User
    var tweet: Tweet?
    var type: NotificationType!
    
    // 1. uid가 필요하지 않은 이유는 이 알림이 초기화 할 것이기 때문
    // 2. tweet: 옵셔널인이유는 알림에 항상 트윗이 연결되어있지 않기 때문 (예: 팔로우를 한 경우)
    init(user: User, tweet: Tweet?, dictionary: [String: AnyObject]) {
        self.user = user
        self.tweet = tweet
        self.tweetID = dictionary["tiweetID"] as? String ?? ""
        
        if let timestamp = dictionary["timeStamp"] as? Double {
            self.timestamp = Date(timeIntervalSince1970: timestamp)
        }
        
        if let type = dictionary["type"] as? Int {
            self.type = NotificationType(rawValue: type)
        }
    }
}

// 데이터베이스에 알림을 업로드하려는 위치와 시기에 대한 정보

