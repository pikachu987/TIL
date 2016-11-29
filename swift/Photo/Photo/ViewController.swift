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
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Mono  ", style: .default, handler: {(action: UIAlertAction) in
            self.applyFilter("CIPhotoEffectInstant")
        }))
        
        alertController.modalPresentationStyle = .popover
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func applyFilter(_ filterName: String){
        self.asset?.requestContentEditingInput(with: nil, completionHandler: { (contentInput: PHContentEditingInput?, _ : [AnyHashable : Any]?) in
            DispatchQueue.global().async(execute: { 
                let url = contentInput?.fullSizeImageURL
                let orientation = contentInput?.fullSizeImageOrientation
                var inputImg = CIImage(contentsOf: url!, options: nil)
                inputImg = inputImg?.applyingOrientation(orientation!)
                
                let filter = CIFilter(name: filterName)
                filter?.setDefaults()
                filter?.setValue(inputImg, forKey: kCIInputImageKey)
                let outputImg = filter?.outputImage
                
                let context = CIContext()
                let image = context.createCGImage(outputImg!, from: outputImg!.extent)
                let uiImage = UIImage(cgImage: image!)
                
                let contentOutput = PHContentEditingOutput(contentEditingInput: contentInput!)
                
                let renderedData = UIImageJPEGRepresentation(uiImage, 0.9)
                
                if (((try? renderedData?.write(to: contentOutput.renderedContentURL, options: [.atomic])) != nil) != nil){
                    let archivedData = NSKeyedArchiver.archivedData(withRootObject: filterName)
                    let adjData = PHAdjustmentData(formatIdentifier: "com.gbustudio.photo", formatVersion: "1.0", data: archivedData)
                    contentOutput.adjustmentData = adjData
                    
                    PHPhotoLibrary.shared().performChanges({ 
                        let request = PHAssetChangeRequest(for: self.asset!)
                        request.contentEditingOutput = contentOutput
                    }, completionHandler: { (success: Bool, error: Error?) in
                        if success{
                            self.showImage()
                        }
                    })
                }
            })
        })
    }
}
