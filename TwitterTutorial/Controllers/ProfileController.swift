//
//  ProfileController.swift
//  TwitterTutorial
//
//  Created by juyeong koh on 2023/01/21.
//

import UIKit

private let reuseIdentifier = "TweetCell"
private let headerIdentifier = "ProfileHeader"

class ProfileController: UICollectionViewController {
    
    // MARK: - Properties
    private var user: User
    
    private var selectedFilter: ProfileFilterOptions = .tweets {
        didSet { collectionView.reloadData() }
    }
    
    private var tweets = [Tweet]()
    private var likeTweets = [Tweet]()
    private var replies = [Tweet]()
    
    // 1) 선택한 필터에 따라서 수정된 후 2)우리에게 올바른 데이터소스를 반환하여 궁극적으로 프로필 컨트롤러 내부에 표시
    private var currentDataSource: [Tweet] {
        switch selectedFilter {
        case .tweets:
            return tweets
        case .replies:
            return replies
        case .likes:
            return likeTweets
        }
    }
    
    // MARK: - LifeCycle
    
    init(user: User) {
        self.user = user
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        fetchTweets()
        fetchLikeTweets()
        fetchReplies()
        checkIfUserIsFollowed()
        fetchUserStats()
        
        print("DEBUG : User is \(user.username)")
    }
    
    // 이 뷰가 나타나려고 할 때마다 네비게이션 바의 hidden 속성을 true로 설정
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isHidden = true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - API
    func fetchTweets() {
        TweetService.shared.fetchTweets(forUser: user) { tweets in
            self.tweets = tweets
            self.collectionView.reloadData()
        }
    }
    
    func fetchLikeTweets() {
        TweetService.shared.fetchLikes(forUser: user) { tweets in
            self.likeTweets = tweets
        }
    }
    
    func fetchReplies() {
        TweetService.shared.fetchReplies(forUser: user) { tweets in
            self.replies = tweets
            
            self.replies.forEach { reply in
                print("DEBUG : Replying to \(reply.replyingTo)")
            }
        }
    }
    
    func checkIfUserIsFollowed() {
        UserService.shared.checkIfUsersFollowed(uid: user.uid) { isFollowed in
            self.user.isFollowed = isFollowed
            self.collectionView.reloadData()
        }
    }
    
    func fetchUserStats() {
        UserService.shared.fetchUserStates(uid: user.uid) { stats in
            self.user.stats = stats
            self.collectionView.reloadData()
            print("DEBUG : 유저는 \(stats.followers)의 팔로워이다")
            print("DEBUG : 유저는 \(stats.following)를 팔로우한")
        }
    }

    
    // MARK: - Helpers
    
    func configureCollectionView() {
        collectionView.backgroundColor = .white
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        // 상태표시줄 위를 덮게하기
        collectionView.register(ProfileHeader.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: headerIdentifier)
        
        guard let tabHeight = tabBarController?.tabBar.frame.height else { return }
        collectionView.contentInset.bottom = tabHeight
    }
}

// MARK: - UICollectionViewDataSource

extension ProfileController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.currentDataSource.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                      for: indexPath) as! TweetCell
        cell.tweet = currentDataSource[indexPath.row]
        return cell
    }
}


// MARK: - UICollectionViewDelegate

extension ProfileController {
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                     withReuseIdentifier: headerIdentifier,
                                                                     for: indexPath) as! ProfileHeader
        header.user = user
        header.delegate = self
        return header
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ProfileController: UICollectionViewDelegateFlowLayout {
    
    // 헤더
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 350)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 120)
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let viewModel = TweetViewModel(tweet: currentDataSource[indexPath.row])
            let height = viewModel.size(forWidth: view.frame.width).height
            
            // 기본적으로 트윗 레이블의 높이를 얻은 다음 72 픽셀 추가
            return CGSize(width: view.frame.width, height: height + 72)
        }
    }
}

// MARK: - ProfileHeaderDelegate

extension ProfileController: ProfileHeaderDelegate {
    func didSelect(filter: ProfileFilterOptions) {
        print("DEBUG : Did select filter \(filter.description) in profile controller")
        self.selectedFilter = filter
    }
    
    
    func handleDismissal() {
        print("DEBUG : 프로파일 컨트롤러에서 프로파일 해제 처리")
        navigationController?.popViewController(animated: true)
    }
    
    
    func handleEditProfileFollow(_ header: ProfileHeader) {
        print("DEBUG : 유저가 버튼을 누르기 전까지 \(user.isFollowed)를 팔로우 ")
        
        if user.isCurrentUser {
            print("DEBUG : Show edit profile controller")
            return
        }
        // 사용자를 언제 팔로우하고 언팔할지 알아야 함
        if user.isFollowed {
            UserService.shared.unfollowUser(uid: user.uid) { err, ref in
                self.user.isFollowed = false
                
                //                    header.editProfileFollowButton.setTitle("팔로우", for: .normal)
                self.user.stats?.followers -= 1
                self.collectionView.reloadData()
                print("DEBUG : 백엔드에서 언팔로우 완료")
            }
        } else {
            UserService.shared.followUser(uid: user.uid) { ref, err in
                self.user.isFollowed = true
                
                //                    header.editProfileFollowButton.setTitle("팔로잉", for: .normal)
                self.user.stats?.followers += 1
                self.collectionView.reloadData()
                
                NotificationService.shared.uploadNotification(type: .follow, user: self.user)
                print("DEBUG : 백엔드에서 팔로우 완료")
            }
        }
    }
}
