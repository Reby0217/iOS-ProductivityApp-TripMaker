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
    let db: DBManager
    var image: String?
    
//    var httpString = "https://api.unsplash.com/photos/random?query=taipei/600x600"
    let baseURL = "https://api.unsplash.com/photos/random?query="
    var locationName = "Taipei101"
    let imageSize = "/600x600"
        
    var httpString: String {
        return baseURL + locationName + imageSize
    }
    
//    let authString = "pPxiEaowEXFSgmLexE1QbvWaDL2AegFje6OHZbv9aHA"
    
    let authString = "aTMxKAZwBPS8eLOk2WRJFJMSCkTX5_zxTGiHmuhEHG0"
    
//    init(){
//        db = DBManager.shared
//        
//        _ = download(urlString: httpString)
//        
//        do {
//            let map_taiwan = UIImage(named: "taiwan-attractions-map.jpg")
//            let routeID = try db.addRoute(name: "Taiwan", mapPicture: stringFromImage(map_taiwan!))
//            print("route added \(routeID)")
//            if self.image != nil {
//                var locationID = try db.addLocationToRoute(routeID: routeID, name: "Taipei 101", realPicture: self.image!, description: "", isLocked: false)
//                print("location added \(locationID)")
//            }
//        } catch {
//            print("error")
//        }
//        
//
//    }
    
    init() {
        db = DBManager.shared
        
        // Initiating the download with a completion handler
        download(urlString: httpString) { imageString in
            guard let imageString = imageString else {
                print("Failed to download image.")
                return
            }
            
            DispatchQueue.main.async {
                self.image = imageString
                
                do {
                    if let map_taiwan = UIImage(named: "taiwan-attractions-map.jpg") {
                        let mapPictureString = stringFromImage(map_taiwan)
                        let routeID = try self.db.addRoute(name: "Taiwan", mapPicture: mapPictureString)
                        print("Route added with ID: \(routeID)")
                        
                        let locationID = try self.db.addLocationToRoute(routeID: routeID, name: "Taipei 101", realPicture: imageString, description: "Description for Taipei 101", isLocked: false)
                        print("Location added with ID: \(locationID)")
                    }
                } catch {
                    print("Database operation error: \(error)")
                }
            }
        }
    }


    
//    func download(urlString: String) -> Bool {
//        
//        let url = URL(string: urlString)
//        var req = URLRequest(url: url!)
//        let session = URLSession.shared
//        
//        req.httpMethod = "GET"
//        req.setValue("Client-ID \(authString)", forHTTPHeaderField: "Authorization")
//        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        
//
//        session.downloadTask(with: req) { (data, response, error) in
//            if let error = error {
//                print("Error: \(error)")
//            }else if let response = response as? HTTPURLResponse, let data = data, let data_ = try? Data(contentsOf: data) {
//                print("Status Code: \(response.statusCode)")
//                do{
//                    let decoder = JSONDecoder()
//                    print(String(describing: data_))
//                    let picInfo = try decoder.decode(ImageInfo.self, from: data_)
//                    print(picInfo)
//                    session.downloadTask(with: picInfo.urls.rawUrl) {
//                        loc, resp, err in
//                        if let loc = loc, let d = try? Data(contentsOf: loc)
//                        {
//                            if let im = UIImage(data:d) {
//                                self.image = stringFromImage(im)
//                            }
//                        }
//                    }.resume()
//                } catch{
//                    print(error)
//                }
//            }
//        }.resume()
//        
//        return true
//    }
    
    
    func download(urlString: String, completion: @escaping (String?) -> Void) {
        guard let url = URL(string: urlString) else {
            print("Invalid URL.")
            completion(nil)
            return
        }
        var req = URLRequest(url: url)
        req.httpMethod = "GET"
        req.setValue("Client-ID \(authString)", forHTTPHeaderField: "Authorization")
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let session = URLSession.shared
        session.dataTask(with: req) { (data, response, error) in
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
                session.dataTask(with: picInfo.urls.rawUrl) { locData, locResponse, locError in
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

}
