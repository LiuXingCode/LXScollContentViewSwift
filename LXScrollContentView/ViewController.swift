//
//  ViewController.swift
//  LXScrollContentView
//
//  Created by 刘行 on 2017/4/28.
//  Copyright © 2017年 刘行. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    fileprivate lazy var contentView : LXScrollContentView = {
        let contentView = LXScrollContentView(frame: CGRect(x: 0, y: 40, width: self.view.bounds.width, height: self.view.bounds.height - 40))
        contentView.delegate = self
        return contentView
    }()
    
    fileprivate lazy var segmentBar : LXSegmentBar = {
        let style = LXSegmentBarStyle()
        style.backgroundColor = UIColor(r: 245, g: 245, b: 245)
        let segmentBar = LXSegmentBar(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 40), style: style)
        segmentBar.delegate = self
        return segmentBar
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        setupUI()
        reloadData()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        segmentBar.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 35)
        contentView.frame = CGRect(x: 0, y: 35, width: view.bounds.width, height: view.bounds.height - 35)
    }
    
}

extension ViewController {
    
    fileprivate func setupUI() {
        view.addSubview(segmentBar)
        view.addSubview(contentView)
    }
    
    fileprivate func reloadData() {
        segmentBar.titles = ["科技", "教育", "NBA", "每日开心", "精选文章", "订阅号", "房地产", "财经", "纪录片", "视频"]
        var childVcs = [LXCategoryViewController]()
        for title in segmentBar.titles {
            let childVc = LXCategoryViewController()
            childVc.categoryStr = title
            childVc.view.backgroundColor = UIColor.randomColor()
            childVcs.append(childVc)
        }
        contentView.reloadViewWithChildVcs(childVcs, parentVc: self)
    }
}

extension ViewController : LXSegmentBarDelegate {
    func segmentBar(_ segmentBar: LXSegmentBar, selectedIndex: Int) {
        contentView.pageIndex = selectedIndex
    }
}

extension ViewController : LXScrollContentViewDelegate {
    
    func contentViewDidEndDecelerating(_ contentView: LXScrollContentView, startIndex: Int, endIndex: Int) {
        segmentBar.selectedIndex = endIndex
    }
    
    func contentViewDidScroll(_ contentView: LXScrollContentView, fromIndex: Int, toIndex: Int, progress: CGFloat) {
        
    }
}
