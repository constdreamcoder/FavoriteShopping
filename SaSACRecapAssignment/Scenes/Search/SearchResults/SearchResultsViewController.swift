//
//  SearchResultsViewController.swift
//  SaSACRecapAssignment
//
//  Created by SUCHAN CHANG on 1/19/24.
//

import UIKit
import Kingfisher

class SearchResultsViewController: UIViewController {
    
    @IBOutlet weak var resultCountLabel: UILabel!
    
    @IBOutlet weak var byAccuracyButton: UIButton!
    @IBOutlet weak var byDateButton: UIButton!
    @IBOutlet weak var byHighestPriceButton: UIButton!
    @IBOutlet weak var byLowestPriceButton: UIButton!
    
    @IBOutlet weak var resultListCollectionView: UICollectionView!
    
    var keyword: String = ""
    var searchResultList: [Item] = []
    var totalNumberSearched: Int = 0

    private var sortingStandard: SortingStandard = .byAccuracy
    private let display = 30
    private var start: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        configureUserEvents()
        configureCollectionView()        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        configureNavigationBar()
        resultListCollectionView.reloadData()
    }
}

extension SearchResultsViewController {
    @objc func sortProducts(_ sender: UIButton) {
        print("\(sender.title(for: .normal)!)")
    
        [
            byAccuracyButton,
            byDateButton,
            byHighestPriceButton,
            byLowestPriceButton
        ].forEach { sortingButton in
            if sortingButton == sender {
                sortingButton.layer.cornerRadius = 8
                sortingButton.layer.borderColor = UIColor.white.cgColor
                sortingButton.layer.borderWidth = 1
                sortingButton.setTitleColor(.black, for: .normal)
                sortingButton.backgroundColor = .white
            } else {
                sortingButton.layer.cornerRadius = 8
                sortingButton.layer.borderColor = Colors.textColor.cgColor
                sortingButton.layer.borderWidth = 1
                sortingButton.setTitleColor(Colors.textColor, for: .normal)
                sortingButton.backgroundColor = Colors.backgroundColor
            }
        }
        
        if sender == byAccuracyButton {
            sortingStandard = .byAccuracy
            
            ShoppingManager.shared.fetchShoppingResults(
                keyword: keyword,
                sortingStandard: .byAccuracy
            ) { searchResults in
                self.start = 1
                self.searchResultList = searchResults.items
                self.resultListCollectionView.reloadData()
                
                self.resultListCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
            }
        } else if sender == byDateButton {
            sortingStandard = .byDate

            ShoppingManager.shared.fetchShoppingResults(
                keyword: keyword,
                sortingStandard: .byDate
            ) { searchResults in
                self.start = 1
                self.searchResultList = searchResults.items
                self.resultListCollectionView.reloadData()
                
                self.resultListCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
            }
        } else if sender == byHighestPriceButton {
            sortingStandard = .byHighestPrice
            
            ShoppingManager.shared.fetchShoppingResults(
                keyword: keyword,
                sortingStandard: .byHighestPrice
            ) { searchResults in
                self.start = 1
                self.searchResultList = searchResults.items
                self.resultListCollectionView.reloadData()
                
                self.resultListCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
            }
        } else if sender == byLowestPriceButton {
            sortingStandard = .byLowestPrice
            
            ShoppingManager.shared.fetchShoppingResults(
                keyword: keyword,
                sortingStandard: .byLowestPrice
            ) { searchResults in
                self.start = 1
                self.searchResultList = searchResults.items
                self.resultListCollectionView.reloadData()
                
                self.resultListCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
            }
        }
    }
}

