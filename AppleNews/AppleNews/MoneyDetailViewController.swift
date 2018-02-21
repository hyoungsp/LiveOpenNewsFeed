//
//  MoneyDetailViewController.swift
//  AppleNews
//
//  Created by HYOUNGSUN park on 1/28/18.
//  Copyright © 2018 stanleypark. All rights reserved.
//

import UIKit
// import SafariServices to connect further onto the Web
import SafariServices

//
// - Attributions: https://www.hackingwithswift.com/example-code/uikit/how-to-use-sfsafariviewcontroller-to-show-web-pages-in-your-app
//

class MoneyDetailViewController: UIViewController {

    // UI outlet connection with the ViewController
    // properties of the class
    @IBOutlet weak var articleTitleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var contentText: UITextView!
    
    // properties that will be connected to passed data from MoneyNewsTableViewController
    var articleTitle: String?
    var date: String?
    var content: String?
    var urlLink: URL?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // upper right button item that directs users to Safari
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Visit", style: .plain, target: self, action: #selector(addTapped))
        
        // displaying article contents and title as well as date
        if let content = content{
            self.contentText.text = content
        }
        if let articleTitle = articleTitle
        {
            self.articleTitleLabel.text = articleTitle
        } else {
            
            print("its empty")
        }
        if let date = date{
            self.dateLabel.text = date
        }
        // Do any additional setup after loading the view.
    }
    
    // tapping the "visit" button triggers connection to Safari
    @objc func addTapped() {
        let svc = SFSafariViewController(url: urlLink!)
        present(svc, animated: true, completion: nil)
        print("add tapped")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }

}
