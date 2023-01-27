//
//  UploadTweetController.swift
//  TwitterTutorial
//
//  Created by juyeong koh on 2023/01/18.
//

import UIKit

class UploadTweetController: UIViewController {
    // MARK: -  Properties
    
    private let user: User
    private let config: UploadTweetConfiguration
    private lazy var viewModel = UploadTweetViewModel(config: config)
    
    
    // let으로 하면 실행이 안됨. 실제 버튼 앞의 정의에 대상을 추가하려고 하기 때문에
    // 네비게이션 항목에 추가하면 인스턴스화 되는 것처럼 작동하지 않는다.
    private lazy var actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .twitterBlue
        button.setTitle("Tweet", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(.white, for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 64, height: 32)
        button.layer.cornerRadius = 32 / 2
        button.addTarget(self, action: #selector(handelUploadTweet), for: .touchUpInside)
        return button
    }()
    
    // API를 두 번 가지고 올 필요 없이 FeedController에서 UploadTweetController로 사용자 이미지를 전달
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.setDimensions(width: 48, height: 48)
        iv.layer.cornerRadius = 48 / 2
        iv.backgroundColor = .twitterBlue
        return iv
    }()
    
    private let captionTextView = CaptionTextView()
    
    // MARK: - Lifecycle
    
    // 초기화 외부에서 액세스 해야 하므로 클래스 수준 변수로 만들어야 했다
    init(user: User, config: UploadTweetConfiguration) {
        self.user = user
        self.config = config
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
        switch config {
        case .tweet:
            print("DEBUG : config is tweet")
        case .reply(let tweet):
            print("DEBUG : Replying to \(tweet.caption)")
        }
    }
    // MARK: - Selectors
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handelUploadTweet() {
        guard let caption = captionTextView.text else { return }
        TweetService.shared.uploadTweet(caption: caption) { (error, ref) in
            print("DEBUG : Tweet did upload to Database / 트윗이 데이터베이스에 업로드되었습니다")
            if let error = error {
                print("DEBUG : Failed to upload with error / 업로드 실패 / \(error.localizedDescription)")
                return
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: - API
    
    // MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .white
        configureNavigationBar()
        
        let stack = UIStackView(arrangedSubviews: [profileImageView, captionTextView])
        stack.axis = .horizontal
        stack.spacing = 12
        // 앞으로 나아갈 높이와 프로필 이미지의 캡션 TextView 동일하게 
        stack.alignment = .leading
        
        view.addSubview(stack)
        stack.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                     left: view.leftAnchor,
                     right: view.rightAnchor,
                     paddingTop: 16,
                     paddingLeft: 16,
                     paddingRight: 16)
        profileImageView.sd_setImage(with: user.profileImageUrl, completed: nil)
        profileImageView.contentMode = .scaleAspectFill
    }
    
    func configureNavigationBar() {
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.isTranslucent = true
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                           target: self,
                                                           action: #selector(handleCancel))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: actionButton)
    }
}
