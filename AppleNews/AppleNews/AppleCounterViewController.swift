//
//  AppleCounterViewController.swift
//  AppleNews
//
//  Created by HYOUNGSUN park on 1/28/18.
//  Copyright © 2018 stanleypark. All rights reserved.
//

import UIKit

class AppleCounterViewController: UIViewController {
    
//    var appleCount: Int = 0
    var news: News?

    @IBOutlet weak var counterView: CounterView!
    
    // UILabel that shows the number of Apple news appears in the Open News api
    @IBOutlet weak var counterLabel: UILabel!
    
  
    let urlString = "https://newsapi.org/v2/everything?q=apple&from=\(getDate())&to=\(getDate())&sortBy=popularity&apiKey=685569281b2f44d4bcf3c019eb60fb90"
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(self.urlString)
        
        
        // The data is available in this closure through the `news` variable. Copy the `news` to a property of the view controller so that it can persist beyond the closure block.
        self.getNews(url: urlString) { (news) in
            
            self.news = news
            print("******** got the news **********") // for debugging
            
            
            DispatchQueue.main.async {
                // Update any views with the newly downloaded news data
                print("reloaded") // for debugging
                
                // displaying how many Apple appears by grabing total results(integer) from the custom News data struct
                self.counterLabel.text = String(describing: self.news!.totalResults)
            }
        }
 
    }
    
    func getNews(url: String, completion:@escaping (News?) -> Void) {
        
        // Transform the `url` parameter argument to a `URL`
        guard let url = NSURL(string: url) else {
            fatalError("Unable to create NSURL from string")
        }
        
        // Create a url session
        let session = URLSession.shared
        
        // Create a data task
        let task = session.dataTask(with: url as URL, completionHandler: { (data, response, error) -> Void in
            
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}
