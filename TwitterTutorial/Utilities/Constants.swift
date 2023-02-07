//
//  Constants.swift
//  TwitterTutorial
//
//  Created by juyeong koh on 2023/01/17.
//


// 데이터베이스를 추가하고 싶을 때 이 상수 파일로 이동하여 다른 참조를 만들면 됨
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth

let STORAGE_REF = Storage.storage().reference()
let STORAGE_PROFILE_IMAGES = STORAGE_REF.child("profile_images")

// 전역 상수, 앱 내 어디서나 액세스 할 수 있도록 전역으로 만듬
let DB_REF = Database.database().reference()
let REF_USERS = DB_REF.child("users")
let REF_TWEETS = DB_REF.child("tweets")
let REF_USER_TWEETS = DB_REF.child("user-tweets")
let REF_USER_FOLLOWERS = DB_REF.child("user-followers")
let REF_USER_FOLLOWING = DB_REF.child("user-following")
let REF_TWEET_REPLIES = DB_REF.child("tweet-replies")
let REF_USER_LIKES = DB_REF.child("user-likes")
let REF_TWEET_LIKES = DB_REF.child("tweet-likes")
let REF_NOTIFICATIONS = DB_REF.child("notifications")
let REF_USER_REPLIES = DB_REF.child("user-replies")
let REF_USER_USERNAMES = DB_REF.child("user-username")
