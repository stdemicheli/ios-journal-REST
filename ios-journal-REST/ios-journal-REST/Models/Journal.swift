//
//  Journal.swift
//  ios-journal-REST
//
//  Created by De MicheliStefano on 09.08.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import Foundation

class Journal: Codable, Equatable {
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let title = try container.decode(String.self, forKey: .title)
        let identifier = try container.decode(String.self, forKey: .identifier)
        let entryDicts = try container.decodeIfPresent([String : Entry].self, forKey: .entries)
        let entries = entryDicts?.compactMap({ $0.value }) ?? []
        self.title = title
        self.identifier = identifier
        self.entries = entries
    }
    
    init(title: String, identifier: String = UUID().uuidString, entries: [Journal.Entry] = []) {
        self.title = title
        self.identifier = identifier
        self.entries = entries
    }
    
    var title: String
    let identifier: String
    var entries: [Journal.Entry]
    
    struct Entry: Codable, Equatable {
        
        init(title: String, bodyText: String, timestamp: Date = Date(), identifier: String = UUID().uuidString) {
            self.title = title
            self.bodyText = bodyText
            self.timestamp = timestamp
            self.identifier = identifier
        }
        
        var title: String
        var bodyText: String
        var timestamp: Date
        let identifier: String
        
    }
    
    static func == (lhs: Journal, rhs: Journal) -> Bool {
        return lhs.title == rhs.title &&
            lhs.identifier == rhs.identifier
    }
    
}
