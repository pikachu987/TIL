//
//  ViewController.swift
//  Photo
//
//  Created by guanho on 2016. 11. 25..
//  Copyright © 2016년 guanho. All rights reserved.
//

import UIKit
import Photos

class ViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    
    var asset: PHAsset?
    
    override func viewDidLoad() {
        let effectBtn: UIBarButtonItem = UIBarButtonItem(title: "Effect", style: .plain, target: self, action: #selector(applyEffect))
        self.navigationItem.rightBarButtonItem = effectBtn
        
        if (self.asset!.mediaType == PHAssetMediaType.image){
            self.navigationItem.rightBarButtonItem = effectBtn
        }
        
        showImage()
        
    }
    
    func showImage(){
        let scale = UIScreen.main.scale
        let size = CGSize(width: self.imageView.bounds.width * scale, height: self.imageView.bounds.height * scale)
        let imageManager = PHImageManager.default().requestImage(for: self.asset!, targetSize: size, contentMode: .aspectFit, options: nil, resultHandler: {(result: UIImage?, info: [AnyHashable: Any]?) in
            self.imageView.image = result
        })
        
    }
    
    func applyEffect(){
    
    }
}
