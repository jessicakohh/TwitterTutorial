//
//  FeedController.swift
//  TwitterTutorial
//
//  Created by juyeong koh on 2023/01/13.
//

import UIKit
import SDWebImage

class FeedController: UIViewController {
    
    // MARK: - Properties

    // 1. 사용자가 설정되면 이것이 실행된다
    // 2. 모델에서 무언기를 변환했는지 확인한다
    // 3. 
    var user: User? {
        didSet {
            print("DEBUG: Did set user in feed controller / FeedController에서 사용자를 설정 했습니까")
            configureLeftBarButton()
        }
    }

    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureLeftBarButton()

    }
    
    // MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .white
        
        let imageView = UIImageView(image: UIImage(named: "twitter_logo_blue"))
        imageView.contentMode = .scaleAspectFit
        navigationItem.titleView = imageView
    }
    
    func configureLeftBarButton() {
        guard let user = user else { return }
        let profileImageView = UIImageView()
        // 사용자 프로필 이미지를 로드하기 위해 실제로 발생해야 하는 일
        // 프로필 이미지를 설정하기 전에 사용자가 설정되었는지 확인해야 한다
        profileImageView.backgroundColor = .twitterBlue
        profileImageView.setDimensions(width: 32, height: 32)
        profileImageView.layer.cornerRadius = 32 / 2
        profileImageView.layer.masksToBounds = true
        
        // 사용자 프로필 로드
        profileImageView.sd_setImage(with: user.profileImageUrl, completed: nil)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: profileImageView)
    }
}

