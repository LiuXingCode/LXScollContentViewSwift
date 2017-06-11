//
//  LXCategoryViewController.swift
//  LXScrollContentView
//
//  Created by 刘行 on 2017/6/11.
//  Copyright © 2017年 刘行. All rights reserved.
//

import UIKit

private let kTableViewCellID = "kTableViewCellID"

class LXCategoryViewController: UIViewController {
    
    var categoryStr : String = ""
    
    fileprivate lazy var tableView : UITableView = {
        let tableView = UITableView(frame: self.view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: kTableViewCellID)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

}

extension LXCategoryViewController {
    
    fileprivate func setupUI() {
        view.addSubview(tableView)
    }
    
}

extension LXCategoryViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kTableViewCellID, for: indexPath)
        cell.textLabel?.text = "\(categoryStr) 第\(indexPath.row)行"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
}
