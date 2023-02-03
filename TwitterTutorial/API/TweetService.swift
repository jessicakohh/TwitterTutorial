//
//  TweetService.swift
//  TwitterTutorial
//
//  Created by juyeong koh on 2023/01/18.
//

import Firebase

struct TweetService {
    static let shared = TweetService()
    
    // completion: @escaping(DatabaseCompletion)
    func uploadTweet(caption: String, type: UploadTweetConfiguration, completion: @escaping(Error?, DatabaseReference) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        // 본질적으로 우리가 데이터 베이스에 업로드할 내용, Firebase에서 직접 볼 수 있음
        var values = ["uid": uid,
                      "timestamp": Int(NSDate().timeIntervalSince1970),
                      "likes": 0,
                      "retweets": 0,
                      "caption": caption] as [String: Any]
        
        switch type {
        case .tweet:
            REF_TWEETS.childByAutoId().updateChildValues(values) { (err, ref) in
                // 트윗 업로드 트윗 완료 후 사용자 지정 구조 업데이트
                guard let tweetID = ref.key else { return }
                REF_USER_TWEETS.child(uid).updateChildValues([tweetID: 1], withCompletionBlock: completion)
            }
            
        case .reply(let tweet):
            values["replyingTo"] = tweet.user.username
            REF_TWEET_REPLIES.child(tweet.tweetID).childByAutoId()
                .updateChildValues(values) { (err, ref) in
                    guard let replyKey = ref.key else { return }
                    REF_USER_REPLIES.child(uid).updateChildValues([tweet.tweetID: replyKey], withCompletionBlock: completion)
                }
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
            
            self.fetchTweet(withTweetID: tweetID) { tweet in
                tweets.append(tweet)
                completion(tweets)
            }
        }
    }
    
    
    func fetchTweet(withTweetID tweetID: String, completion: @escaping(Tweet) -> Void) {
        REF_TWEETS.child(tweetID).observeSingleEvent(of: .value) { snapshot in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            guard let uid = dictionary["uid"] as? String else { return }
            
            UserService.shared.fetchUser(uid: uid) { user in
                let tweet = Tweet(user: user, tweetID: tweetID, dictionary: dictionary)
                completion(tweet)
            }
        }
    }
    
    func fetchReplies(forUser user: User, completion: @escaping([Tweet]) -> Void) {
        var replies = [Tweet]()
        
        REF_USER_REPLIES.child(user.uid).observe(.childAdded) { snapshot in
            let tweetKey = snapshot.key
            guard let replyKey = snapshot.value as? String else { return }
            
            REF_TWEET_REPLIES.child(tweetKey).child(replyKey).observeSingleEvent(of: .value) { snaphot in
                guard let dictionary = snapshot.value as? [String: Any] else { return }
                guard let uid = dictionary["uid"] as? String else { return }
                let replyID = snapshot.key
                
                UserService.shared.fetchUser(uid: uid) { user in
                    let reply = Tweet(user: user, tweetID: replyID, dictionary: dictionary)
                    replies.append(reply)
                    completion(replies)
                }
            }
        }
    }
    
    func fetchReplies(forTweet tweet: Tweet, completion: @escaping(([Tweet]) -> Void)) {
        var tweets = [Tweet]()
        
        REF_TWEET_REPLIES.child(tweet.tweetID).observe(.childAdded) { snapshot in
            guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
            guard let uid = dictionary["uid"] as? String else { return }
            let tweetID = snapshot.key
            
            UserService.shared.fetchUser(uid: uid) { user in
                let tweet = Tweet(user: user, tweetID: tweetID, dictionary: dictionary)
                tweets.append(tweet)
                completion(tweets)
            }
        }
    }
    
    func fetchLikes(forUser user: User, completion: @escaping([Tweet]) -> Void) {
        var tweets = [Tweet]()
        
        REF_USER_LIKES.child(user.uid).observe(.childAdded) { snapshot in
            let tweetID = snapshot.key
            self.fetchTweet(withTweetID: tweetID) { likedTweet in
                var tweet = likedTweet
                tweet.didLike = true
                
                tweets.append(tweet)
                completion(tweets)
            }
        }
    }
    
    func likeTweet(tweet: Tweet, completion: @escaping(DatabaseCompletion)) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        // 데이터베이스를 업데이트 할 항목의 정수값
        let likes = tweet.didLike ? tweet.likes - 1 :tweet.likes + 1
        REF_TWEETS.child(tweet.tweetID).child("likes").setValue(likes)
        
        if tweet.didLike {
            // 파이어베이스에서 좋아요 삭제 (unlike)
            REF_USER_LIKES.child(uid).child(tweet.tweetID).removeValue { (err, ref) in
                REF_USER_LIKES.child(tweet.tweetID).updateChildValues([uid: 1], withCompletionBlock: completion)
                REF_TWEET_LIKES.child(tweet.tweetID).removeValue(completionBlock: completion)
            }
        } else {
            // 파이어베이스에 좋아요 추가 (like)
            REF_USER_LIKES.child(uid).updateChildValues([tweet.tweetID: 1]) { (err, ref) in
                REF_TWEET_LIKES.child(tweet.tweetID).updateChildValues([uid: 1], withCompletionBlock: completion)
            }
        }
    }
    
    
    // 사용자로 들어가서 찾아봄, 트윗ID를 찾으면 true로 완료, 그렇지 않으면 false
    func checkIfUserLikedTweet(_ tweet: Tweet, completion: @escaping(Bool) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        REF_USER_LIKES.child(uid).child(tweet.tweetID).observeSingleEvent(of: .value) { snapshot in
            completion(snapshot.exists())
        }
    }
}

// 우리는 모든 것을 업데이트 하기 전에 사용자가 트윗을 좋아하는지 확인하고 싶지 않다.
// 기본적으로 우리는 사용자가 전 트윗을 좋아하는지 확인하고, 확인해야 하도록 만드는 것을 피하고 싶다.
// 그런 다음 사용자가 트윗을 좋아하는지 확인한다. 그렇게 하면 우리가 확인할 필요가 없기 때문 (뭔말이야)
// 따라서 기본적으로 먼저 트윗을 가져온 다음, 모든 트윗을 가져온 후에 가져온 트윗을 확인하고 볼 것이다.
// 사용자가 이러한 트윗 중 하나라도 좋아요를 누른다면, 사용자 인터페이스도 업데이트 할 것이다. 
