//
//  NetworkService.swift
//  Diploma
//
//  Created by DmitriiG on 23.08.2023.
//

import Foundation
import UIKit

struct NetworkService {
    
    enum Urls: String {
        case url1 = "https://dog.ceo/api/breeds/image/random"
        case url2 = "https://randomuser.me/api/"
        case url3 = "https://official-joke-api.appspot.com/random_joke"
        var url: URL? { URL(string: self.rawValue)}
    }
    
    static func requestForAvatar (url: URL, completion: @escaping (UIImage) -> Void) {
        
        let configForSession = URLSessionConfiguration.default
        configForSession.waitsForConnectivity = true
        let urlSession = URLSession(configuration: configForSession)
        
        let taskForImage  = urlSession.dataTask(with: url) { data, response, error in
            guard error == nil else {
                return
            }
            guard let data = data else {
                return
            }
            
            guard let image = UIImage(data: data) else { return }
            completion(image)
            
        }
        taskForImage.resume()
    }
  
    
    static func request (completionForImage: @escaping (ImageForAvatar) -> Void,  completionForData: @escaping (Profile) -> Void, completionForDesctription: @escaping (Description) -> Void) {
        
       
        let configForSession = URLSessionConfiguration.default
        configForSession.waitsForConnectivity = true
        let urlSession = URLSession(configuration: configForSession)

        let taskForImage  = urlSession.dataTask(with: Urls.url1.url!) { data, response, error in
            guard error == nil else {
                return
            }
            guard let data = data else {
                return
            }
            do {
                let decoder = JSONDecoder()
                let message = try decoder.decode(ImageForAvatar.self, from: data)
                completionForImage(message)
                
            } catch {
                return
            }
            
        }
        let taskForData = urlSession.dataTask(with: Urls.url2.url!) { data, response, error in
            guard error == nil else {
                return
            }
            guard let data = data else {
                return
            }
            do {
                let decoder = JSONDecoder()
                let profile = try decoder.decode(Profile.self, from: data)
                completionForData(profile)
                
            } catch {
                return
            }
            
        }
 
        let taskForDescription  = urlSession.dataTask(with: Urls.url3.url!) { data, response, error in
            guard error == nil else {
                return
            }
            guard let data = data else {
                return
            }
            do {
                let decoder = JSONDecoder()
                let description = try decoder.decode(Description.self, from: data)
                completionForDesctription(description)
                
            } catch {
                return
            }
            
        }
        taskForImage.resume()
        taskForData.resume()
        taskForDescription.resume()
    }
    
    static func requestForAvatar (completionForData: @escaping (Profile) -> Void) {
        
        let configForSession = URLSessionConfiguration.default
        configForSession.waitsForConnectivity = true
        let urlSession = URLSession(configuration: configForSession)
       
        let taskForData = urlSession.dataTask(with: Urls.url2.url!) { data, response, error in
            guard error == nil else {
                return
            }
            guard let data = data else {
                return
            }
            do {
                let decoder = JSONDecoder()
                let profile = try decoder.decode(Profile.self, from: data)
                completionForData(profile)
                
            } catch {
                return
            }
            
        }
      
        taskForData.resume()
    }
    
    static func loadImage(linkAvatar: String?, linkImage: String?, completion: (UIImage?, UIImage?)-> Void) {
           
            if let urlLinkForAvatar = linkAvatar, let urlLinkForImage = linkImage, let dataForAvatar = try? Data(contentsOf: URL(string: urlLinkForAvatar)!), let dataForImage = try? Data(contentsOf: URL(string: urlLinkForImage)!) {
                
                if let avatarFromURL = UIImage(data: dataForAvatar), let imageFromURL = UIImage(data: dataForImage) {
                        completion(avatarFromURL, imageFromURL)
                }
            }
        
    }
    
 
    
    
}
