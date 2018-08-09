//
//  EntryDetailViewController.swift
//  ios-journal-REST
//
//  Created by De MicheliStefano on 09.08.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - Methods
    
    @IBAction func save(_ sender: Any) {
//        let entry = Entry(title: "My second entry", bodyText: "A beautiful entry")
//        entryController.put(entry: entry) { (error) in
//            if let error = error {
//                NSLog("Error fetching data: \(error)")
//                return
//            }
//
//            DispatchQueue.main.async {
//                self.tableView.reloadData()
//            }
//        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    // MARK: - Properties
    
    var entry: Entry?
    var entryController: EntryController?
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    

}
