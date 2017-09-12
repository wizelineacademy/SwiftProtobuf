//
//  NetworkService.swift
//  ProtobufTest
//
//  Created by Jorge R Ovalle Z on 8/3/17.
//  Copyright © 2017 Jorge R Ovalle Z. All rights reserved.
// 

import UIKit

struct demoURL {
    static let contacts = "http://protobuf-demo.wizeline.academy/api/contacts"
}

public enum Result<Value, Error: Swift.Error> {
    case success(Value)
    case error(Error)
    
    public init(value: Value) {
        self = .success(value)
    }
    
    public init(error: Error) {
        self = .error(error)
    }
}

public enum FetchError: Swift.Error {
    case parsing
    case network(Error)
}

class NetworkService {
    
    func fetch( completion: @escaping (Result<SearchResult, FetchError>)->Void) -> URLSessionDataTask? {
        guard let url = URL(string: demoURL.contacts) else { return nil }
        // Create Request
        let request = URLRequest(url: url)
        
        // Create Data Task
        let dataTask = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
            if let data = data {
                do {
                    let searchResult = try SearchResult(serializedData: data)
                    completion(.success(searchResult))
                }
                catch(_){
                    completion(.error(.parsing))
                }
            } else {
                error.flatMap { completion(Result.error(.network($0))) }
            }
        })
        
        dataTask.resume()
        return dataTask
    }
    
    
    func postContact(contact: Contact, completion: @escaping (Result<String, FetchError>)->Void) -> URLSessionDataTask? {
        guard let url = URL(string: demoURL.contacts) else { return nil }
        do {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/octet-stream", forHTTPHeaderField: "Content-Type")
            
            let binaryData: Data = try contact.serializedData()
            request.httpBody = binaryData
            
            
            let dataTask = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
                if (response as? HTTPURLResponse)?.statusCode == 200 {
                    completion(.success("Added"))
                } else {
                    error.flatMap { completion(Result.error(.network($0))) }
                }
            })
            
            dataTask.resume()
            return dataTask
        }
        catch(_) {
            completion(.error(.parsing))
            return nil
        }
    }
}
