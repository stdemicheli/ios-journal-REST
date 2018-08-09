//
//  JournalListTableViewController.swift
//  ios-journal-REST
//
//  Created by De MicheliStefano on 09.08.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import UIKit

class JournalListTableViewController: UITableViewController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        entryController.fetchJournals { (error) in
            if let error = error {
                NSLog("Error fetching journals: \(error)")
                return
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func createJournal(_ sender: Any) {
        guard let title = journalTextField.text else { return }
        
        entryController.createJournal(with: title) { (error) in
            if let error = error {
                NSLog("Error creating journal: \(error)")
                return
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entryController.journals.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JournalCell", for: indexPath)

        let journal = entryController.journals[indexPath.row]
        cell.textLabel?.text = journal.title

        return cell
    }


    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowJournalTableView" {
            guard let journalTVC = segue.destination as? EntriesTableViewController,
                let indexPath = tableView.indexPathForSelectedRow else { return }
            
            let journal = entryController.journals[indexPath.row]
            journalTVC.journal = journal
            journalTVC.entryController = entryController
        }
    }
    
    
    // MARK: - Properties
    
    let entryController = EntryController()
    
    @IBOutlet weak var journalTextField: UITextField!
    
}
