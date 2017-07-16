//
//  LXSegmentBar.swift
//  LXScrollContentView
//
//  Created by 刘行 on 2017/4/28.
//  Copyright © 2017年 刘行. All rights reserved.
//

import UIKit

@objc protocol LXSegmentBarDelegate {
    @objc optional func segmentBar(_ segmentBar: LXSegmentBar, selectedIndex: Int)
}

public class LXSegmentBar: UIView {
    
    weak var delegate : LXSegmentBarDelegate?
    
    var titles : [String] = [String](){
        didSet{
            for titleLabel in titleLabels {
                titleLabel.removeFromSuperview()
            }
            titleLabels.removeAll()
            for title in titles {
                let label = UILabel()
                label.backgroundColor = self.style.backgroundColor
                label.tag = 888 + titleLabels.count
                label.text = title
                label.textAlignment = .center
                label.font = style.titleFont
                label.isUserInteractionEnabled = true
                let tapGes = UITapGestureRecognizer(target: self, action: #selector(labelTapClick(_:)))
                label.addGestureRecognizer(tapGes)
                label.textColor = self.selectedIndex == titleLabels.count ? self.style.selectedTitleColor : self.style.normalTitleColor
                self.scrollView.addSubview(label)
                titleLabels.append(label)
            }
            self.setNeedsLayout()
            self.layoutIfNeeded()
        }
    }
    
    var selectedIndex : Int = 0 {
        didSet{
            guard oldValue != selectedIndex && selectedIndex >= 0 && selectedIndex < self.titleLabels.count else {
                return
            }
            let oldSelectedLabel = self.titleLabels[oldValue];
            let newSelectedLabel = self.titleLabels[selectedIndex]
            oldSelectedLabel.textColor = self.style.normalTitleColor
            newSelectedLabel.textColor = self.style.selectedTitleColor
            self.setupIndicatorFrame(animated: true)
        }
    }
    
    fileprivate lazy var scrollView : UIScrollView = {
        let scrollView = UIScrollView(frame: self.bounds)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.scrollsToTop = false
        scrollView.bounces = false
        return scrollView
    }()
    
    fileprivate lazy var titleLabels : [UILabel] = {
        let titleLabels = [UILabel]()
        return titleLabels
    }()
    
    fileprivate lazy var indicatorView : UIView = {
        let indicatorView = UIView()
        indicatorView.backgroundColor = self.style.indicatorColor
        return indicatorView
    }()
    
    fileprivate var style : LXSegmentBarStyle
    
    init(frame: CGRect, style: LXSegmentBarStyle) {
        self.style = style
        super.init(frame: frame)
        setupUI()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        guard titleLabels.count > 0 else {
            return
        }
        scrollView.bringSubview(toFront: indicatorView)
        scrollView.frame = bounds
        
        var totalLabelWidth : CGFloat = 0
        for label in titleLabels {
            label.sizeToFit()
            totalLabelWidth += label.bounds.width
        }
        
        var itemMargin = (bounds.width - totalLabelWidth) / CGFloat(titleLabels.count)
        if itemMargin < style.itemMinMargin {
            itemMargin = style.itemMinMargin
        }
        
        var startX : CGFloat = 0
        for label in titleLabels {
            label.frame = CGRect(x: startX, y: 0, width: label.bounds.width + itemMargin, height: bounds.height)
            startX += label.bounds.width
        }
        
        scrollView.contentSize = CGSize(width: startX, height: scrollView.bounds.size.height)
        setupIndicatorFrame(animated: false)
    }

}

extension LXSegmentBar {
    
    fileprivate func setupUI(){
        addSubview(scrollView)
        scrollView.addSubview(indicatorView)
    }
    
    fileprivate func setupIndicatorFrame(animated: Bool) {
        let selectedLabel = titleLabels[selectedIndex]
        UIView.animate(withDuration: 0.1, animations: {
            self.indicatorView.frame = CGRect(x: selectedLabel.frame.origin.x, y: self.bounds.height - self.style.indicatorHeight - self.style.indicatorBottomMargin, width: selectedLabel.bounds.width, height: self.style.indicatorHeight)
        }) { (_) in
            self.scrollRectToVisibleCenter(animated: animated)
        }
    }
    
    fileprivate func scrollRectToVisibleCenter(animated: Bool) {
        let selectedLabel = titleLabels[selectedIndex]
        scrollView.scrollRectToVisible(CGRect(x: selectedLabel.center.x - scrollView.bounds.width / 2.0, y: 0, width: scrollView.frame.size.width, height: scrollView.frame.size.height), animated: animated)
    }
}

extension LXSegmentBar {
    @objc fileprivate func labelTapClick(_ tap: UITapGestureRecognizer) {
        let selectedLabel = tap.view as! UILabel
        selectedIndex = selectedLabel.tag - 888
        delegate?.segmentBar?(self, selectedIndex: selectedIndex)
    }
}
