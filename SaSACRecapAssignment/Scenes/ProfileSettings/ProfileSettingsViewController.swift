//
//  ProfileSettingsViewController.swift
//  SaSACRecapAssignment
//
//  Created by SUCHAN CHANG on 1/18/24.
//

import UIKit

final class ProfileSettingsViewController: UIViewController {

    // MARK: - Properties
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var cameraImageView: UIImageView!
    
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var errorMessageLabel: UILabel!

    @IBOutlet weak var completitonButton: UIButton!
    
    private let referenceProfileImageNameList: [String] = ProfileImages.allCases.map { $0.rawValue }
    private lazy var randomProfileImageName = referenceProfileImageNameList.randomElement()!
    
    var editMode: Bool = false
    var currentUserProfileImageName: String = ""
    var currentUserNickname: String = ""
    
    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureOthers()
        configureUserEvents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureNavigationBar()
    
        if editMode && currentUserProfileImageName != "" {
            UserDefaults.standard.set(currentUserProfileImageName, forKey: UserDefaultsKeys.selectedProfileImageName.rawValue)
        }
        
        let profileImageName = UserDefaults.standard.string(forKey: UserDefaultsKeys.selectedProfileImageName.rawValue) ?? randomProfileImageName
        profileButton.setImage(UIImage(named: profileImageName), for: .normal)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if isMovingFromParent {
            UserDefaults.standard.set(nil, forKey: UserDefaultsKeys.selectedProfileImageName.rawValue)
            nicknameTextField.text = nil
        }
    }
    
    // MARK: - Custom Methods
    private func checkNicknameLimitation(text: String) {
        if text.count < 2 || text.count >= 10 {
            errorMessageLabel.text = "2글자 이상 10글자 미만으로 설정해주세요"
            errorMessageLabel.textColor = .red
        } else if text.contains("@") || text.contains("#")
                    || text.contains("$") || text.contains("%") {
            errorMessageLabel.text = "닉네임에 @, #, $, %는 포함할 수 없어요"
            errorMessageLabel.textColor = .red
        } else if text.filter({ $0.isNumber }).count >= 1 {
            errorMessageLabel.text = "닉네임에 숫자는 포함할 수 없어요"
            errorMessageLabel.textColor = .red
        } else {
            errorMessageLabel.text = "사용할 수 있는 닉네임이에요"
            errorMessageLabel.textColor = Colors.pointColor
        }
    }
}

// MARK: - User Evernt Methods
extension ProfileSettingsViewController {
    
    @objc private func profileButtonTapped() {
        let profileSelectionVC = storyboard?.instantiateViewController(withIdentifier: ProfileSelectionViewController.identifier) as! ProfileSelectionViewController
        
        profileSelectionVC.selectedProfileName = UserDefaults.standard.string(forKey: UserDefaultsKeys.selectedProfileImageName.rawValue) ?? randomProfileImageName
        profileSelectionVC.referenceProfileNameList = referenceProfileImageNameList
        
        currentUserProfileImageName = ""
        
        navigationController?.pushViewController(profileSelectionVC, animated: true)
    }
    
    @objc private func completeProfileSetting() {
       
        checkNicknameLimitation(text: nicknameTextField.text!)

        if errorMessageLabel.textColor == Colors.pointColor {
            UserDefaults.standard.set(true, forKey: UserDefaultsKeys.userLoginState.rawValue)

            UserDefaults.standard.set(nicknameTextField.text!, forKey: UserDefaultsKeys.nickname.rawValue)
            
            let profileImageName = UserDefaults.standard.string(forKey: UserDefaultsKeys.selectedProfileImageName.rawValue) ?? randomProfileImageName
            UserDefaults.standard.set(profileImageName, forKey: UserDefaultsKeys.currentProfileImageName.rawValue)
            
            if editMode {
                navigationController?.popViewController(animated: true)
            } else {
                let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                let sceneDelegate = windowScene?.delegate as? SceneDelegate
                
                let mainTabBarVC = storyboard?.instantiateViewController(identifier: "MainTabBarController") as! UITabBarController
                mainTabBarVC.tabBar.tintColor = Colors.pointColor

                sceneDelegate?.window?.rootViewController = mainTabBarVC
                sceneDelegate?.window?.makeKeyAndVisible()
                
                // 초기화
                UserDefaults.standard.set([String: Any](), forKey: UserDefaultsKeys.heartPressedList.rawValue)
                UserDefaults.standard.set([String](), forKey: UserDefaultsKeys.recentKeywordList.rawValue)
            }
        }
    }
}

// MARK: - UIViewController UI And Settings Configuration Methods
extension ProfileSettingsViewController: UIViewControllerConfigurationProtocol {
    func configureConstraints() {
        
    }
    
   
    func configureNavigationBar() {
        navigationItem.title = "프로필 설정"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: Colors.textColor]
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.topItem?.title = ""
    }
    
    func configureUI() {
        view.backgroundColor = Colors.backgroundColor

        profileButton.layer.cornerRadius = profileButton.frame.width / 2
        profileButton.clipsToBounds = true
        profileButton.layer.borderColor = Colors.pointColor.cgColor
        profileButton.layer.borderWidth = 5
        
        cameraImageView.image = UIImage(named: Images.camera)
        cameraImageView.contentMode = .scaleAspectFit
        
        nicknameTextField.placeholder = "닉네임을 입력해주세요 :)"
        nicknameTextField.attributedPlaceholder = NSAttributedString(string: nicknameTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : UIColor.darkGray])
        nicknameTextField.font = .systemFont(ofSize: 16.0)
        nicknameTextField.textColor = Colors.textColor
        nicknameTextField.textAlignment = .left
        nicknameTextField.borderStyle = .none
        let nickname = editMode ? currentUserNickname : UserDefaults.standard.string(forKey: UserDefaultsKeys.nickname.rawValue) ?? ""
        nicknameTextField.text = nickname
        
        errorMessageLabel.textAlignment = .left
        errorMessageLabel.textColor = Colors.textColor
        errorMessageLabel.numberOfLines = 2
        errorMessageLabel.font = .systemFont(ofSize: 14.0)
        
        completitonButton.setTitle("완료", for: .normal)
        completitonButton.setTitleColor(Colors.textColor, for: .normal)
        completitonButton.titleLabel?.font = .systemFont(ofSize: 18.0, weight: .bold)
        completitonButton.layer.cornerRadius = 8
    }
    
    func configureOthers() {
        nicknameTextField.delegate = self
    }
    
    func configureUserEvents() {
        profileButton.addTarget(self, action: #selector(profileButtonTapped), for: .touchUpInside)
        completitonButton.addTarget(self, action: #selector(completeProfileSetting), for: .touchUpInside)
    }
}

// MARK: - UITextField Delegate Methods
extension ProfileSettingsViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        checkNicknameLimitation(text: textField.text!)
    }
}
