//
//  LXScrollContentView.swift
//  LXScrollContentView
//
//  Created by 刘行 on 2017/4/28.
//  Copyright © 2017年 刘行. All rights reserved.
//

import UIKit

private let kContentViewCellID = "kContentViewCellID"

class LXScrollContentView: UIView {
    
    fileprivate lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = self.bounds.size
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.scrollsToTop = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.bounces = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: kContentViewCellID)
        return collectionView
    }()
    
    fileprivate lazy var childVcs : [UIViewController] = {
        let childVcs = [UIViewController]()
        return childVcs
    }()
    
    fileprivate var parentVc : UIViewController?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK:- 设置UI
extension LXScrollContentView {
    
    fileprivate func setupUI(){
        addSubview(collectionView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = self.bounds
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = self.bounds.size
    }
    
    func reloadViewWithChildVcs(_ childVcs: [UIViewController], parentVc: UIViewController){
        self.childVcs.removeAll()
        for childVc in childVcs {
            self.childVcs.append(childVc)
        }
        self.parentVc = parentVc
        collectionView.reloadData()
    }
}

extension LXScrollContentView : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVcs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kContentViewCellID, for: indexPath);
        return cell
    }
}

extension LXScrollContentView : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        for view in cell.contentView.subviews {
            view.removeFromSuperview()
        }
        let childVc = childVcs[indexPath.row]
        parentVc?.addChildViewController(childVc)
        childVc.view.frame = cell.contentView.bounds
        cell.contentView.addSubview(childVc.view)
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let childVc = childVcs[indexPath.row]
        if childVc.view.superview != nil {
            childVc.view.removeFromSuperview()
        }
        if childVc.parent != nil {
            childVc.removeFromParentViewController()
        }
    }
    
}


