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
        let refreshView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 60))
        refresher = Refresher(refreshView: refreshView, scrollView: tableView)
        refresher?.animateDuration = 1
        refresher?.delegate = self
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = "\(indexPath.row)"
        return cell
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
}

// MARK: RefresherDelegate
extension ViewController: RefresherDelegate {

    func updateRefreshView(refreshView: UIView, state: RefreshState, percent: Float) {
        switch state {
        case .stable:
            var red = CGFloat(percent)
            if red > 1 {
                red = 1
            } else if red < 0 {
                red = 0
            }
            refreshView.backgroundColor = UIColor(red: red, green: 0, blue: 0, alpha: 1)
        case .ready:
            refreshView.backgroundColor = UIColor.blue
        case .refreshing:
            refreshView.backgroundColor = UIColor.yellow
        }
    }

    func startRefreshing() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            self?.refresher?.finishRefreshing()
        }
    }
}
