//
//  ClientListTableViewController.swift
//  Strategic Marketing Planner
//
//  Created by Steven Brown on 3/26/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import UIKit

class ClientListTableViewController: UITableViewController, UISearchBarDelegate, ClientControllerDelegate, AddClientDelegate {
    
    // MARK: - Properties
    @IBOutlet weak var searchBar: UISearchBar!
    var clients:[Client] = []
    let clientController = ClientController.shared
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formatNavigationBar()
        updateViews()
        clientController.delegate = self
        searchBar.delegate = self
        tableView.reloadData()
    }
    
    func clientsUpdated() {
        clients = clientController.clients
        tableView.reloadData()
    }
    
    func updateViews() {
        clients = clientController.clients
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
            clients = clientController.clients
            tableView.reloadData()
        } else {
            guard let searchString = searchBar.text else { return }
            updateClientSearch(searchString: searchString)
        }
    }
    
    func updateClientSearch(searchString: String) {
        let filteredClients = clientController.clients.filter({ $0.matches(searchString: searchString) })
        self.clients = filteredClients
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        if clients.count == 0 {
            return nil
        } else {
            return sortedFirstLetters
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if clients.count == 0 {
            return nil
        } else {
            return sortedFirstLetters[section]
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if clients.count == 0 {
            return 1
        } else {
            return sections.count
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if clients.count == 0 {
            return 1
        } else {
            return sections[section].count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if clients.count == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "noClientsCell") as? NoClientsTableViewCell else { return UITableViewCell() }
            tableView.allowsSelection = false
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "clientCell", for: indexPath) as? ClientTableViewCell else { return UITableViewCell() }
            let client = sections[indexPath.section][indexPath.row]
            cell.client = client
            tableView.allowsSelection = true
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if clients.count == 0 {
            tableView.isScrollEnabled = false
            return tableView.frame.height
        } else {
            tableView.isScrollEnabled = true
            return 41
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let cell = tableView.cellForRow(at: indexPath)
        if cell is NoClientsTableViewCell {
            return false
        } else {
            return true
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                let client = sections[indexPath.section][indexPath.row]
                deleteConfirmation(client: client)
                //       tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toClientDetail",
            let indexPath = tableView.indexPathForSelectedRow {
            let detailVC = segue.destination as? UINavigationController
            let addClientVC = detailVC?.viewControllers.first as? AddClientModalViewController
            let client = sections[indexPath.section][indexPath.row]
            addClientVC?.client = client
            addClientVC?.delegate = self
        } else if segue.identifier == "toAddClient" {
            let detailVC = segue.destination as? UINavigationController
            let addClientVC = detailVC?.viewControllers.first as? AddClientModalViewController
            addClientVC?.delegate = self
        }
    }
    
    func presentationStarting() {
        tabBarController?.selectedIndex = 1
    }
    
    // MARK: - Alerts
    //Create a delete confirmation alert when swiping to delete
    func deleteConfirmation(client: Client) {
        let deleteConfirmationAlert = UIAlertController(title: "Delete Client", message: "Are you sure you want to delete this client?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
            print("Action Cancelled")
        })
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (action) in
            self.clientController.removeClient(client)
            print("Client Deleted")
        }
        deleteConfirmationAlert.addAction(cancelAction)
        deleteConfirmationAlert.addAction(deleteAction)
        self.present(deleteConfirmationAlert, animated: true, completion: nil)
    }
}

extension Client {
    var lastNameFirstLetter: String {
        guard let lastName = lastName,
            let firstCharacter = lastName.first else { return "" }
        return String(firstCharacter).uppercased()
    }
}

