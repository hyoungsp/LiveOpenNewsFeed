//
//  ViewController.swift
//  AppleNews
//
//  Created by HYOUNGSUN park on 1/28/18.
//  Copyright © 2018 stanleypark. All rights reserved.
//

import UIKit

/// For icons that are used in the applications
//
// - Attributions: https://icons8.com/
//

class ViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //
    // MARK: - Properties
    //
    
    /// `News` data returned from the network request
    var news: News?
    
    /// The url of the JSON endpoint
    let urlString = "https://newsapi.org/v2/everything?q=apple&from=2018-01-25&to=2018-01-25&sortBy=popularity&apiKey=685569281b2f44d4bcf3c019eb60fb90"
   
    //
    //685569281b2f44d4bcf3c019eb60fb90 <<< api Key
    //
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    
    
    //
    // MARK: - Networking
    //
    
    //Retrieve class Issues using GitHub API v3 and pass back the array of dictionaries in the completion block `completion()`
    /// - Parameter url: A `String` of the url
    /// - Parameter completion: A closure to run on the converted JSON
    /// - Returns: An `Array` of `Dictionary` objects
    func getNews(url: String, completion:@escaping (News?) -> Void) {
        
        // Transform the `url` parameter argument to a `URL`
        guard let url = NSURL(string: url) else {
            fatalError("Unable to create NSURL from string")
        }
        
        // Create a url session
        let session = URLSession.shared
        
        // Create a data task
        let task = session.dataTask(with: url as URL, completionHandler: { (data, response, error) -> Void in
            
            // Print out the response (for debugging purpose)
            print("Response: \(String(describing: response))")
            
            // Ensure there were no errors returned from the request
            guard error == nil else {
                fatalError("Error: \(error!.localizedDescription)")
            }
            
            // Ensure there is data and unwrap it
            guard let data = data else {
                fatalError("Data is nil")
            }
            // Print out for debugging
            print("Raw data: \(data)")
            
            
            // Covert JSON to `News` type using `JSONDecoder` and `Codable` protocol
            do {
                let decoder = JSONDecoder()
                let news = try decoder.decode(News.self, from: data)
                // Call the completion block closure with the news data
                completion(news)
            } catch {
                print("Error serializing/decoding JSON: \(error)")
            }
        })
        
        // Tasks start off in suspended state, we need to kick it off
        task.resume()
    }

}

