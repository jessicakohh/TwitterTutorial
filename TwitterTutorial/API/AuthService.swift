//
//  AuthService.swift
//  TwitterTutorial
//
//  Created by juyeong koh on 2023/01/17.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth

struct AuthCredentials {
    let email: String
    let password: String
    let fullname: String
    let username: String
    let profileImage: UIImage
}

// 본질적으로 이 인증 서비스를 생성하거나, 두 로그 모두에서 이 인증 서비스를 사용해야 한다
// 모든 서비스중지를 shared라고 부를 때 마다 이 특정 인스턴스를 사용할 것 
struct AuthService {
    static let shared = AuthService()
    
    func logUserIn(withEmail email: String, password: String, completion: @escaping(AuthDataResult?, Error?) -> Void) {
        print("DEBUG: Email: \(email), password: \(password)")
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
    
    func registerUser(credentials: AuthCredentials,
                      completion: @escaping(Error?, DatabaseReference) -> Void) {
        
        let email = credentials.email
        let password = credentials.password
        let username = credentials.username
        let fullname = credentials.fullname

        
        guard let imageData = credentials.profileImage.jpegData(compressionQuality: 0.3) else { return }
        let filename = NSUUID().uuidString
        let storageRef = STORAGE_PROFILE_IMAGES.child(filename)
        
        storageRef.putData(imageData, metadata: nil) { (meta, error) in
            storageRef.downloadURL { (url, error) in
                guard let profileImageUrl = url?.absoluteString else { return }
                
                Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                    if let error = error {
                        print("DEBUG: Error is \(error.localizedDescription)")
                        return
                    }
                    
                    guard let uid = result?.user.uid else { return }
                    
                    let values = ["email": email,
                                  "username": username,
                                  "fullname": fullname,
                                  "profileImageUrl": profileImageUrl]
                    
                    REF_USERS.child(uid).updateChildValues(values, withCompletionBlock: completion)
                    
                    //            let ref = Database.database().reference().child("users").child(uid)
                    //            let ref = DB_REF.child("users").child(uid)
                    REF_USERS.child(uid).updateChildValues(values) { (error, ref) in
                        print("DEBUG: Successfully updated user information / 사용자 정보를 업데이트했습니다")
                    }
                }
            }
        }
    }
}
