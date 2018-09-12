//
//  MoneyNewsTableViewController.swift
//  AppleNews
//
//  Created by HYOUNGSUN park on 1/28/18.
//  Copyright © 2018 stanleypark. All rights reserved.
//

import UIKit

class MoneyNewsTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let urlString = "https://newsapi.org/v2/everything?q=business&from=\(getDate())&to=\(getDate())&sortBy=popularity&apiKey=685569281b2f44d4bcf3c019eb60fb90"
    
    @IBOutlet weak var refControl: UIRefreshControl!
    
    @IBOutlet var tableView: UITableView!
    var news: News?
    
    var passValueTitle: String?
    var passValueContent: String?
    var passValueDate: String?
    var passValueUrl: URL?
    
    @IBAction func pulledRefresh(_ sender: Any) {
        
        self.tableView.reloadData()
        
        self.refControl.endRefreshing()
        print("****** refreshed ******") // for debugging
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(self.urlString)
        
        
        // The data is available in this closure through the `news` variable.
        // Copy the `news` to a property of the view controller so that it can persist beyond the closure block.
        self.getNews(url: urlString) { (news) in
            
            self.news = news
            print("got the news") // for debugging
            
            DispatchQueue.main.async {
                // Update any views with the newly downloaded news data
                
                self.tableView.reloadData()
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        let textAttributes = [NSAttributedStringKey.foregroundColor:UIColor.blue] // for the sake of compatibility with Obj-C
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes
        self.navigationController?.navigationBar.backgroundColor = UIColor.green
    }
    
    //private var data: [String] = []
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.passValueContent = self.news!.articles[indexPath.row].description
        self.passValueDate = self.news!.articles[indexPath.row].publishedAt
        self.passValueTitle = self.news!.articles[indexPath.row].title
        self.passValueUrl = self.news!.articles[indexPath.row].url
        performSegue(withIdentifier: "MoneyToDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailArticle = segue.destination as? MoneyDetailViewController
        
        detailArticle?.content = self.passValueContent
        detailArticle?.date = self.passValueDate
        detailArticle?.articleTitle = self.passValueTitle
        detailArticle?.urlLink = self.passValueUrl
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let currentNews = self.news {
            return currentNews.articles.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "moneyCell", for: indexPath) as? MoneyTableViewCell  else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }

        if let news = self.news {
            let text = news.articles[indexPath.row].title
            cell.title?.text = text
        } else {
            cell.title?.text = "None"
        }
        
        if let source = self.news {
            let sourceName = source.articles[indexPath.row].source.name
            cell.subTitle?.text = sourceName
        } else {
            cell.subTitle?.text = "Empty"
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        let articleDate = dateFormatter.date(from:  (self.news?.articles[indexPath.row].publishedAt)!)
        
        // Happy or Not Happy Emoji - split - if the news is within 12 hours or not
        if (articleDate?.timeIntervalSinceNow.isLess(than: -12*60*60))! {
            cell.imageView?.image = #imageLiteral(resourceName: "smile")
        } else {
            cell.imageView?.image = #imageLiteral(resourceName: "sad")
        }
    
        
        return cell
        
    }
    

}

