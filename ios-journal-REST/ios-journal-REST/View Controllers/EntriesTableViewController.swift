//
//  EntriesTableViewController.swift
//  ios-journal-REST
//
//  Created by De MicheliStefano on 09.08.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import UIKit

class EntriesTableViewController: UITableViewController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return journal?.entries.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath) as? EntryTableViewCell,
            let journal = journal else { fatalError("Something really really bad happened") }
        
        cell.entry = journal.entries[indexPath.row]

        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let entryController = entryController,
                let journal = journal else { return }
            
            let entry = journal.entries[indexPath.row]
            entryController.delete(journal: journal, entry: entry) { (error) in
                if let error = error {
                    NSLog("Error deleting data: \(error)")
                    return
                }
                
                DispatchQueue.main.async {
                    self.tableView.deleteRows(at: [indexPath], with: .fade)
                }
            }
        }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowAddNewEntryDetail" {
            guard let addNewEntryVC = segue.destination as? EntryDetailViewController,
                let entryController = entryController,
                let journal = journal else { return }
            
            addNewEntryVC.entryController = entryController
            addNewEntryVC.journal = journal
            
        } else if segue.identifier == "ShowEntryDetail" {
            guard let detailVC = segue.destination as? EntryDetailViewController,
                let indexPath = tableView.indexPathForSelectedRow,
                let entryController = entryController,
                let journal = journal else { return }
            
            let entry = journal.entries[indexPath.row]
            detailVC.entryController = entryController
            detailVC.entry = entry
        }
    }
    
    var journal: Journal?
    var entryController: EntryController?

}
