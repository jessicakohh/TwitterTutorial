//
//  ExploreController.swift
//  TwitterTutorial
//
//  Created by juyeong koh on 2023/01/13.
//

import UIKit

private let reuseIdentifier = "UserCell"

class ExploreController: UITableViewController {
    
    // MARK: - Properties
    
    
    // 1. 검색 텍스트를 기반으로
    private var users = [User]() {
        didSet { tableView.reloadData() }
    }
    
    // 2. 이 배열을 필터링하고 채우는 것
    private var filteredUsers = [User]() {
        didSet { tableView.reloadData() }
    }
    
    private var inSearchMode: Bool {
        // 우리가 검색모드에 있는지 여부를 결정하는데 도움
        return searchController.isActive && !searchController.searchBar.text!.isEmpty
    }
    
    private let searchController =  UISearchController(searchResultsController: nil)
    
    // MARK: - LifeCycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchUser()
        configureSearchController()
    }
    
    // 뒤로가기 버튼 왔다갔다 할때 네비게이션 바 항상 나타나도록
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.isHidden = false
    }
    
    // MARK: - API
    
    func fetchUser() {
        UserService.shared.fetchUsers { users in
            self.users = users
        }
    }

    
    // MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .white
        navigationItem.title = "Explore"
        
        tableView.register(UserCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 60
        tableView.separatorStyle = .none
    }
    
    func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search for a user"
        navigationItem.searchController = searchController
        definesPresentationContext = false
    }
}


// MARK: - UITableViewDelegate / DataSource

extension ExploreController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 검색 컨트롤러가 활성화되고 텍스트 막대가 없거나 텍스트가 비어있지 않은 경우
        return inSearchMode ? filteredUsers.count : users.count
    }
    
    
    // 검색 모드에 있고 테이블 뷰를 채우는 데이터 소스가 사용자 인덱스 경로나 사용자가 아니다.
    // 검색 여부에 따라 올바른 사용자를 확보해야 함
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! UserCell
        let user = inSearchMode ? filteredUsers[indexPath.row] : users[indexPath.row]
        cell.user = user
        return cell
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = inSearchMode ? filteredUsers[indexPath.row] : users[indexPath.row]
        let controller = ProfileController(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }
}


// MARK: - UISearchResultsUpdating



extension ExploreController: UISearchResultsUpdating {
    
    // 무엇인가 입력 혹은 삭제할때마다 호출
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text?.lowercased() else { return }
        
        filteredUsers = users.filter({ $0.username.contains(searchText) })

    }
}
