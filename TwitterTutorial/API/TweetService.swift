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
        
        let ref = REF_TWEETS.childByAutoId()
        
        // 고유 식별자를 자동으로 생성, 사용자를 생성하고 고유 식별자를 추가한다음 모든 항목을 업로드
        ref.updateChildValues(values) { (err, ref) in
            // 트윗 업로드 트윗 완료 후 사용자 지정 구조 업데이트
            guard let tweetID = ref.key else { return }
            REF_USER_TWEETS.child(uid).updateChildValues([tweetID: 1], withCompletionBlock: completion)
        }
    }
    
    // 데이터베이스에서 트윗을 가져오기 위한 함수
    // 이 함수에 트윗배열이 있는것을 알 수 있음.
    // 모든 배열에는 개수 속성이 있어 해당 배열에 얼마나 많은 항목이 있는지 알려줌
    func fetchTweets(completion: @escaping([Tweet]) -> Void) {
        var tweets = [Tweet]()
        
        REF_TWEETS.observe(.childAdded) { snapshot  in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            guard let uid = dictionary["uid"] as? String else { return }
            let tweetID = snapshot.key
            
            UserService.shared.fetchUser(uid: uid) { user in
                let tweet = Tweet(user: user, tweetID: tweetID, dictionary: dictionary)
                tweets.append(tweet)
                completion(tweets)
            }
        }
    }
    
    func fetchTweets(forUser user: User, completion: @escaping([Tweet]) -> Void) {
        var tweets = [Tweet]()
        
        REF_USER_TWEETS.child(user.uid).observe(.childAdded) { snapshot in
            let tweetID = snapshot.key
            
            REF_TWEETS.child(tweetID).observeSingleEvent(of: .value) { snapshot in
                guard let dictionary = snapshot.value as? [String: Any] else { return }
                guard let uid = dictionary["uid"] as? String else { return }
                UserService.shared.fetchUser(uid: uid) { user in
                    let tweet = Tweet(user: user, tweetID: tweetID, dictionary: dictionary)
                    tweets.append(tweet)
                    completion(tweets)
                }
            }
        }
    }
}
