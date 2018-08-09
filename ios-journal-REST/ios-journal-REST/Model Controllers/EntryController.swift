//
//  EntryController.swift
//  ios-journal-REST
//
//  Created by De MicheliStefano on 09.08.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import Foundation

class EntryController {
    
    private enum HTTPMethod: String {
        case get = "GET"
        case put = "PUT"
        case post = "POST"
        case delete = "DELETE"
    }
    
    // MARK: - Methods
    
    func createJournal(with title: String, completion: @escaping (Error?) -> Void) {
        let journal = Journal(title: title)
        put(journal: journal, entry: nil, completion: completion)
    }
    
    func createEntry(with title: String, body: String, in journal: Journal, completion: @escaping (Error?) -> Void) {
        let entry = Journal.Entry(title: title, bodyText: body)
        // Call put, and insert completion in the parameter: will forward the completion closure to the function caller
        put(journal: journal, entry: entry, completion: completion)
    }
    
    func update(journal: Journal, entry: Journal.Entry, title: String, body: String, completion: @escaping (Error?) -> Void) {
        
        guard let entryIndex = journal.entries.index(of: entry),
            let journalIndex = journals.index(of: journal) else { return }
        
        var updatedEntry = journal.entries[entryIndex]
        updatedEntry.title = title
        updatedEntry.bodyText = body
        updatedEntry.timestamp = Date()
        
        journals.remove(at: journalIndex)
        journals.insert(journal, at: journalIndex)
        
        put(journal: journal, entry: nil, completion: completion)
    }
    
    func fetchJournals(completion: @escaping (Error?) -> Void) {
        let url = baseURL.appendingPathExtension("json")
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get.rawValue
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error fetching data: \(error)")
                completion(error)
                return
            }
            
            guard let data = data else {
                NSLog("Error fetching data")
                completion(NSError())
                return
            }
            
            do {
                // Would need to be changed to decode([String: Entry].self, ...)
                let decodedEntriesDicts = try JSONDecoder().decode([String : Journal].self, from: data)
                self.journals = decodedEntriesDicts.map { $0.value }
                completion(nil)
            } catch {
                NSLog("Error while decoding data: \(error)")
                completion(error)
                return
            }
            }.resume()
    }
    
    func fetchEntries(completion: @escaping (Error?) -> Void) {
        let url = baseURL.appendingPathExtension("json")
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get.rawValue
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error fetching data: \(error)")
                completion(error)
                return
            }
            
            guard let data = data else {
                NSLog("Error fetching data")
                completion(NSError())
                return
            }
            
            do {
                // Would need to be changed to decode([String: Entry].self, ...)
                let decodedEntriesDicts = try JSONDecoder().decode([String: [String: Entry]].self, from: data).values
                self.entries = decodedEntriesDicts.flatMap { $0.values }
                completion(nil)
            } catch {
                NSLog("Error while decoding data: \(error)")
                completion(error)
                return
            }
        }.resume()
    }
    
    func delete(journal: Journal, entry: Journal.Entry?, completion: @escaping (Error?) -> Void) {
        let url: URL
        
        if let entry = entry {
            url = baseURL
                .appendingPathComponent(journal.identifier)
                .appendingPathComponent("entries")
                .appendingPathComponent(entry.identifier)
                .appendingPathExtension("json")
        } else {
            url = baseURL
                .appendingPathComponent(journal.identifier)
                .appendingPathExtension("json")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.delete.rawValue
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error fetching data: \(error)")
                completion(error)
                return
            }
            
            if let entry = entry {
                guard let journalIndex = self.journals.index(of: journal) else { return }
                guard let entryIndex = self.journals[journalIndex].entries.index(of: entry) else { return }
                self.journals[journalIndex].entries.remove(at: entryIndex)
            } else {
                guard let journalIndex = self.journals.index(of: journal) else { return }
                self.journals.remove(at: journalIndex)
            }
            
            
            completion(nil)
        }.resume()
    }
    
    // TODO: Acommodate for posting journals
    func post(entry: Entry, completion: @escaping (Error?) -> Void) {
        let url = baseURL
            .appendingPathComponent(entry.identifier)
            .appendingPathExtension("json")
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        
        do {
            let encodedEntry = try JSONEncoder().encode(entry)
            request.httpBody = encodedEntry
        } catch {
            NSLog("Error while encoding data for \(entry): \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error fetching data: \(error)")
                completion(error)
                return
            }
            
            completion(nil)
        }.resume()
    }
    
    func put(journal: Journal, entry: Journal.Entry?, completion: @escaping (Error?) -> Void) {
        let url: URL
        
        if let entry = entry {
            url = baseURL
                .appendingPathComponent(journal.identifier)
                .appendingPathComponent("entries")
                .appendingPathComponent(entry.identifier)
                .appendingPathExtension("json")
        } else {
            url = baseURL
                .appendingPathComponent(journal.identifier)
                .appendingPathExtension("json")
        }
        
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.put.rawValue
        
        do {
            let encodedEntry = try JSONEncoder().encode(journal)
            request.httpBody = encodedEntry
        } catch {
            NSLog("Error while encoding data for: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error fetching data: \(error)")
                completion(error)
                return
            }
            
            completion(nil)
        }.resume()
    }
    
    // MARK: - Properties
    var journals: [Journal] = []
    var entries: [Entry] = []
    let baseURL: URL = URL(string: "https://stefanojournal.firebaseio.com/")!
    
}
