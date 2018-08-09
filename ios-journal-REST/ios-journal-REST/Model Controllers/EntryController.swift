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
    
    func createEntry(with title: String, body: String, completion: @escaping (Error?) -> Void) {
        let entry = Entry(title: title, bodyText: body)
        // Call put, and insert completion in the parameter: will forward the completion closure to the function caller
        put(entry: entry, completion: completion)
    }
    
    func update(entry: Entry, title: String, body: String, completion: @escaping (Error?) -> Void) {
        guard let index = entries.index(of: entry) else { return }
        var updatedEntry = entries[index]
        updatedEntry.title = title
        updatedEntry.bodyText = body
        updatedEntry.timestamp = Date()
        
        entries.remove(at: index)
        entries.insert(updatedEntry, at: index)
        
        put(entry: updatedEntry, completion: completion)
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
                let decodedEntriesDicts = try JSONDecoder().decode([String: Entry].self, from: data)
                self.entries = decodedEntriesDicts.map { $0.value }.sorted { $0.timestamp < $1.timestamp }
                completion(nil)
            } catch {
                NSLog("Error while decoding data: \(error)")
                completion(error)
                return
            }
        }.resume()
    }
    
    func delete(entry: Entry, completion: @escaping (Error?) -> Void) {
        let url = baseURL
            .appendingPathComponent(entry.identifier)
            .appendingPathExtension("json")
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.delete.rawValue
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error fetching data: \(error)")
                completion(error)
                return
            }
            
            guard let index = self.entries.index(of: entry) else { return }
            self.entries.remove(at: index)
            
            completion(nil)
        }.resume()
    }
    
    func put(entry: Entry, completion: @escaping (Error?) -> Void) {
        let url = baseURL
            .appendingPathComponent(entry.identifier)
            .appendingPathExtension("json")
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.put.rawValue
        
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
    
    // MARK: - Properties
    var entries: [Entry] = []
    let baseURL: URL = URL(string: "https://stefanojournal.firebaseio.com/")!
    
}
