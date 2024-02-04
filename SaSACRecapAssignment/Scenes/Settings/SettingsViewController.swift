//
//  SettingsViewController.swift
//  SaSACRecapAssignment
//
//  Created by SUCHAN CHANG on 1/18/24.
//

import UIKit
import SnapKit

class SettingsViewController: UIViewController {

    // MARK: - Properties
    lazy var userProfileContainerView: UIView = {
        let view = UIView()
        [
            profileImageView,
            userInfoStackView
        ].forEach { view.addSubview($0) }
        return view
    }()
    
    let profileImageView = UIImageView()
    
    lazy var userInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .leading
        stackView.distribution = .fill
        [
            nicknameLabel,
            heartCountLabel
        ].forEach { stackView.addArrangedSubview($0) }
        return stackView
    }()
    
    let nicknameLabel = UILabel()
    let heartCountLabel = UILabel()
    
    let separatorView = UIView()
    
    let settingsTableView = UITableView()
            
    private let settingsList = ["공지사항", "자주 묻는 질문", "1:1 문의", "알림 설정", "처음부터 시작하기"]
    
    private let profileImageViewWidth: CGFloat = 50.0
    
    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationBar()
        configureConstraints()
        configureUI()
        configureOthers()
        configureUserEvents()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     
        // profileImageView 이미지 업데이트
        let profileImageName = UserDefaults.standard.string(forKey: UserDefaultsKeys.currentProfileImageName.rawValue) ?? "no_image"
        profileImageView.image = UIImage(named: profileImageName)
        
        // nicknameLabel 텍스트 업데이트
        nicknameLabel.text = UserDefaults.standard.string(forKey: UserDefaultsKeys.nickname.rawValue) ?? ""

        // heartCountLabel 텍스트 업데이트 및 AttributedString 적용
        guard let heartPressedList = UserDefaults.standard.dictionary(forKey: UserDefaultsKeys.heartPressedList.rawValue) else { return }
        
        heartCountLabel.text = "\(heartPressedList.count)개의 상품을 좋아하고 있어요!"
        
        let attributedString = NSMutableAttributedString(string: heartCountLabel.text ?? "")
        attributedString.addAttribute(.foregroundColor, value: Colors.pointColor, range: ((heartCountLabel.text ?? "") as NSString).range(of: "\(heartPressedList.count)개의 상품"))
        heartCountLabel.attributedText = attributedString
    }
}

// MARK: - User Events Methods
extension SettingsViewController {
    
    @objc func userProfileContainerViewTapped(_ sender: UITapGestureRecognizer) {
        let profileSettingsVC = storyboard?.instantiateViewController(withIdentifier: ProfileSettingsViewController.identifier) as! ProfileSettingsViewController
        
        profileSettingsVC.editMode = true
        profileSettingsVC.currentUserProfileImageName = UserDefaults.standard.string(forKey: UserDefaultsKeys.currentProfileImageName.rawValue)!
        profileSettingsVC.currentUserNickname = nicknameLabel.text ?? ""
        
        navigationController?.pushViewController(profileSettingsVC, animated: true)
    }
}

// MARK: - UIViewController UI And Settings Configuration Methods
extension SettingsViewController: UIViewControllerConfigurationProtocol {
    
    func configureNavigationBar() {
        navigationItem.title = "설정"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: Colors.textColor]
    }
    
    func configureConstraints() {
        [
            userProfileContainerView,
            separatorView,
            settingsTableView
        ].forEach { view.addSubview($0) }
        
        userProfileContainerView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16.0)
            $0.height.equalTo(70.0)
        }
        
        profileImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16.0)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(profileImageViewWidth)
        }
        
        userInfoStackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(profileImageView.snp.trailing).offset(24.0)
            $0.trailing.equalToSuperview().inset(16.0)
        }
        
        nicknameLabel.snp.makeConstraints {
            $0.width.equalToSuperview()
        }
        
        heartCountLabel.snp.makeConstraints {
            $0.width.equalToSuperview()
        }
        
        separatorView.snp.makeConstraints {
            $0.top.equalTo(userProfileContainerView.snp.bottom)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(16.0)
        }
        
        settingsTableView.snp.makeConstraints {
            $0.top.equalTo(separatorView.snp.bottom)
            $0.horizontalEdges.equalTo(userProfileContainerView)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func configureUI() {
        userProfileContainerView.backgroundColor = Colors.settingsElementBackgroundColor
        userProfileContainerView.layer.cornerRadius = 8
        
        profileImageView.contentMode = .scaleAspectFit
        profileImageView.layer.cornerRadius = profileImageViewWidth / 2
        profileImageView.clipsToBounds = true
        profileImageView.layer.borderWidth = 4
        profileImageView.layer.borderColor = Colors.pointColor.cgColor
        
        nicknameLabel.font = .systemFont(ofSize: 18.0, weight: .semibold)
        nicknameLabel.textColor = Colors.textColor
        nicknameLabel.textAlignment = .left
        
        heartCountLabel.font = .systemFont(ofSize: 14.0, weight: .semibold)
        heartCountLabel.textAlignment = .left
        heartCountLabel.textColor = Colors.textColor
        
        settingsTableView.backgroundColor = .clear
    }
    
    func configureOthers() {
        settingsTableView.isScrollEnabled = false
    }
    
    func configureUserEvents() {
        userProfileContainerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(userProfileContainerViewTapped)))
    }
}

// MARK: - UITableView UI And Settings Configuration Methods
extension SettingsViewController: UITableViewConfigrationProtocol {
    
    func configureTableView() {
        settingsTableView.delegate = self
        settingsTableView.dataSource = self
        
        settingsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "SettingTableViewCell")
    }
}

// MARK: UITableView Delegate Methods
extension SettingsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == settingsList.count - 1 {
            createAnAlert(title: "처음부터 시작하기", message: "데이터를 모두 초기화 하시겠습니까?") {
                UserDefaultsKeys.allCases.forEach { userDefaultsKey in
                    if userDefaultsKey == UserDefaultsKeys.userLoginState {
                        UserDefaults.standard.set(false, forKey: userDefaultsKey.rawValue)
                    } else {
                        UserDefaults.standard.set(nil, forKey: userDefaultsKey.rawValue)
                    }
                }
                
                let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                let sceneDelegate = windowScene?.delegate as? SceneDelegate
                
                let onboardingVC = self.storyboard?.instantiateViewController(withIdentifier: OnboardingViewController.identifier) as! OnboardingViewController
                let nav = UINavigationController(rootViewController: onboardingVC)
                
                sceneDelegate?.window?.rootViewController = nav
                sceneDelegate?.window?.makeKeyAndVisible()
            }
        }
    }
}

// MARK: UITableView DataSource Methods
extension SettingsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingTableViewCell")!
        
        cell.selectionStyle = .none
        cell.backgroundColor = Colors.settingsElementBackgroundColor
        cell.textLabel?.textColor = Colors.textColor
        cell.textLabel?.font = .systemFont(ofSize: 12.0)

        if indexPath.row == 0  {
            cell.layer.cornerRadius = 8
            cell.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            cell.layer.masksToBounds = true
        } else if indexPath.row == settingsList.count - 1 {
            cell.layer.cornerRadius = 8
            cell.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            cell.layer.masksToBounds = true
        }
        
        cell.textLabel?.text = settingsList[indexPath.row]
        
        return cell
    }
}
