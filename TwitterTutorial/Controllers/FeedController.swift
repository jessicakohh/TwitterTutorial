//
//  FeedController.swift
//  TwitterTutorial
//
//  Created by juyeong koh on 2023/01/13.
//

import UIKit

class FeedController: UIViewController {
    
    // MARK: - Properties

    var user: User? {
        didSet {
            print("DEBUG: Did set user in feed controller / FeedController에서 사용자를 설정 했습니까")}
    }

    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()

    }
    
    // MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .white
        
        let imageView = UIImageView(image: UIImage(named: "twitter_logo_blue"))
        imageView.contentMode = .scaleAspectFit
        navigationItem.titleView = imageView
        
        let profileImageView = UIImageView()
        // 사용자 프로필 이미지를 로드하기 위해 실제로 발생해야 하는 일
        profileImageView.backgroundColor = .twitterBlue
        profileImageView.setDimensions(width: 32, height: 32)
        profileImageView.layer.cornerRadius = 32 / 2
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: profileImageView)
    }
}
