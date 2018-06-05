//
//  ViewController.swift
//  URLSessionMPFD
//
//  Created by Sukumar Anup Sukumaran on 05/06/18.
//  Copyright © 2018 TechTonic. All rights reserved.
//

import UIKit

typealias Parameters = [String: String]

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    
    @IBAction func getRequest(_ sender: Any) {
        // make url path
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/users") else { return }
        
        // make request
        var request = URLRequest(url: url)
        
        let boundary = generateBoundary()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let dataBody = createDataBody(withParameters: nil, media: nil, boundary: boundary)
        request.httpBody = dataBody
        
        let session = URLSession.shared
        
        session.dataTask(with: request) { (data, response, error) in
            
            if let response = response {
                print("response = \(response)")
            }
            
            if let data = data {
                do{
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print("JSON = \(json)")
                    
                }catch{
                    print("Error = \(error.localizedDescription)")
                }
            }
            
            
        }.resume()
        
    }
    
    func generateBoundary() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    func createDataBody(withParameters params: Parameters?, media:[Media]?, boundary:String) -> Data {
        
        let lineBreak = "\r\n"
        var body = Data()
        
        if let parameters = params {
            
            for (key, value) in parameters {
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)")
                body.append("\(value + lineBreak)")
            }
      
        }
        
        if let media = media {
            for photo in media {
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(photo.key)\"; filename=\"\(photo.filename)\"\(lineBreak)")
                body.append("Content-Type: \(photo.mimeType + lineBreak + lineBreak)")
                body.append(photo.data)
                body.append(lineBreak)
            }
        }
        
        body.append("--\(boundary)--\(lineBreak)")
        
        
        return body
    }
    
    @IBAction func postRequest(_ sender: Any) {
        
        let parameters = ["name": "MytestFile12233", "description":"My tutorial test file"]
        
        // the key = "Image" is from the site"Imgur API" that provided the upload link and "Image" was the key name to upload Image
        guard let mediaImage = Media(withImage: #imageLiteral(resourceName: "cars"), forKey: "image") else {
            return
        }
        
        // make url path
        guard let url = URL(string: "https://api.imgur.com/3/image") else { return }
        
        // make request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let boundary = generateBoundary()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.addValue("Client-ID 779dc20b10234a9", forHTTPHeaderField: "Authorization")
        
        let dataBody = createDataBody(withParameters: parameters, media: [mediaImage], boundary: boundary)
        request.httpBody = dataBody
        
        let session = URLSession.shared
        
        session.dataTask(with: request) { (data, response, error) in
            
            if let response = response {
                print("response = \(response)")
            }
            
            if let data = data {
                do{
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print("JSON = \(json)")
                    
                }catch{
                    print("Error = \(error.localizedDescription)")
                }
            }
            
            
            }.resume()
        
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }


}

extension Data {
    
   mutating func append(_ string: String) {
        if let data = string.data(using: .utf8){
            append(data)
        }
    }
}

