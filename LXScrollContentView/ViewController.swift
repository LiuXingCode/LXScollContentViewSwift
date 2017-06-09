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
        return contentView
    }()
    
    fileprivate lazy var segmentBar : LXSegmentBar = {
        let style = LXSegmentBarStyle()
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
        let childVcs : [UIViewController] = Array(repeating: UIViewController(), count: 8)
        contentView.reloadViewWithChildVcs(childVcs, parentVc: self)
        segmentBar.titles = ["科技", "教育", "NBA", "每日开心", "精选文章", "订阅号", "房地产", "财经", "纪录片", "视频"]
    }
}

extension ViewController : LXSegmentBarDelegate {
    func segmentBar(_ segmentBar: LXSegmentBar, selectedIndex: Int) {
        print("~~~~~~~~~~~~~~~~\(selectedIndex)")
    }
}
