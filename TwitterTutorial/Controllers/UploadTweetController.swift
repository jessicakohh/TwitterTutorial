//
//  UploadTweetController.swift
//  TwitterTutorial
//
//  Created by juyeong koh on 2023/01/18.
//

import UIKit

class UploadTweetController: UIViewController {
    // MARK: -  Properties
    
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
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    // MARK: - Selectors
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handelUploadTweet() {
        print("DEBUG : Upload Tweet here / 여기에 트윗을 업로드")
    }
    
    // MARK: - API
    
    // MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .white
        
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.isTranslucent = true
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                           target: self,
                                                           action: #selector(handleCancel))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: actionButton)
        
    }
}
