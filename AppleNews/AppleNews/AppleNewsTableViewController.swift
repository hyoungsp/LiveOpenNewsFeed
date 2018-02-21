//
//  AppleNewsTableViewController.swift
//  AppleNews
//
//  Created by HYOUNGSUN park on 1/28/18.
//  Copyright © 2018 stanleypark. All rights reserved.
//

import UIKit

//
// - Attributions: https://newsapi.org (JSON Data from the Web)
//
class AppleNewsTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let urlString = "https://newsapi.org/v2/everything?q=apple&from=\(getDate())&to=\(getDate())&sortBy=popularity&apiKey=685569281b2f44d4bcf3c019eb60fb90"
    
    @IBOutlet weak var refControl: UIRefreshControl!
    
    @IBOutlet var tableView: UITableView!
    
    var news: News?
    
    // properties: all types that will be passed to apple news detail view controller
    var passValueTitle: String?
    var passValueContent: String?
    var passValueDate: String?
    var passValueUrl: URL?
    
    // connected to the tableview's built-in refresh property as an action
    @IBAction func pulledDownRefresh(_ sender: Any) {
        // Whenever pull-down refresh gets called, newly reloaded data will be stored in the custom struct
        self.tableView.reloadData()
        // Ending the refreshing
        self.refControl.endRefreshing()
        
        print("****** refresh ******") // for debugging purposes
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // For debugging purpose
        print(self.urlString)
        
        // The data is available in this closure through the `news` variable. Copy the `news` to a property of the view controller so that it can persist beyond the closure block.
        self.getNews(url: urlString) { (news) in
            
            self.news = news
            print("got the news") // for debugging
            
            DispatchQueue.main.async {
                // Update any views with the newly downloaded news data
                print("****** reloaded ******") // for debugging
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
        // tableview's deleget: set to self
        self.tableView.delegate = self
        self.tableView.dataSource = self
        // Title color of the table view sets to red
        let textAttributes = [NSAttributedStringKey.foregroundColor:UIColor.red]
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes
        self.navigationController?.navigationBar.backgroundColor = UIColor.red
    }
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
   
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.passValueContent = self.news!.articles[indexPath.row].description
        self.passValueDate = self.news!.articles[indexPath.row].publishedAt
        self.passValueTitle = self.news!.articles[indexPath.row].title
        self.passValueUrl = self.news!.articles[indexPath.row].url
        // this table view is segue to apple detail news view controller
        // and the passed data will be appear further on apple detail view controller
        performSegue(withIdentifier: "AppleToDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailArticle = segue.destination as? ArticleDetailViewContoller
        
        // passing data to the apple detail news view controller
        detailArticle?.content = self.passValueContent
        detailArticle?.date = self.passValueDate
        detailArticle?.articleTitle = self.passValueTitle
        detailArticle?.urlLink = self.passValueUrl
        
        
    }
    
    // define how many rows (cells) appearing in each row in the table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let currentNews = self.news {
            return currentNews.articles.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath) as? NewsTableViewCell  else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        
        // each cell - displaying source and title
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
        
        // Set the date formate to be including exact time to calculate for determining the different 12 hr old articles
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        let articleDate = dateFormatter.date(from:  (self.news?.articles[indexPath.row].publishedAt)!)
        
        // each cell of table view's emojo will be changed, if the article is 12 hr old or more
        if (articleDate?.timeIntervalSinceNow.isLess(than: -12 * 60 * 60))! {
            // smile image if the article has been published less then 12 hrs
            cell.imageView?.image = #imageLiteral(resourceName: "smile")
        } else {
            cell.imageView?.image = #imageLiteral(resourceName: "sad")
        }

        return cell

    }
}

//
// Global function that provides the current date with the format yyyy-MM-dd (required to url string)
//
func getDate() -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    let today = formatter.string(from: Date())
    return today
}



