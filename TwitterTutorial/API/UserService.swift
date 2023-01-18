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
    func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        REF_USERS.child(uid).observeSingleEvent(of: .value) { snapshot in
            guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
            
            let user = User(uid: uid, dictionary: dictionary)
            print("DEBUG : Username is \(user.username)")
            print("DEBUG : Fullname is \(user.fullname)")
            
        }
    }
}
