//
//  ActionSheetLauncher.swift
//  TwitterTutorial
//
//  Created by juyeong koh on 2023/01/29.
//

import UIKit

private let reuseIdentifier = "ActionSheetCell"

protocol ActionSheetLauncherDelegate: class {
    func didSelect(option: ActionSheetOptions)
}

class ActionSheetLauncher: NSObject {
    
    // MARK: - Properties
    
    private let user: User
    private let tableView = UITableView()
    // 본질적으로 이 UI창은 기본적으로 앱이 포함된 창을 나타낸다.
    private var window: UIWindow?
    private lazy var viewModel = ActionSheetViewModel(user: user)
    weak var delegate: ActionSheetLauncherDelegate?
    private var tableViewHeight: CGFloat?
    
    private lazy var blackView: UIView = {
        let view = UIView()
        view.alpha = 0
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleDismissal))
        view.addGestureRecognizer(tap)
        
        return view
    }()
    
    private lazy var footerView: UIView = {
        let view = UIView()
        
        view.addSubview(cancelButton)
        cancelButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        cancelButton.anchor(left: view.leftAnchor, right: view.rightAnchor,
                            paddingLeft: 12, paddingRight: 12)
        cancelButton.centerY(inView: view)
        cancelButton.layer.cornerRadius = 50 / 2
        
        return view
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Cancel", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .systemGroupedBackground
        button.addTarget(self, action: #selector(handleDismissal), for: .touchUpInside)
        return button
    }()
    

    // MARK: - Life Cycle
    
    init(user: User) {
        self.user = user
        super.init()
        
        configureTableView()
    }
    
    // MARK: - Selectors
    
    @objc func handleDismissal() {
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 0
            self.tableView.frame.origin.y += 300
        }
    }

    
    // MARK: -  Helpers
    
    func showTableView(_ shouldShow: Bool) {
        guard let window = window else { return }
        guard let height = tableViewHeight else { return }
        let y = shouldShow ? window.frame.height - height : window.frame.height
        tableView.frame.origin.y = y
    }
    
    
    func show() {
        print("DEBUG : Show Action sheet for user \(user.username)")
        
        guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }
        self.window = window
        
        window.addSubview(blackView)
        blackView.frame = window.frame
        
        window.addSubview(tableView)
        // 왜 3 * 60을 했는지 ?
        // : 우리는 테이블의 새 높이가 우리가 가진 옵션의 양과 같기를 원하기 때문
        // 숫자를 기준으로 높이가 높은 테이블로 테이블뷰를 올바르게 구성 가능
        let height = CGFloat(viewModel.options.count * 60) + 100
        self.tableViewHeight = height
        tableView.frame = CGRect(x: 0, y: window.frame.height,
                                 width: window.frame.width, height: height)
        
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 1
            self.showTableView(true)
        }
    }
    
    func configureTableView() {
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = 60
        tableView.separatorStyle = .none
        tableView.layer.cornerRadius = 5
        tableView.isScrollEnabled = false
        
        tableView.register(ActionSheetCell.self, forCellReuseIdentifier: reuseIdentifier)
    }
}

// MARK: - UITableViewDataSource

extension ActionSheetLauncher: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ActionSheetCell
        cell.option = viewModel.options[indexPath.row]
        return cell
    }
}

// MARK: - UITableViewDelegate

extension ActionSheetLauncher: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let option = viewModel.options[indexPath.row]
        // 여기에 코드를 추가하여 사람들을 팔로우 및 언팔하거나 트윗을 삭제할 수 있음
        
        // 액션시트 애니메이션 적용
        UIView.animate(withDuration: 0.5, animations: {
            self.blackView.alpha = 0
            self.showTableView(false)
        }) { _ in
            self.delegate?.didSelect(option: option)
        }
    }
}
