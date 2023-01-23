//
//  UserService.swift
//  TwitterTutorial
//
//  Created by juyeong koh on 2023/01/18.
//

import Foundation
import Firebase

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
}
