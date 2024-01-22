//
//  OnboardingViewController.swift
//  SaSACRecapAssignment
//
//  Created by SUCHAN CHANG on 1/18/24.
//

import UIKit

final class OnboardingViewController: UIViewController {

    // MARK: - Properties
    @IBOutlet weak var appLogoImageView: UIImageView!
    @IBOutlet weak var onboardingImageView: UIImageView!
    @IBOutlet weak var startButton: UIButton!
    
    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureUI()
        configureUserEvents()
    }
}

// MARK: - User Evernt Methods
extension OnboardingViewController {
    
    @objc private func startButtonTapped() {
        let profileSettginsVC = storyboard?.instantiateViewController(withIdentifier: ProfileSettingsViewController.identifier) as! ProfileSettingsViewController
        
        profileSettginsVC.editMode = false
        
        navigationController?.pushViewController(profileSettginsVC, animated: true)
    }
}

// MARK: - UIViewController UI And Settings Configuration Methods
extension OnboardingViewController: UIViewControllerConfigurationProtocol {
    
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
