//
//  SearchViewController.swift
//  Spochify
//
//  Created by Alberto on 08/04/2019.
//  Copyright © 2019 com.github.albertopeam. All rights reserved.
//

import UIKit.UIViewController
import RxSwift

class CategoriesViewController: UICollectionViewController, BindableType {
    typealias ViewModelType = CategoriesViewModel
    
    var viewModel: CategoriesViewModel!
    private let flowLayout: UICollectionViewFlowLayout
    private let refreshControl: UIRefreshControl
    private let columns = 2
    private let disposeBag = DisposeBag()
    
    init() {
        flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        flowLayout.minimumLineSpacing = 8
        flowLayout.minimumInteritemSpacing = 8
        refreshControl = UIRefreshControl(frame: CGRect.zero)
        refreshControl.tintColor = .gray
        super.init(collectionViewLayout: flowLayout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = String(localizedKey: String.Key.navCategories)
        collectionView.backgroundColor = .white
        collectionView.register(UINib(nibName: "CategoryCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier)
        collectionView.addSubview(refreshControl)
        collectionView.alwaysBounceVertical = true
        refreshControl.beginRefreshing()
        flowLayout.numberOfColumns(columns)
    }
    
    func bindViewModel() {
        viewModel.categories
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (_) in
                self.refreshControl.endRefreshing()
            }, onError: { (_) in
                self.refreshControl.endRefreshing()
            })
            .disposed(by: disposeBag)
        
        viewModel.categories
            .observeOn(MainScheduler.instance)
            .bind(to: collectionView.rx.items(cellIdentifier: CategoryCollectionViewCell.identifier)) { index, model, cell in
                guard let cell = cell as? CategoryCollectionViewCell else { fatalError() }
                cell.draw(category: model)
            }.disposed(by: disposeBag)
        
        collectionView.rx
            .modelSelected(Category.self)
            .flatMap({ self.viewModel.tappedCategory.execute($0) })            
            .subscribe()
            .disposed(by: disposeBag)
    }
    
}
