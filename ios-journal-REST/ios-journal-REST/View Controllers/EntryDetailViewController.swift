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
        updateViews()
    }
    
    // MARK: - Methods
    
    @IBAction func save(_ sender: Any) {
        guard let title = titleTextField.text,
            let body = bodyTextView.text,
            let journal = journal else { return }
        
        if let entry = entry {
            entryController?.update(journal: journal, entry: entry, title: title, body: body, completion: { (error) in
                if let error = error {
                    NSLog("Error updating entry: \(error)")
                    return
                }
                
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            })
        } else {
            entryController?.createEntry(with: title, body: body, in: journal, completion: { (error) in
                if let error = error {
                    NSLog("Error creating entry: \(error)")
                    return
                }
                
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            })
        }
    }
    
    private func updateViews() {
        if self.isViewLoaded {
            if let entry = entry {
                title = entry.title
                titleTextField.text = entry.title
                bodyTextView.text = entry.bodyText
            }
            
            title = "Create Entry"
        }
    }
    
    // MARK: - Properties
    var journal: Journal? {
        didSet {
            updateViews()
        }
    }
    var entry: Journal.Entry? {
        didSet {
            updateViews()
        }
    }
    var entryController: EntryController?
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    

}
