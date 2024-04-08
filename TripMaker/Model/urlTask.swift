//
//  urlTask.swift
//  TripMaker
//
//  Created by Megan Lin on 3/19/24.
//

import Foundation
import UIKit

struct ImageInfo: Codable {
    let urls: Urls
}

struct Urls: Codable {
    let raw: String
    var rawUrl: URL {
        return URL(string: raw)!
    }
}

struct WikipediaResponse: Decodable {
    let extract: String
}

@Observable
class ModelData {
    var finished = false
    let db: DBManager
    var image: String?
    
//    var httpString = "https://api.unsplash.com/photos/random?query=taipei/600x600"
    let baseURL = "https://api.unsplash.com/photos/random?query="
    var locationName = "Taipei101"
    let imageSize = "/600x600"
        
    var httpString: String {
        return baseURL + locationName + imageSize
    }
    
    let authString = "pPxiEaowEXFSgmLexE1QbvWaDL2AegFje6OHZbv9aHA"
    
    let wikiBaseURL = "https://en.wikipedia.org/api/rest_v1/page/summary/"
    
    var locationDescription = ""
    
    
//    let authString = "aTMxKAZwBPS8eLOk2WRJFJMSCkTX5_zxTGiHmuhEHG0"
    
    init() {
        db = DBManager.shared
        
        fetchLocationDescription(for: "Taipei 101")
        
        download(urlString: httpString) { [weak self] imageString in
            guard let self = self, let imageString = imageString else {
                print("Failed to download image.")
                return
            }
            
            DispatchQueue.main.async {
                self.image = imageString
                
                do {
                    try self.db.updateLocatioPicDescrip(name: "Taipei 101", newRealPicture: self.image!, newDescription: self.locationDescription)
                    
                    //print("Location added with name: \(self.locationName)")
                } catch {
                    print("Database operation error: \(error)")
                }
                
                self.finished = true
            }
        }
        
    }

    func download(urlString: String, completion: @escaping (String?) -> Void) {
        guard let url = URL(string: urlString) else {
            print("Invalid URL.")
            completion(nil)
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Client-ID \(authString)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error occurred during download: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("Invalid response from server.")
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("No data received from server.")
                completion(nil)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let picInfo = try decoder.decode(ImageInfo.self, from: data)
                URLSession.shared.dataTask(with: picInfo.urls.rawUrl) { locData, locResponse, locError in
                    if let locError = locError {
                        print("Error occurred during image download: \(locError.localizedDescription)")
                        completion(nil)
                        return
                    }
                    
                    guard let locData = locData, let image = UIImage(data: locData) else {
                        print("Failed to convert image data.")
                        completion(nil)
                        return
                    }
                    
                    let imageString = stringFromImage(image)
                    completion(imageString)
                }.resume()
            } catch {
                print("Error during JSON serialization: \(error.localizedDescription)")
                completion(nil)
            }
        }.resume()
    }
    
    func fetchLocationDescription(for title: String) {
        let formattedTitle = title.replacingOccurrences(of: " ", with: "_")
        let entireUrl = wikiBaseURL + formattedTitle
        
        guard let url = URL(string: entireUrl) else {
            print("Invalid URL.")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error occurred during download: \(error.localizedDescription)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("Invalid response from server.")
                return
            }
            
            guard let data = data else {
                print("No data received from server.")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let wikiResponse = try decoder.decode(WikipediaResponse.self, from: data)
                let sentencesArray = wikiResponse.extract.components(separatedBy: ". ").prefix(3)
                var sentences = sentencesArray.joined(separator: ". ")
                if let lastSentence = sentencesArray.last, !lastSentence.hasSuffix(".") {
                    sentences += "."
                }
                
                self.locationDescription = sentences
                
                print("\nDescription for \(title):")
                print(sentences)
            } catch {
                print("Error during decode JSON: \(error.localizedDescription)")
            }
        }
        task.resume()
    }
    
}
