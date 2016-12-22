//
//  DetailViewController.swift
//  MovieChart
//
//  Created by guanho on 2016. 12. 21..
//  Copyright © 2016년 guanho. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet var wv: UIWebView!
    var mvo: MovieVo!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = self.mvo?.title
        
        let url = URL(string: (self.mvo.detail)!)
        let req = URLRequest(url: url!)
        self.wv.loadRequest(req)
    }
}
