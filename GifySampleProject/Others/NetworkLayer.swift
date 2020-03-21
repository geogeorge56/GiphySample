//
//  NetworkLayer.swift
//  GifySampleProject
//
//  Created by user on 13/02/20.
//  Copyright © 2020 user. All rights reserved.
//

import UIKit

class NetworkLayer: NSObject
{
    static let sharedInstance = NetworkLayer()
    var session : URLSession!
    

    /*
     * Fetches searched giphy
     */
    func searchGify(searchText:String, limit:Int, offset:Int, completionHandler: @escaping (_ result: [Datum],_ error: Error?,_ searchText:String) -> Void){
        
        var requestUrl = "http://api.giphy.com/v1/gifs/search?limit=\(limit)&offset=\(offset)"
        if !searchText.isEmpty{
            requestUrl = requestUrl + "&q=\(searchText)"
        }
        
        requestUrl = requestUrl.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
        
        var request = URLRequest(url: URL(string: requestUrl)!)
        request.setValue("FWmvFEcGGS3XdQs4mMqVg4bx1f5RLDyx", forHTTPHeaderField: "api_key")
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            
            guard let data = data,
                let response = try? JSONDecoder().decode(Giphy.self, from: data) else {
                    completionHandler([],nil,searchText)
                    return
            }
            completionHandler(response.data,nil,searchText)
        }
        task.resume()
    }
    
    
    
    /*
     * Fetches trending giphy
     */
    func trending(limit:Int, offset:Int, completionHandler: @escaping (_ result: [Datum],_ error: Error?) -> Void){
        
        var requestUrl = "http://api.giphy.com/v1/gifs/trending?limit=\(limit)&offset=\(offset)"
        
        requestUrl = requestUrl.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
        var request = URLRequest(url: URL(string: requestUrl)!)
        request.setValue("FWmvFEcGGS3XdQs4mMqVg4bx1f5RLDyx", forHTTPHeaderField: "api_key")
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            
            guard let data = data,
                let response = try? JSONDecoder().decode(Giphy.self, from: data) else {
                    completionHandler([],nil)
                    return
            }
            completionHandler(response.data,nil)
        }
        task.resume()
    }
}

extension String{
    
    var url:URL?
    {
        get
        {
            return URL(string: self)
        }
    }
    
}
