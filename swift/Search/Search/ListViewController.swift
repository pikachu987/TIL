//
//  ViewController.swift
//  Search
//
//  Created by guanho on 2017. 2. 3..
//  Copyright © 2017년 guanho. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {
    @IBOutlet weak var tabLeftCont: NSLayoutConstraint!
    var pageViewController: ListPageViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func searchAction(_ sender: UIButton) {
        self.pageViewController?.scrollToViewController(index: 0)
        UIView.animate(withDuration: 0.3, animations: {
            self.tabLeftCont.constant = -10
            self.view.layoutIfNeeded()
            self.view.setNeedsLayout()
        }) { _ in
            UIView.animate(withDuration: 0.1, animations: {
                self.tabLeftCont.constant = 3
                self.view.layoutIfNeeded()
                self.view.setNeedsLayout()
            }) { _ in
                UIView.animate(withDuration: 0.1, animations: {
                    self.tabLeftCont.constant = 0
                    self.view.layoutIfNeeded()
                    self.view.setNeedsLayout()
                })
            }
        }
    }

    @IBAction func heartAction(_ sender: UIButton) {
        self.pageViewController?.scrollToViewController(index: 1)
        UIView.animate(withDuration: 0.3, animations: { 
            self.tabLeftCont.constant = UIScreen.main.bounds.width/2+10
            self.view.layoutIfNeeded()
            self.view.setNeedsLayout()
        }) { _ in
            UIView.animate(withDuration: 0.1, animations: {
                self.tabLeftCont.constant = UIScreen.main.bounds.width/2-3
                self.view.layoutIfNeeded()
                self.view.setNeedsLayout()
            }) { _ in
                UIView.animate(withDuration: 0.1, animations: {
                    self.tabLeftCont.constant = UIScreen.main.bounds.width/2
                    self.view.layoutIfNeeded()
                    self.view.setNeedsLayout()
                })
            }
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let pageVC = segue.destination as? ListPageViewController{
            self.pageViewController = pageVC
        }
    }
}
