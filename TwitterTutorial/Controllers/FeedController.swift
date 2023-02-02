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
        didSet { collectionView.reloadData() }
    }
    
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        fetchTweets()
    }
    
    // 뒤로가기 버튼 왔다갔다 할때 네비게이션 바 항상 나타나도록
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.isHidden = false
    }
    
    // MARK: - API
    func fetchTweets() {
        TweetService.shared.fetchTweets { tweets in
            // 트윗 수 몇개
            self.tweets = tweets
            // 1. 사용자가 트윗 가져오기 기능의 완료 블록에서 트윗을 좋아하는 경우, 우리의 트윗이 이미 패치되었음을 알 수 있음
            // 2. 사용자가 해당 트윗을 좋아하는지 확인
            self.checkIfUserLikeTweets(self.tweets)
        }
    }
    
    // 좋아요 버튼이 계속 눌리는 것을 유지
    func checkIfUserLikeTweets(_ tweets: [Tweet]) {
        // 3. tweets.enumerated() 일 대 각 반복의 인덱스에 액세스 할 수 있음
        for (index, tweet) in tweets.enumerated() {
            // 5. checkIfUser~ API call을 통하여
            // 사용자가 트윗을 좋아하는지 확인하여 실제로 해당 트윗을 좋아했음을 알 수 있음
            TweetService.shared.checkIfUserLikedTweet(tweet) { didLike in
                guard didLike == true else { return }
                // 4. 데이터소스에서 속성을 업데이트하는데 사용하고 있음 (인덱스: 몇 번째 트윗인가)
                // 6. 모든 조건이 충족되면 self 라고 말할 것, 그 트윗은 좋아요가 눌린 index를 보게 됨
                self.tweets[index].didLike = true
            }
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
        
        // 셀에서 생성한 트윗 속성에 액세스하고 있으며 이를 다음의 요소로 설정하고 있다.
        // 트윗 데이터소스 : 0 인덱스에 하나, 인덱스에 하나, ~ ~ 이렇게 요소가 들어감
        // indexPath.row 경로를 사용하여 트윗 데이터 소스 배열에서 원하는 요소에 엑세스
        print("DEBUG: Index path is \(indexPath.row) / 인덱스 경로")
        
        // ⭐️ 이 피드 컨트롤러가 해당 프로토콜을 준수하기 때문에 위임이 self와 같다고 판단
        cell.delegate = self
        cell.tweet = tweets[indexPath.row]
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = TweetController(tweet: tweets[indexPath.row])
        navigationController?.pushViewController(controller, animated: true)
    }
}


// MARK: - UICollectionViewDelegateFlowLayout

extension FeedController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let viewModel = TweetViewModel(tweet: tweets[indexPath.row])
        let height = viewModel.size(forWidth: view.frame.width).height
        
        // 기본적으로 트윗 레이블의 높이를 얻은 다음 72 픽셀 추가
        return CGSize(width: view.frame.width, height: height + 72)
    }
}


// MARK: - TweetCellDelegate

extension FeedController: TweetCellDelegate {
    func handleLikeTapped(_ cell: TweetCell) {
        guard let tweet = cell.tweet else { return }
        
        TweetService.shared.likeTweet(tweet: tweet) { (err, ref) in
            cell.tweet?.didLike.toggle()
            // 셀의 객체를 실제로 업데이트해야 좋아요가 업데이트
            let likes = tweet.didLike ? tweet.likes - 1 : tweet.likes + 1
            cell.tweet?.likes = likes
            
            // 좋아요를 누를 때만 알림을 업로드
            guard !tweet.didLike else { return }
            NotificationService.shared.uploadNotification(type: .like, tweet: tweet)
        }
    }
    
    func handleReplyTapped(_ cell: TweetCell) {
        // 셀에 있는 트윗에 엑세스할 사용자를 어떻게 알 수 있는가 ?
        guard let tweet = cell.tweet else { return }
        let controller = UploadTweetController(user: tweet.user, config: .reply(tweet))
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    func handleProfileImageTapped(_ cell: TweetCell) {
        print("DEBUG : Handle profile image tapped in controller / 컨트롤러에서 탭된 프로필 이미지")
        guard let user = cell.tweet?.user else { return }
        let controller = ProfileController(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }
}
