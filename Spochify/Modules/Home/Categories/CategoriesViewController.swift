//
//  SearchViewController.swift
//  Spochify
//
//  Created by Alberto on 08/04/2019.
//  Copyright © 2019 com.github.albertopeam. All rights reserved.
//

import UIKit.UIViewController
import RxSwift

//TODO: change names
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
        super.init(collectionViewLayout: flowLayout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = String(localizedKey: String.Key.navCategories)
        collectionView.backgroundColor = .white
        collectionView.addSubview(refreshControl)
        collectionView.register(UINib(nibName: "CategoryCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier)
        flowLayout.numberOfColumns(columns)
    }
    
    func bindViewModel() {
        viewModel.categories
            .observeOn(MainScheduler.instance)
            .bind(to: collectionView.rx.items(cellIdentifier: CategoryCollectionViewCell.identifier)) { index, model, cell in
                guard let cell = cell as? CategoryCollectionViewCell else { fatalError() }
                cell.draw(category: model)
            }.disposed(by: disposeBag)
        collectionView.rx
            .modelSelected(Category.self)
            .subscribe(onNext: { (category) in
                //self.viewModel.tapped(playlist: playlist)
            }).disposed(by: disposeBag)
    }
    
}
