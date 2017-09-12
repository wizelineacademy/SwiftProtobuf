//
//  ContactsTableViewController.swift
//  ProtobufTest
//
//  Created by Jorge R Ovalle Z on 8/3/17.
//  Copyright © 2017 Jorge R Ovalle Z. All rights reserved.
//

import UIKit

final class ContactsTableViewController: UITableViewController {

    private var dataSet: SearchResult?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(reload), for: .valueChanged)
        getData()
    }
    
    func reload() {
        refreshControl?.beginRefreshing()
        getData()
    }
    
    private func getData(){
        let _ = NetworkService().fetch { [weak self] (result) in
            guard let `self` = self else { return }
            switch result {
            case .success(let ds):
                self.dataSet = ds
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.refreshControl?.endRefreshing()
                }
            case .error(let error):
                print("Error: \(error)")
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell"), let dataset = dataSet else {
            return UITableViewCell()
        }

        cell.textLabel?.text = dataset.contacts[indexPath.row].firstName + " " + dataset.contacts[indexPath.row].lastName
        if dataset.contacts[indexPath.row].phoneNumbers.count > 0 {
            cell.detailTextLabel?.text = dataset.contacts[indexPath.row].phoneNumbers[0].number
        } else {
            cell.detailTextLabel?.text = ""
        }
        
        return cell
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSet?.contacts.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let contact = dataSet?.contacts[indexPath.row]
        if let detailContactView = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DetailContactViewController") as? DetailContactViewController {
            detailContactView.contact = contact
            self.show(detailContactView, sender: nil)
        }
    }
}
