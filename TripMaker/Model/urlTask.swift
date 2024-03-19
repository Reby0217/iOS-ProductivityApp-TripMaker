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

@Observable
class ModelData {
    var image: String = ""
    
    var httpString = "https://api.unsplash.com/photos/random?query=taipei101"
    let authString = "pPxiEaowEXFSgmLexE1QbvWaDL2AegFje6OHZbv9aHA"
    
    init(){
        _ = download(urlString: httpString)
    }
    
    func download(urlString: String) -> Bool {
        
        let url = URL(string: urlString)
        var req = URLRequest(url: url!)
        let session = URLSession.shared
        
        req.httpMethod = "GET"
        req.setValue("Client-ID \(authString)", forHTTPHeaderField: "Authorization")
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        

        session.downloadTask(with: req) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
            }else if let response = response as? HTTPURLResponse, let data = data, let data_ = try? Data(contentsOf: data) {
                print("Status Code: \(response.statusCode)")
                do{
                    let decoder = JSONDecoder()
                    print(String(describing: data_))
                    let picInfo = try decoder.decode(ImageInfo.self, from: data_)
                    print(picInfo)
                    session.downloadTask(with: picInfo.urls.rawUrl) {
                        loc, resp, err in
                        if let loc = loc, let d = try? Data(contentsOf: loc)
                        {
                            if let im = UIImage(data:d) {
                                self.image = stringFromImage(im)
                            }
                        }
                    }.resume()
                }catch{
                    print(error)
                }
            }
        }.resume()
        
        return true
    }
}

