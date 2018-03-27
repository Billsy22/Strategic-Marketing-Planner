//
//  ClientListTableViewController.swift
//  Strategic Marketing Planner
//
//  Created by Steven Brown on 3/26/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import UIKit

class ClientListTableViewController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var isSearchActive: Bool = false
    var filteredClients:[Client] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formatNavigationBar()
        updateViews()
        searchBar.delegate = self
        tableView.reloadData()
    }
    
    func updateViews() {
        filteredClients = ClientController.shared.clients
    }
    
    func formatNavigationBar() {
        navigationController?.navigationBar.barTintColor = .brandBlue
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
    }
    
    // MARK: UISearchbar delegate
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isSearchActive = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        isSearchActive = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        isSearchActive = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        isSearchActive = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            isSearchActive = false
            tableView.reloadData()
        } else {
            isSearchActive = true
            print(searchBar.text)
            tableView.reloadData()
        }
    }
    
    func updateClientSearch() {
        
    }
    
    // MARK: - Table view data source
    
    //    override func numberOfSections(in tableView: UITableView) -> Int {
    //        return 0
    //    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredClients.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "clientCell", for: indexPath) as? ClientTableViewCell else { return UITableViewCell() }
        let client = filteredClients[indexPath.row]
        cell.client = client
        return cell
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let client = filteredClients[indexPath.row]
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
            let client = filteredClients[indexPath.row]
            addClientVC?.client = client
        }
    }
}

