//
//  NavigationTableViewController.swift
//  Strategic Marketing Planner
//
//  Created by Christopher Thiebaut on 3/26/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import UIKit

protocol NavigationTableViewControllerDelegate: class {
    func destinationSelected(_ destination: UIViewController)
}

class NavigationTableViewController: UITableViewController {
    
    var destinations: [(name: String, viewController: UIViewController)] = []
    weak var delegate: NavigationTableViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return destinations.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PresentationNavigationCell", for: indexPath)

        // Configure the cell...
        let destination = destinations[indexPath.row]
        cell.textLabel?.text = destination.name

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath){
            cell.contentView.backgroundColor = .white
        }
        let destination = destinations[indexPath.row].viewController
        delegate?.destinationSelected(destination)
    }

}
