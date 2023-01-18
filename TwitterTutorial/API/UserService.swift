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
        
        print("DEBUG: current uid is \(uid)")
        REF_USERS.child(uid).observeSingleEvent(of: .value) { snapshot in
            print("DEBUG : Snapshot is \(snapshot)")
            guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
            print("DEBUG : Dictionary is \(dictionary)")
            
            guard let username = dictionary["username"] as? String else { return }
            print("DEBUG : Username is \(username)")
        }
    }
}
