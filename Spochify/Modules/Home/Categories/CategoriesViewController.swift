//
//  SearchViewController.swift
//  Spochify
//
//  Created by Alberto on 08/04/2019.
//  Copyright © 2019 com.github.albertopeam. All rights reserved.
//

import UIKit.UIViewController
import RxSwift

class CategoriesViewController: UIViewController, BindableType {
    
    typealias ViewModelType = CategoriesViewModel
    private let collectionView: UICollectionView
    private let columns: Float = 2
    private let disposeBag = DisposeBag()
    var viewModel: CategoriesViewModel!
    
    init() {
        collectionView = UICollectionView.mold
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = String(localizedKey: String.Key.navCategories)
        addStickedView(collectionView)
        collectionView.flowLayout.numberOfColumns(columns)
    }
    
    func bindViewModel() {
        viewModel.categories
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] (_) in
                self.collectionView.refreshControl?.endRefreshing()
            }, onError: { (_) in
                self.collectionView.refreshControl?.endRefreshing()
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
            .flatMap({ [unowned self] in self.viewModel.tappedCategory.execute($0) })
            .subscribe()
            .disposed(by: disposeBag)
        viewModel.hasTracks
            .bind(onNext: { playing in self.collectionView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: MiniPlayerView.ViewTraits.height, right: 0) })
            .disposed(by: disposeBag)
    }
    
}
