//
//  ViewController.swift
//
//  Created by Yu Tamura on 2016/06/05.
//  Copyright © 2016 Yu Tamura. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    var refresher: Refresher?

    override func viewDidLoad() {
        super.viewDidLoad()
        let refreshView = UIView(frame: CGRectMake(0, 0, view.frame.size.width, 60))
        refresher = Refresher(refreshView: refreshView, scrollView: tableView)
        refresher?.delegate = self
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        cell.textLabel?.text = NSNumber(integer: indexPath.row).stringValue
        return cell
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }

    override func scrollViewDidScroll(scrollView: UIScrollView) {
        refresher?.didScroll(scrollView)
    }

    override func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        refresher?.didEndDragging(scrollView)
    }
}

// MARK: RefresherDelegate
extension ViewController: RefresherDelegate {
    func updateRefreshView(refreshView: UIView, state: RefreshState, percent: Float) {
        switch state {
        case .Normal:
            var red = CGFloat(percent)
            if red > 1 {
                red = 1
            } else if red < 0 {
                red = 0
            }
            refreshView.backgroundColor = UIColor(red: red, green: 0, blue: 0, alpha: 1)
        case .Ready:
            refreshView.backgroundColor = UIColor.blueColor()
        case .Refreshing:
            refreshView.backgroundColor = UIColor.yellowColor()
            let delay = 3.0 * Double(NSEC_PER_SEC)
            let time  = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
            dispatch_after(time, dispatch_get_main_queue()) { [weak self] in
                self?.refresher?.finishRefreshing()
            }
        }
    }
}
