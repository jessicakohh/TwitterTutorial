//
//  MainTabController.swift
//  TwitterTutorial
//
//  Created by juyeong koh on 2023/01/13.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth

class MainTabController: UITabBarController {
    
    // MARK: - Properties
    
    var user: User? {
        // 속성이 가져오면 무언가를 할 수 있게 해주는 관찰자
        didSet {
            print("DEBUG : Did set user in main tab / 기본탭에서 사용자 설정")
            guard let nav = viewControllers?[0] as? UINavigationController else { return }
            guard let feed = nav.viewControllers.first as? FeedController else { return }
            
            feed.user = user
        }
    }
    
    
    let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.backgroundColor = .twitterBlue
        button.setImage(UIImage(named: "new_tweet"), for: .normal)
        button.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        return button
    }()
    

    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        logUserOut()
        view.backgroundColor = .twitterBlue
        authenticateUserAndConfigureUI()
    }
    
    
    // MARK: - API
    
    // Firebase에서 사용자 데이터 가져오기
    // 이 기능을 호출 할 때 실제로 가지고 있는 사용자에 엑세스할 수 있어야 함
    // 가져온 다음 계속해서 해당 사용자를 FeedController로 전달해야 함
    func fetchUser() {
        UserService.shared.fetchUser { user in
            print("DEBUG : Main tab user is \(user.username)")
            self.user = user
        }
    }
    
    // 사용자가 로그인했는지 확인
    func authenticateUserAndConfigureUI() {
        if Auth.auth().currentUser == nil {
            // 동기화를 만든 메인 스레드에서 수행되어야 함
            DispatchQueue.main.async {
                let nav = UINavigationController(rootViewController: LoginController())
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: nil)
            }
            print("DEBUG: User is not logged in / 사용자가 로그인하지 않았습니다")
        } else {
            configureViewControllers()
            configureUI()
            fetchUser()
            print("DEBUG: User is logged in / 사용자 로그인")
        }
    }
    
    func logUserOut() {
        do {
            try Auth.auth().signOut()
            print("DEBUG: Did log user out / 사용자 로그아웃")
        } catch let error {
            print("DEBUG: Failed to sign out with error \(error.localizedDescription)")
        }
    }

    // MARK: - Selectors
    
    @objc func actionButtonTapped() {
        let nav = UINavigationController(rootViewController: UploadTweetController())
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }

    
    // MARK: - Helpers
    
    func configureUI() {
        view.addSubview(actionButton)
        actionButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor,
                            right: view.rightAnchor,
                            paddingBottom: 64,
                            paddingRight: 16,
                            width: 56,
                            height: 56)
        actionButton.layer.cornerRadius = 56 / 2
        
    }
    
    func configureViewControllers() {
        
        let feed = FeedController()
        let nav1 = templateNavigationController(image: UIImage(named: "home_unselected"), rootViewController: feed)
        
        let explore = ExploreController()
        let nav2 = templateNavigationController(image: UIImage(named: "search_unselected"), rootViewController: explore)
        
        let notifications = NotificationsController()
        let nav3 = templateNavigationController(image: UIImage(named: "like_unselected"), rootViewController: notifications)

        let conversations = ConversationController()
        let nav4 = templateNavigationController(image: UIImage(named: "ic_mail_outline_white_2x-1"), rootViewController: conversations)
        
        viewControllers = [nav1, nav2, nav3, nav4]
    }
    
    // 재사용 가능한 도우미 함수를 만들어 네비게이션 컨트롤러를 만들고 두 가지를 전달
    func templateNavigationController(image: UIImage?, rootViewController: UIViewController) -> UINavigationController {
        
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = image
        nav.navigationBar.barTintColor = .white
        return nav
    }
}
