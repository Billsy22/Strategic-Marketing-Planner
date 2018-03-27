//
//  NavigationTableViewController.swift
//  Strategic Marketing Planner
//
//  Created by Christopher Thiebaut on 3/26/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import UIKit

protocol PresentationBaseViewControllerNavigationPaneDelegate: class {
    func selectedDestinationAtIndex(_ index: Int)
}

class NavigationTableViewController: UITableViewController {
    
    var destinations: [String] = []
    weak var delegate: PresentationBaseViewControllerNavigationPaneDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
        tableView(tableView, didSelectRowAt: IndexPath(row: 0, section: 0))
        tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .none)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return destinations.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PresentationNavigationCell", for: indexPath)

        // Configure the cell...
        let destination = destinations[indexPath.row]
        cell.textLabel?.text = destination
        cell.backgroundColor = UIColor.brandPaleBlue
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath){
            cell.backgroundColor = .white
        }
        delegate?.selectedDestinationAtIndex(indexPath.row)
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        cell.backgroundColor = UIColor.brandPaleBlue
    }

}

extension NavigationTableViewController: PresentationBaseViewControllerNavigationPane {
    
    func requestMoveToDestination(index: Int) {
        if let selectedRows = tableView.indexPathsForSelectedRows {
            for row in selectedRows {
                tableView(tableView, didDeselectRowAt: row)
            }
        }
        tableView(tableView, didSelectRowAt: IndexPath(row: index, section: 0))
        tableView.selectRow(at: IndexPath(row: index, section: 0), animated: true, scrollPosition: .none)
    }
}
