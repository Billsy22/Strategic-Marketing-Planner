//
//  ClientListTableViewController.swift
//  Strategic Marketing Planner
//
//  Created by Steven Brown on 3/26/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import UIKit

class ClientListTableViewController: UITableViewController, UISearchBarDelegate, AddClientModalViewControllerDelegate {
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    var clients:[Client] = []
    var sortedFirstLetters: [String]  {
        let firstLetters = clients.map { $0.lastNameFirstLetter }
        let uniqueFirstLetters = Array(Set(firstLetters))
        return uniqueFirstLetters.sorted()
    }
    var sections:[[Client]] {
        let sections =  sortedFirstLetters.map { firstLetter in
            return clients
                .filter { $0.lastNameFirstLetter == firstLetter }
                .sorted { $0.lastName ?? "" < $1.lastName  ?? "" }
        }
        return sections
    }
    
    func clientAdded() {
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formatNavigationBar()
        updateViews()
        guard let addClientVC = childViewControllers.first as? AddClientModalViewController else { return }
        addClientVC.delegate = self
        searchBar.delegate = self
        tableView.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    func updateViews() {
        clients = ClientController.shared.clients
    }
    
    func formatNavigationBar() {
        navigationController?.navigationBar.barTintColor = .brandBlue
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
    }
    
    // MARK: UISearchbar delegate
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            clients = ClientController.shared.clients
            tableView.reloadData()
        } else {
            guard let searchString = searchBar.text else { return }
            updateClientSearch(searchString: searchString)
        }
    }
    
    func updateClientSearch(searchString: String) {
        let filteredClients = ClientController.shared.clients.filter({ $0.matches(searchString: searchString) })
        self.clients = filteredClients
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return sortedFirstLetters
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sortedFirstLetters[section]
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "clientCell", for: indexPath) as? ClientTableViewCell else { return UITableViewCell() }
        let client = sections[indexPath.section][indexPath.row]
        cell.client = client
        return cell
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let client = sections[indexPath.section][indexPath.row]
            ClientController.shared.removeClient(client)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toClientDetail",
            let indexPath = tableView.indexPathForSelectedRow {
            let detailVC = segue.destination as? UINavigationController
            let addClientVC = detailVC?.viewControllers.first as? AddClientModalViewController
            let client = clients[indexPath.row]
            addClientVC?.client = client
        }
    }
}

extension Client {
    var lastNameFirstLetter: String {
        guard let lastName = lastName,
        let firstCharacter = lastName.first else { return "" }
        return String(firstCharacter).uppercased()
//        return String(lastName[lastName.startIndex]).uppercased()
    }
}

