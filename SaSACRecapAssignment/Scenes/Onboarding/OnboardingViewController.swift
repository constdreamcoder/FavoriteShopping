//
//  OnboardingViewController.swift
//  SaSACRecapAssignment
//
//  Created by SUCHAN CHANG on 1/18/24.
//

import UIKit

class OnboardingViewController: UIViewController {

    @IBOutlet weak var appLogoImageView: UIImageView!
    @IBOutlet weak var onboardingImageView: UIImageView!
    @IBOutlet weak var startButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureUI()
        configureUserEvents()
    }
}

// MARK: - User Evernt Methods
extension OnboardingViewController {
    @objc func startButtonTapped() {
        let profileSettginsVC = storyboard?.instantiateViewController(withIdentifier: ProfileSettingsViewController.identifier) as! ProfileSettingsViewController
        
        profileSettginsVC.editMode = false
        
        navigationController?.pushViewController(profileSettginsVC, animated: true)
    }
}

// MARK: - UI Methods
extension OnboardingViewController: UIViewControllerConfigurationProtocol {
    // TODO: - 나중에 필요없을 시 삭제
    func configureNavigationBar() {
    
    }
    
    func configureUI() {
        view.backgroundColor = Colors.backgroundColor
        
        appLogoImageView.image = UIImage(named: Images.sesacShopping)
        appLogoImageView.contentMode = .scaleAspectFit
        
        onboardingImageView.image = UIImage(named: Images.onboarding)
        onboardingImageView.contentMode = .scaleAspectFit
        
        startButton.setTitle("시작하기", for: .normal)
        startButton.setTitleColor(Colors.textColor, for: .normal)
        startButton.titleLabel?.font = .systemFont(ofSize: 18.0, weight: .bold)
        startButton.layer.cornerRadius = 8
    }
    
    func configureOthers() {
        
    }

    func configureUserEvents() {
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
    }

}
