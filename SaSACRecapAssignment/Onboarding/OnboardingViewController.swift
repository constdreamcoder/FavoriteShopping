//
//  OnboardingViewController.swift
//  SaSACRecapAssignment
//
//  Created by SUCHAN CHANG on 1/18/24.
//

import UIKit

class OnboardingViewController: UIViewController {

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
        startButton.layer.cornerRadius = 8
    }
    
    func configureOthers() {
        
    }

    func configureUserEvents() {
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
    }

}
