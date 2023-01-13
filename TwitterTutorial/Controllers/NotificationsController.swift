//
//  NotificationController.swift
//  TwitterTutorial
//
//  Created by juyeong koh on 2023/01/13.
//
import UIKit

class NotificationsController: UIViewController {
    
    // MARK: - Properties
    
    // MARK: - LifeCycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .white
        navigationItem.title = "Notifications"
    
    }
}
