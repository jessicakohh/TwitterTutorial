//
//  EditProfileController.swift
//  TwitterTutorial
//
//  Created by juyeong koh on 2023/02/03.
//

import UIKit

private let reuseIdentifier = "EditProfileCell"

protocol EditProfileControllerDelegate: class {
    func controller(_ controller: EditProfileController, wantsToUpdate user: User)
}

class EditProfileController: UITableViewController {
    
    // MARK: - properties
    private var user: User
    private lazy var headerView = EditProfileHeader(user: user)
    private let footerView = EditProfileFooter()
    private let imagePicker = UIImagePickerController()
    
    // 사용자가 무엇을 변경했는지 여부에 따라 버튼을 실제로 활성화
    private var userInfoChanged = false
    
    weak var delegate: EditProfileControllerDelegate?
    
    
    // 기본적으로 선택한 이미지에 값이 있으면 이미지가 변경되었음을 의미
    private var imageChanged: Bool {
        return selectedImage != nil
    }
    
    private var selectedImage: UIImage? {
        didSet { headerView.profileImageView.image = selectedImage }
    }
    
    // MARK: - LifeCycle
    
    // 사용자 권한(current user)으로 이 컨트롤러를 초기화해야 한다
    init(user: User) {
        self.user = user
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureTableView()
        configureImagePicker()
    }
    
    // MARK: - Selectors
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleDone() {
        view.endEditing(true)
        guard imageChanged || userInfoChanged else { return }
        
        updateUserData()
    }
    
    // MARK: - API
    
    func updateUserData() {
        if imageChanged && !userInfoChanged {
            updateProfileImage()
        }
        
        if userInfoChanged && !imageChanged {
            UserService.shared.saveUserData(user: user) { err, ref in
                self.delegate?.controller(self, wantsToUpdate: self.user)
            }
        }
        
        if userInfoChanged && imageChanged {
            UserService.shared.saveUserData(user: user) { err, ref in
                self.updateProfileImage()
            }
        }
    }
    
    func updateProfileImage() {
        guard let image = selectedImage else { return }
        UserService.shared.updateProfileImage(image: image) { profileImageUrl in
            self.user.profileImageUrl = profileImageUrl
            self.delegate?.controller(self, wantsToUpdate: self.user)
        }
    }
    
    
    
    // MARK: - Helpers
    
    func configureNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.twitterBlue
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.tintColor = .white
        
        navigationItem.title = "Edit Profile"
        navigationItem.titleView?.tintColor = .white
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleDone))
    }
    
    func configureTableView() {
        tableView.tableHeaderView = headerView
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 180)
        headerView.delegate = self
        
        footerView.frame = CGRect(x: 0, y: view.frame.width, width: 50, height: 100)
        tableView.tableFooterView = footerView
        footerView.delegate = self

        tableView.register(EditProfileCell.self, forCellReuseIdentifier: reuseIdentifier)
    }
    
    func configureImagePicker() {
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
    }
}


// MARK: - UITableViewDataSource

extension EditProfileController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EditProfileOptions.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? EditProfileCell
        
        
        guard let cell = cell else { return UITableViewCell() }
        guard let option = EditProfileOptions(rawValue: indexPath.row) else { return cell }
        cell.viewModel = EditProfileViewModel(user: user, option: option)
        cell.delegate = self

        return cell
    }
}

// MARK: - UITableViewDelegate

extension EditProfileController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // 0 = EditProfileViewModel의 fullname
        guard let option = EditProfileOptions(rawValue: indexPath.row) else { return 0 }
        return option == .bio ? 100 : 48
    }
}


// MARK: - EditProfileHeaderDelegate

extension EditProfileController: EditProfileHeaderDelegate {
    func didTapChangeProfilePhoto() {
        present(imagePicker, animated: true, completion: nil)
    }
}


// MARK: - UIImagePickerControllerDelegate

extension EditProfileController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.editedImage] as? UIImage else { return }
        self.selectedImage = image
        
        dismiss(animated: true)
    }
}


// MARK: - EditProfileCellDelegate

extension EditProfileController: EditProfileCellDelegate {
    func updateUserInfo(_ cell: EditProfileCell) {
        guard let viewModel = cell.viewModel else { return }
        userInfoChanged = true
        navigationItem.rightBarButtonItem?.isEnabled = true
        
        switch viewModel.option {
            
        case .fullname:
            guard let fullname = cell.infoTextField.text else { return }
            user.fullname = fullname
        case .username:
            guard let username = cell.infoTextField.text else { return }
            user.username = username
            
            // 옵션이 바이오 변경을 인식한 다음 바이오를 업데이트함
        case .bio:
            user.bio = cell.bioTextView.text
        }
    }
}


extension EditProfileController: EditProfileFooterDelegate {
    func handleLogout() {
        print("DEBUG: Handle logout ..")
    }
}
