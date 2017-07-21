//
//  TodayViewController.swift
//  widget
//
//  Created by ST20638 on 2017/07/11.
//  Copyright © 2017年 Paul Traylor. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UITableViewController, NCWidgetProviding {
    var widgets = [Widget]()

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return widgets.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let widget = widgets[indexPath.row]
        cell.textLabel?.text = widget.label
        cell.detailTextLabel?.text = widget.format()
        if widget.more == nil {
            cell.accessoryType = UITableViewCellAccessoryType.none
        } else {
            cell.accessoryType = UITableViewCellAccessoryType.detailButton
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let url = widgets[indexPath.row].more {
            extensionContext?.open(url, completionHandler: nil)
        }
    }

    func updateCounter() {
        self.tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        var _ = Timer.scheduledTimer(
            timeInterval: 1.0,
            target: self,
            selector: #selector(updateCounter),
            userInfo: nil,
            repeats: true
        )

        tableView.reloadData()
    }

    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        completionHandler(NCUpdateResult.newData)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let pinnedItems = ApplicationSettings.pinnedItems
        NSLog("Pinned items: \(pinnedItems)")

        widgets = fetchWidgets().filter {
            if pinnedItems.contains($0.id) {
                return true
            } else {
                return false
            }
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        preferredContentSize = tableView.contentSize
    }

}
