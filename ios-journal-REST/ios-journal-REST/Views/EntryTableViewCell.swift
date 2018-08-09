//
//  EntryTableViewCell.swift
//  ios-journal-REST
//
//  Created by De MicheliStefano on 09.08.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {

    
    // MARK: - Methods
    
    func updateViews() {
        guard let entry = entry else { return }
        titleTextLabel?.text = entry.title
        bodyTextLabel?.text = entry.bodyText
        timestampTextLabel?.text = convertDateToString(with: entry.timestamp)
    }
    
    private func convertDateToString(with date: Date) -> String {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd hh:mm"
        return df.string(from: date)
    }
    
    // MARK: - Properties
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    
    @IBOutlet weak var titleTextLabel: UILabel!
    @IBOutlet weak var bodyTextLabel: UILabel!
    @IBOutlet weak var timestampTextLabel: UILabel!
    
}
