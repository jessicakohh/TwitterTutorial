//
//  TweetService.swift
//  TwitterTutorial
//
//  Created by juyeong koh on 2023/01/18.
//

import Firebase

struct TweetService {
    static let shared = TweetService()
    
    func uploadTweet(caption: String, completion: @escaping(Error?, DatabaseReference) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        // 본질적으로 우리가 데이터 베이스에 업로드할 내용, Firebase에서 직접 볼 수 있음
        let values = ["uid": uid,
                      "timestamp": Int(NSDate().timeIntervalSince1970),
                      "likes": 0,
                      "retweets": 0,
                      "caption": caption] as [String: AnyObject]
        
        // 고유 식별자를 자동으로 생성, 사용자를 생성하고 고유 식별자를 추가한다음 모든 항목을 업로드
        REF_TWEETS.childByAutoId().updateChildValues(values, withCompletionBlock: completion)
        
    }
}
