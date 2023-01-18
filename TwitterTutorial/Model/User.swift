//
//  User.swift
//  TwitterTutorial
//
//  Created by juyeong koh on 2023/01/18.
//

import Foundation
import Firebase

// 데이터베이스에서 볼 수 있는 모든 속성 제공
struct User {
    let fullname: String
    let email: String
    let username: String
    let profileImageUrl: String
    let uid: String
    
    // 자신의 초기화를 작성하교 유형이 될 이 딕셔너리를 전달
    init(uid: String, dictionary: [String: AnyObject]) {
        self.uid = uid
        
        // 전체 이름 키를 찾을 수 없는 경우, ""
        // 우리가 가지고 있는 정보와 일치하도록 코드에서 사용자 지정 개체를 구성하는 방법
        self.fullname = dictionary["fullname"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
    }
}
