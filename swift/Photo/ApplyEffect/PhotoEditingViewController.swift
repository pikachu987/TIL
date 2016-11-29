//
//  PhotoEditingViewController.swift
//  ApplyEffect
//
//  Created by guanho on 2016. 11. 28..
//  Copyright © 2016년 guanho. All rights reserved.
//

import UIKit
import Photos
import PhotosUI

class PhotoEditingViewController: UIViewController, PHContentEditingController {
    @IBOutlet var imageView: UIImageView!
    var image: UIImage?
    var orientation: Int32?
    var selectedFilter: String!
    var input: PHContentEditingInput?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - PHContentEditingController
    
    func canHandle(_ adjustmentData: PHAdjustmentData) -> Bool {
        // Inspect the adjustmentData to determine whether your extension can work with past edits.
        // (Typically, you use its formatIdentifier and formatVersion properties to do this.)
        return false
    }
    
    func startContentEditing(with contentEditingInput: PHContentEditingInput, placeholderImage: UIImage) {
        // Present content for editing, and keep the contentEditingInput for use when closing the edit session.
        // If you returned true from canHandleAdjustmentData:, contentEditingInput has the original image and adjustment data.
        // If you returned false, the contentEditingInput has past edits "baked in".
        input = contentEditingInput
        image = input!.displaySizeImage
        orientation = input!.fullSizeImageOrientation
        imageView.image = image
        
        showFilter()
    }
    
    func showFilter(){
        let alertController = UIAlertController(title: "필터", message: "어떤 필터를 적용하시겠습니까?", preferredStyle: .alert)
        let actionMono = UIAlertAction(title: "Mono", style: .default, handler: {(action: UIAlertAction) in
            self.selectedFilter = "CIPhotoEffectMono"
            self.imageView.image = self.applyFilter(self.image!)
        })
        let actionInstant = UIAlertAction(title: "Instant", style: .default, handler: {(action: UIAlertAction) in
            self.selectedFilter = "CIPhotoEffectInstant"
            self.imageView.image = self.applyFilter(self.image!)
        })
        
        alertController.addAction(actionMono)
        alertController.addAction(actionInstant)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func applyFilter(_ inputImg: UIImage) -> UIImage{
        let image = CIImage(image: inputImg)
        let filter = CIFilter(name: selectedFilter)
        
        filter?.setDefaults()
        filter?.setValue(image, forKey: kCIInputImageKey)
        
        let outputImg = filter?.outputImage
        let cgImg = CIContext().createCGImage(outputImg!, from: outputImg!.extent)
        let resultImg = UIImage(cgImage: cgImg!)
        
        return resultImg
    }
    
    
    
    func finishContentEditing(completionHandler: @escaping ((PHContentEditingOutput?) -> Void)) {
        // Update UI to reflect that editing has finished and output is being rendered.
        
        // Render and provide output on a background queue.
        DispatchQueue.global().async {
            // Create editing output from the editing input.
            let output = PHContentEditingOutput(contentEditingInput: self.input!)
            
            if let url = self.input!.fullSizeImageURL{
                let originalImg = UIImage(contentsOfFile: url.path)
                let filteredImg = self.applyFilter(originalImg!)
                
                let renderedData = UIImageJPEGRepresentation(filteredImg, 0.9)
                
                if (((try? renderedData?.write(to: output.renderedContentURL, options: [.atomic])) != nil) != nil){
                    let archivedData = NSKeyedArchiver.archivedData(withRootObject: self.selectedFilter)
                    let adjData = PHAdjustmentData(formatIdentifier: "com.gbustudio.photo", formatVersion: "1.0", data: archivedData)
                    output.adjustmentData = adjData
                    NSLog("success")
                }
            }
            
            completionHandler(output)
            
            // Clean up temporary files, etc.
        }
    }
    
    var shouldShowCancelConfirmation: Bool {
        // Determines whether a confirmation to discard changes should be shown to the user on cancel.
        // (Typically, this should be "true" if there are any unsaved changes.)
        return false
    }
    
    func cancelContentEditing() {
        // Clean up temporary files, etc.
        // May be called after finishContentEditingWithCompletionHandler: while you prepare output.
    }

}
