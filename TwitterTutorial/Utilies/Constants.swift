//
//  Constants.swift
//  TwitterTutorial
//
//  Created by juyeong koh on 2023/01/17.
//


// 데이터베이스를 추가하고 싶을 때 이 상수 파일로 이동하여 다른 참조를 만들면 됨
import Firebase

let STORAGE_REF = Storage.storage().reference()
let STORAGE_PROFILE_IMAGES = STORAGE_REF.child("profile_images")

// 전역 상수, 앱 내 어디서나 액세스 할 수 있도록 전역으로 만듬
let DB_REF = Database.database().reference()
let REF_USERS = DB_REF.child("users")

