//
//  UserService.swift
//  TwitterTutorial
//
//  Created by juyeong koh on 2023/01/18.
//

import Foundation
import Firebase

typealias DatabaseCompletion = ((Error?, DatabaseReference) -> Void)

struct UserService {
    static let shared = UserService()
    
    // 현재 사용자 정보 가져오기
    func fetchUser(uid: String, completion: @escaping(User) -> Void) {
        
        REF_USERS.child(uid).observeSingleEvent(of: .value) { snapshot in
            guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
            
            let user = User(uid: uid, dictionary: dictionary)
            completion(user)
            
        }
    }
    
    func fetchUsers(completion: @escaping([User]) -> Void) {
        var users = [User]()
        REF_USERS.observe(.childAdded) { snapshot in
            let uid = snapshot.key
            guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
            let user = User(uid: uid, dictionary: dictionary)
            users.append(user)
            completion(users)

            print(snapshot)
        }
    }
    
    func followUser(uid: String, completion: @escaping(Error?, DatabaseReference) -> Void) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        REF_USER_FOLLOWERS.child(currentUid).updateChildValues([uid: 1]) { (err, ref) in
            REF_USER_FOLLOWERS.child(uid).updateChildValues([currentUid: 1], withCompletionBlock: completion)
        }
        
        print("DEBUG : 현재 uid \(currentUid)가 \(uid)를 팔로잉하기 시작")
        print("DEBUG : \(currentUid)가 팔로워로써 \(uid)를 얻다")
    }
    
    func unfollowUser(uid: String, completion: @escaping(DatabaseCompletion)) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        REF_USER_FOLLOWING.child(currentUid).child(uid).removeValue() { (err, ref) in
            REF_USER_FOLLOWERS.child(uid).child(currentUid).removeValue(completionBlock: completion)
        }
    }
    
    func checkIfUsersFollowed(uid: String, completion: @escaping(Bool) -> Void) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        REF_USER_FOLLOWING.child(currentUid).child(uid).observeSingleEvent(of: .value) { snapshot in
            print("DEBUG : User is followed is \(snapshot.exists())")
            completion(snapshot.exists())
        }
    }
    
//    func fetchUserStats() {
//        UserService.shared.fetchUserStates(uid: user.uid) { stats in
//            print("DEBUG : 유저는 \(stats.followers)의 팔로워이다")
//            print("DEBUG : 유저는 \(stats.following)를 팔로우한다")
//        }
//    }
    
    
    // 사용자 팔로워/팔로잉 통계 업데이트
    func fetchUserStates(uid: String, completion: @escaping(UserRelationStats) -> Void) {
        REF_USER_FOLLOWERS.child(uid).observeSingleEvent(of: .value) { snapshot in
            let followers = snapshot.children.allObjects.count
            
            REF_USER_FOLLOWING.child(uid).observeSingleEvent(of: .value) { snapshot in
                let following = snapshot.children.allObjects.count
                
                let stats = UserRelationStats(followers: followers, following: following)
                completion(stats)
            }
            
            print("DEBUG : 팔로워 수 : \(followers)")
        }
    }
}