extension SearchResultsViewController: UIViewControllerConfigurationProtocol {
    func configureNavigationBar() {
        navigationItem.title = keyword
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: Colors.textColor]
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.topItem?.title = ""
    }
    
    func configureUI() {
        view.backgroundColor = Colors.backgroundColor
        
        resultCountLabel.text = "\(totalNumberSearched.putCommaEveryThreeDigits) 개의 검색 결과"
        resultCountLabel.textColor = Colors.pointColor
        resultCountLabel.textAlignment = .left
        resultCountLabel.font = .systemFont(ofSize: 16.0, weight: .bold)

        byAccuracyButton.setTitle("정확도", for: .normal)
        byAccuracyButton.setTitleColor(.black, for: .normal)
        byAccuracyButton.titleLabel?.font = .systemFont(ofSize: 15.0)
        byAccuracyButton.backgroundColor = .white
        byAccuracyButton.layer.cornerRadius = 8
        byAccuracyButton.layer.borderColor = UIColor.white.cgColor
        byAccuracyButton.layer.borderWidth = 1
        byAccuracyButton.contentEdgeInsets = .init(top: 0, left: 6, bottom: 0, right: 6)
        
        byDateButton.setTitle("날짜순", for: .normal)
        byDateButton.setTitleColor(Colors.textColor, for: .normal)
        byDateButton.titleLabel?.font = .systemFont(ofSize: 15.0)
        byDateButton.backgroundColor = Colors.backgroundColor
        byDateButton.layer.cornerRadius = 8
        byDateButton.layer.borderColor = UIColor.white.cgColor
        byDateButton.layer.borderWidth = 1
        byDateButton.contentEdgeInsets = .init(top: 0, left: 6, bottom: 0, right: 6)
        
        byHighestPriceButton.setTitle("가격높은순", for: .normal)
        byHighestPriceButton.titleLabel?.font = .systemFont(ofSize: 15.0)
        byHighestPriceButton.setTitleColor(Colors.textColor, for: .normal)
        byHighestPriceButton.backgroundColor = Colors.backgroundColor
        byHighestPriceButton.layer.cornerRadius = 8
        byHighestPriceButton.layer.borderColor = UIColor.white.cgColor
        byHighestPriceButton.layer.borderWidth = 1
        byHighestPriceButton.contentEdgeInsets = .init(top: 0, left: 6, bottom: 0, right: 6)
       
        byLowestPriceButton.setTitle("가격낮은순", for: .normal)
        byLowestPriceButton.titleLabel?.font = .systemFont(ofSize: 15.0)
        byLowestPriceButton.setTitleColor(Colors.textColor, for: .normal)
        byLowestPriceButton.backgroundColor = Colors.backgroundColor
        byLowestPriceButton.layer.cornerRadius = 8
        byLowestPriceButton.layer.borderColor = UIColor.white.cgColor
        byLowestPriceButton.layer.borderWidth = 1
        byLowestPriceButton.contentEdgeInsets = .init(top: 0, left: 6, bottom: 0, right: 6)
        
        resultListCollectionView.backgroundColor = .clear
    }
    
    func configureOthers() {
        
    }
    
    func configureUserEvents() {
        byAccuracyButton.addTarget(self, action: #selector(sortProducts), for: .touchUpInside)
        byDateButton.addTarget(self, action: #selector(sortProducts), for: .touchUpInside)
        byHighestPriceButton.addTarget(self, action: #selector(sortProducts), for: .touchUpInside)
        byLowestPriceButton.addTarget(self, action: #selector(sortProducts), for: .touchUpInside)
    }
}

extension SearchResultsViewController: CollectionViewConfigurationProtocol {
    func configureCollectionView() {
        resultListCollectionView.delegate = self
        resultListCollectionView.dataSource = self
        
        resultListCollectionView.prefetchDataSource = self
        
        let resultListCollectionViewCellXib = UINib(nibName: ResultListCollectionViewCell.identifier, bundle: nil)
        resultListCollectionView.register(resultListCollectionViewCellXib, forCellWithReuseIdentifier: ResultListCollectionViewCell.identifier)
        
        let spacing: CGFloat = 12
        
        let layout = UICollectionViewFlowLayout()
        let itemSize = UIScreen.main.bounds.width - (spacing * 3)
        layout.itemSize = CGSize(width: itemSize / 2, height: (itemSize / 2) * 1.6)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        
        resultListCollectionView.collectionViewLayout = layout
    }
    
}

extension SearchResultsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let searchDetailVC = storyboard?.instantiateViewController(withIdentifier: SearchDetailViewController.identifier) as! SearchDetailViewController
        
        searchDetailVC.productTitle = searchResultList[indexPath.item].title
        searchDetailVC.productId = searchResultList[indexPath.item].productId
        
        navigationController?.pushViewController(searchDetailVC, animated: true)
    }
}

extension SearchResultsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchResultList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ResultListCollectionViewCell.identifier, for: indexPath) as! ResultListCollectionViewCell
        
        let result = searchResultList[indexPath.item]
        
        let url = URL(string: result.image)
        let placeholderImage = UIImage(named: Images.noImage)
        cell.thumbnailImageView.kf.setImage(with: url, placeholder: placeholderImage)
        cell.mallNameLabel.text = result.mallName
        cell.titleLabel.text = result.title
        cell.priceLabel.text = Int(result.lprice)?.putCommaEveryThreeDigits
        
        cell.productId = result.productId
        
        cell.updateHeartButtonImage()
        
        return cell
    }
}

extension SearchResultsViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        print("Preftech \(indexPaths)")
        for item in indexPaths {
            if start <= 1000 && totalNumberSearched > display + start && searchResultList.count - 4 == item.item {
                start += display
                ShoppingManager.shared.fetchShoppingResults(
                    keyword: self.keyword,
                    sortingStandard: self.sortingStandard,
                    start: self.start,
                    display: totalNumberSearched < display + start ? totalNumberSearched % display : display
                ) { searchResults in
                    self.searchResultList.append(contentsOf: searchResults.items)
                    self.resultListCollectionView.reloadData()
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        print("Cancel Prefetch \(indexPaths)")
    }
}


