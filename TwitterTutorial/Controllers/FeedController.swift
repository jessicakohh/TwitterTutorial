//
//  FeedController.swift
//  TwitterTutorial
//
//  Created by juyeong koh on 2023/01/13.
//

import UIKit
import SDWebImage

private let reuseIdentifier = "TweetCell"

class FeedController: UICollectionViewController {
    
    // MARK: - Properties
    
    // 1. 사용자가 설정되면 이것이 실행된다
    // 2. 모델에서 무언기를 변환했는지 확인한다
    var user: User? {
        didSet {
            print("DEBUG: Did set user in feed controller / FeedController에서 사용자를 설정 했습니까")
            configureLeftBarButton()
        }
    }
    
    // 뷰가 로드되자마자는 빈 배열일것임, 따라서 이 데이터 가져오기를 완료하고 결과로 이 트윗 배열을 실제로 저장하는데 시간이 걸림
    private var tweets = [Tweet]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        fetchTweets()
    }
    
    // MARK: - API
    func fetchTweets() {
        TweetService.shared.fetchTweets { tweets in
            // 트윗 수 몇개
            self.tweets = tweets
        }
    }
    
    // MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .white
        
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.backgroundColor = .white
        
        let imageView = UIImageView(image: UIImage(named: "twitter_logo_blue"))
        imageView.contentMode = .scaleAspectFit
        imageView.setDimensions(width: 44, height: 44)
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

// MARK: - UICollectionViewDelegate / DataSource

extension FeedController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("DEBUG: Tweet count at time of collectionView function call is \(tweets.count)")
        return tweets.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TweetCell
        return cell
    }
}


// MARK: - UICollectionViewDelegateFlowLayout

extension FeedController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 120)
    }
}
