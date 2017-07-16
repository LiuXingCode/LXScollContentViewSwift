//
//  LXScrollContentView.swift
//  LXScrollContentView
//
//  Created by 刘行 on 2017/4/28.
//  Copyright © 2017年 刘行. All rights reserved.
//

import UIKit

private let kContentViewCellID = "kContentViewCellID"

@objc protocol LXScrollContentViewDelegate {
    @objc optional func contentViewDidEndDecelerating(_ contentView: LXScrollContentView, startIndex: Int, endIndex: Int)
    @objc optional func contentViewDidScroll(_ contentView: LXScrollContentView, fromIndex: Int, toIndex: Int, progress: CGFloat)
}

public class LXScrollContentView: UIView {
    
    weak var delegate: LXScrollContentViewDelegate?
    
    var pageIndex : Int = 0 {
        didSet{
            guard pageIndex != oldValue && pageIndex >= 0 && pageIndex < childVcs.count - 1 else {
                return
            }
            isForbidScrollDelegate = true
            collectionView.scrollToItem(at: IndexPath(row: pageIndex, section: 0), at: .left, animated: false)
        }
    }
    
    fileprivate var isForbidScrollDelegate : Bool = false
    
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
    
    fileprivate var startOffsetX : CGFloat = 0

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK:- 设置UI
extension LXScrollContentView {
    
    fileprivate func setupUI(){
        addSubview(collectionView)
    }
    
    override public func layoutSubviews() {
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
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVcs.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kContentViewCellID, for: indexPath);
        return cell
    }
}

extension LXScrollContentView : UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        for view in cell.contentView.subviews {
            view.removeFromSuperview()
        }
        let childVc = childVcs[indexPath.row]
        parentVc?.addChildViewController(childVc)
        childVc.view.frame = cell.contentView.bounds
        cell.contentView.addSubview(childVc.view)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let childVc = childVcs[indexPath.row]
        if childVc.view.superview != nil {
            childVc.view.removeFromSuperview()
        }
        if childVc.parent != nil {
            childVc.removeFromParentViewController()
        }
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate && collectionView == scrollView {
            scollViewEndScroll()
        }
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if collectionView == scrollView {
            scollViewEndScroll()
        }
    }
    
    private func scollViewEndScroll() {
        let endOffsetX = collectionView.contentOffset.x
        let startIndex = Int(startOffsetX / collectionView.bounds.width)
        let endIndex = Int(endOffsetX / collectionView.bounds.width)
        self.delegate?.contentViewDidEndDecelerating?(self, startIndex: startIndex, endIndex: endIndex)
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        startOffsetX = scrollView.contentOffset.x
        isForbidScrollDelegate = false
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView == collectionView && isForbidScrollDelegate == false else {
            return
        }
        let endOffsetX = scrollView.contentOffset.x
        let fromIndex = Int(startOffsetX / scrollView.bounds.width)
        var progress : CGFloat = 0
        var toIndex : Int = 0
        
        if startOffsetX < endOffsetX {//左滑
            progress = (endOffsetX - startOffsetX) / scrollView.bounds.width
            toIndex = fromIndex + 1
            if toIndex > childVcs.count - 1 {
                toIndex = childVcs.count - 1
            }
        } else if startOffsetX == endOffsetX{
            progress = 0
            toIndex = fromIndex
        } else {
            progress = (startOffsetX - endOffsetX) / scrollView.bounds.width
            toIndex = fromIndex - 1
            if toIndex < 0 {
                toIndex = 0
            }
        }
        self.delegate?.contentViewDidScroll?(self, fromIndex: fromIndex, toIndex: toIndex, progress: progress)
    }
    
}


