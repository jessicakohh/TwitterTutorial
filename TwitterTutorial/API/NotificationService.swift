//
//  NotificationService.swift
//  TwitterTutorial
//
//  Created by juyeong koh on 2023/01/31.
//

import Firebase

struct NotificationService {
    static let shared = NotificationService()
    
    func uploadNotification(type: NotificationType, tweet: Tweet? = nil) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        var values: [String: Any] = ["timestamp": Int(NSDate().timeIntervalSince1970),
                                     "uid": uid,
                                     "type": type.rawValue]
        
        // 알림의 타입에 따라 values의 내용도 변경된다.
        // ex) 팔로우 알림이면 좋아요에 관한 알림이 아니기 때문에 어떤 트윗을 좋아했는지에 대한 내용이 없다는 등...
        if let tweet = tweet {
            values["tweetID"] = tweet.tweetID
            REF_NOTIFICATION.child(tweet.user.uid).childByAutoId().updateChildValues(values)
        } else {
            
        }
    }
}
