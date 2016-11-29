//
//  DetailViewController.swift
//  ForceTouch
//
//  Created by guanho on 2016. 11. 28..
//  Copyright © 2016년 guanho. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var text: UILabel!
    var txt: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.text.text = txt
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override var previewActionItems: [UIPreviewActionItem]{
        let firstAction = UIPreviewAction(title: "First Action", style: .default, handler: {(action: UIPreviewAction, vc: UIViewController) -> Void in
        
        })
        let secondAction = UIPreviewAction(title: "Second Action", style: .default, handler: {(action: UIPreviewAction, vc: UIViewController) -> Void in
            
        })
        
        return [firstAction, secondAction]
    }
    @IBAction func backAction(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true)
    }
}
