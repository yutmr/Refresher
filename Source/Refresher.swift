//
//  Refresher.swift
//
//  Created by Yu Tamura on 2016/06/05.
//  Copyright © 2016 Yu Tamura. All rights reserved.
//

import UIKit

@objc enum RefreshState: Int {
    case Normal
    case Refreshing
    case Ready
}

@objc protocol RefresherDelegate: UIScrollViewDelegate {
    /// Notice current refresh state.
    /// - parameter refreshView: A view for display refresh state.
    /// - parameter state: Current refreesh state.
    /// - parameter percent: Percent of reached refresh threshold.
    func updateRefreshView(refreshView: UIView, state: RefreshState, percent: Float)

    /// Notify refresh timing.
    func startRefreshing()
}

class Refresher: NSObject {
    let refreshView: UIView
    let scrollView: UIScrollView
    weak var delegate: RefresherDelegate?
    var state: RefreshState = .Normal {
        didSet (oldValue) {
            let percent = Float(-scrollView.contentOffset.y / refreshView.frame.height)
            delegate?.updateRefreshView(refreshView: refreshView, state: state, percent: percent)

            if oldValue != .Refreshing && state == .Refreshing {
                delegate?.startRefreshing()
            }
        }
    }
    var animateDuration: TimeInterval = 0.3

    init(refreshView: UIView, scrollView: UIScrollView) {
        refreshView.frame = CGRect(x: 0, y: -refreshView.frame.height, width: scrollView.frame.width, height: refreshView.frame.height)
        scrollView.addSubview(refreshView)
        self.refreshView = refreshView
        self.scrollView = scrollView
    }

    func didScroll(scrollView: UIScrollView) {
        let height = refreshView.frame.height
        let offsetY = scrollView.contentOffset.y

        switch state {
        case .Normal:
            // Switch state if below threshold
            state = (height < -offsetY) ? .Ready : .Normal
        case .Ready:
            // Switch state if above threshold
            state = (height > -offsetY) ? .Normal : .Ready
        case .Refreshing:
            // Set contentInset to refreshView visible
            UIView.animate(withDuration: 0.3) {
                scrollView.contentInset = UIEdgeInsetsMake(height, 0, 0, 0)
            }
        }
    }

    func didEndDragging(scrollView: UIScrollView) {
        if state == .Ready {
            // Start Refreshing
            state = .Refreshing
        }
    }

    func finishRefreshing() {
        // End Refreshing
        state = .Normal
        UIView.animate(withDuration: animateDuration) {
            self.scrollView.contentInset = .zero
        }
    }
}
