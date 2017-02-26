//
//  Refresher.swift
//
//  Created by Yu Tamura on 2016/06/05.
//  Copyright © 2016 Yu Tamura. All rights reserved.
//

import UIKit

@objc public enum RefreshState: Int {

    case stable, refreshing, ready
}

@objc public protocol RefresherDelegate {
    /// Notice current refresh state.
    /// - parameter refreshView: A view for display refresh state.
    /// - parameter state: Current refreesh state.
    /// - parameter percent: Percent of reached refresh threshold.
    func updateRefreshView(refreshView: UIView, state: RefreshState, percent: Float)

    /// Notify refresh timing.
    func startRefreshing()
}

final public class Refresher: NSObject {

    private let refreshView: UIView

    private let scrollView: UIScrollView

    public weak var delegate: RefresherDelegate?

    public private(set) var state: RefreshState = .stable {
        didSet (oldValue) {
            let percent = Float(-scrollView.contentOffset.y / refreshView.frame.height)
            delegate?.updateRefreshView(refreshView: refreshView, state: state, percent: percent)

            if oldValue != .refreshing && state == .refreshing {
                delegate?.startRefreshing()
            }
        }
    }

    public var animateDuration: TimeInterval = 0.3

    private var isDragging = false

    public init(refreshView: UIView, scrollView: UIScrollView) {
        refreshView.frame = CGRect(x: 0, y: -refreshView.frame.height, width: scrollView.frame.width, height: refreshView.frame.height)
        scrollView.addSubview(refreshView)

        self.refreshView = refreshView
        self.scrollView = scrollView

        super.init()
        scrollView.addObserver(self, forKeyPath: "contentOffset", options: [.new], context: nil)
    }

    deinit {
        scrollView.removeObserver(self, forKeyPath: "contentOffset")
    }

    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard  let scrollView = object as? UIScrollView else {
            return
        }

        if isDragging && !scrollView.isDragging {
            didEndDragging()
        }
        isDragging = scrollView.isDragging

        didScroll()
    }

    private func didScroll() {
        let height = refreshView.frame.height
        let offsetY = scrollView.contentOffset.y

        switch state {
        case .stable:
            // Switch state if below threshold
            state = (height < -offsetY) ? .ready : .stable
        case .ready:
            // Switch state if above threshold
            state = (height > -offsetY) ? .stable : .ready
        case .refreshing:
            // Set contentInset to refreshView visible
            UIView.animate(withDuration: animateDuration) { [weak self] _ in
                self?.scrollView
                    .contentInset = UIEdgeInsetsMake(height, 0, 0, 0)
            }
        }
    }

    private func didEndDragging() {
        if state == .ready {
            // Start Refreshing
            state = .refreshing
        }
    }

    public func finishRefreshing() {
        // End Refreshing
        state = .stable
        UIView.animate(withDuration: animateDuration) {
            self.scrollView.contentInset = .zero
        }
    }
}
