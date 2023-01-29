//
//  ActionSheetLauncher.swift
//  TwitterTutorial
//
//  Created by juyeong koh on 2023/01/29.
//

import Foundation

class ActionSheetLauncher: NSObject {
    
    // MARK: - Properties

    private let user: User
    
    init(user: User) {
        self.user = user
        super.init()
    }
    
    // MARK: -  Helpers
    
    func show() {
        print("DEBUG : Show Action sheet for user \(user.username)")
    }

}
