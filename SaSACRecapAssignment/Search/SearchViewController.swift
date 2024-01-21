//
//  SearchViewController.swift
//  SaSACRecapAssignment
//
//  Created by SUCHAN CHANG on 1/18/24.
//

import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tableViewHeaderView: UIView!
    @IBOutlet weak var removeAllButton: UIButton!

    @IBOutlet weak var recentKeywordListTableView: UITableView!
    
    private let nickname = UserDefaults.standard.string(forKey: UserDefaultsKeys.nickname.rawValue) ?? ""
    
    private var recentKeywordList: [String] = UserDefaults.standard.array(forKey: UserDefaultsKeys.recentKeywordList.rawValue) as? [String] ?? []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUserEvents()
        configureOthers()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()

        recentKeywordListTableView.reloadData()
        
        if recentKeywordList.isEmpty {
            tableViewHeaderView.isHidden = true
            recentKeywordListTableView.isHidden = true
        } else {
            tableViewHeaderView.isHidden = false
            recentKeywordListTableView.isHidden = false
        }

    }

}

extension SearchViewController: UIViewControllerConfigurationProtocol {
    
    func configureNavigationBar() {
        navigationItem.title = "\(nickname)님의 새싹쇼핑"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: Colors.textColor]
    }
    
    func configureUI() {

    }
    
    func configureOthers() {
        searchBar.delegate = self
    }
    
    func configureUserEvents() {
        removeAllButton.addTarget(self, action: #selector(removeAllButtonTapped), for: .touchUpInside)
    }
    
}

extension SearchViewController {
    @objc func removeAllButtonTapped() {
        recentKeywordList.removeAll()
        UserDefaults.standard.set([], forKey: UserDefaultsKeys.recentKeywordList.rawValue)
        recentKeywordListTableView.reloadData()
        tableViewHeaderView.isHidden = true
        recentKeywordListTableView.isHidden = true
    }
    
    @objc func removeKeywordButtonTapped(_ sender: UIButton) {
        recentKeywordList.remove(at: sender.tag)
        UserDefaults.standard.set(recentKeywordList, forKey: UserDefaultsKeys.recentKeywordList.rawValue)
        if recentKeywordList.isEmpty {
            tableViewHeaderView.isHidden = true
            recentKeywordListTableView.isHidden = true
        } else {
            tableViewHeaderView.isHidden = false
            recentKeywordListTableView.isHidden = false
        }
        recentKeywordListTableView.reloadData()
        
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text != "" {
            ShoppingManager.shared.fetchShoppingResults(keyword: searchBar.text!) { searchResults in
                let searchResultsVC = self.storyboard?.instantiateViewController(withIdentifier: SearchResultsViewController.identifier) as! SearchResultsViewController
                
                searchResultsVC.keyword = searchBar.text!
                searchResultsVC.searchResultList = searchResults.items
                searchResultsVC.totalNumberSearched = searchResults.total
                
                self.recentKeywordList.insert(searchBar.text!, at: 0)
                UserDefaults.standard.set(self.recentKeywordList, forKey: UserDefaultsKeys.recentKeywordList.rawValue)
                
                self.navigationController?.pushViewController(searchResultsVC, animated: true)
            }
            
        }

    }
}


extension SearchViewController: TableViewConfigrationProtocol {
    func configureTableView() {
        
        recentKeywordListTableView.delegate = self
        recentKeywordListTableView.dataSource = self
        
        let recentKeywordListTableViewCellXib = UINib(nibName: RecentKeywordListTableViewCell.identifier, bundle: nil)
        recentKeywordListTableView.register(recentKeywordListTableViewCellXib, forCellReuseIdentifier: RecentKeywordListTableViewCell.identifier)
        
        recentKeywordListTableView.rowHeight = 60
        recentKeywordListTableView.separatorStyle = .none
    }
}

extension SearchViewController: UITableViewDelegate {
    
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recentKeywordList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RecentKeywordListTableViewCell.identifier, for: indexPath) as! RecentKeywordListTableViewCell
        
        let recentKeyword = recentKeywordList[indexPath.row]
        cell.keywordLabel.text = recentKeyword
        
        cell.removeKeywordButton.tag = indexPath.row
        
        cell.removeKeywordButton.addTarget(self, action: #selector(removeKeywordButtonTapped), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let recentKeyword = recentKeywordList[indexPath.row]
        searchBar.text = recentKeyword
        ShoppingManager.shared.fetchShoppingResults(keyword: recentKeyword) { searchResults in
            
            let searchResultsVC = self.storyboard?.instantiateViewController(withIdentifier: SearchResultsViewController.identifier) as! SearchResultsViewController
            
            searchResultsVC.keyword = recentKeyword
            searchResultsVC.searchResultList = searchResults.items
            searchResultsVC.totalNumberSearched = searchResults.total
            
            self.recentKeywordList.insert(recentKeyword, at: 0)
            UserDefaults.standard.set(self.recentKeywordList, forKey: UserDefaultsKeys.recentKeywordList.rawValue)
            
            self.navigationController?.pushViewController(searchResultsVC, animated: true)
        }
    }
}
