//
//  SettingsViewController.swift
//  SaSACRecapAssignment
//
//  Created by SUCHAN CHANG on 1/18/24.
//

import UIKit

class SettingsViewController: UIViewController {

    // MARK: - Properties
    @IBOutlet weak var userProfileContainerView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var heartCountLabel: UILabel!
    
    @IBOutlet weak var settingsTableView: UITableView!
            
    private let settingsList = ["공지사항", "자주 묻는 질문", "1:1 문의", "알림 설정", "처음부터 시작하기"]
    
    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationBar()
        configureUI()
        configureOthers()
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
    
    @IBAction func userProfileContainerViewTapped(_ sender: UITapGestureRecognizer) {
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
    
    func configureUI() {
        userProfileContainerView.backgroundColor = Colors.settingsElementBackgroundColor
        userProfileContainerView.layer.cornerRadius = 8
        
        profileImageView.contentMode = .scaleAspectFit
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
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
        
    }
}

// MARK: - UITableView UI And Settings Configuration Methods
extension SettingsViewController: TableViewConfigrationProtocol {
    
    func configureTableView() {
        settingsTableView.delegate = self
        settingsTableView.dataSource = self
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
