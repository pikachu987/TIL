//
//  ViewController.swift
//  AdobeImageEditor
//
//  Created by guanho on 2016. 9. 7..
//  Copyright © 2016년 guanho. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, AdobeUXImageEditorViewControllerDelegate {
    
    
    
    //이미지 피커
    let picker = UIImagePickerController()
    
    @IBOutlet var mainView: UIView!
    @IBOutlet var imageView: UIImageView!
    let eatImage = UIImage(named: "eat.jpg")
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        picker.allowsEditing = true
        picker.delegate = self
    }

    
    
    @IBAction func btnAction(sender: AnyObject) {
        let alert = UIAlertController(title:"",message:"이미지 선택", preferredStyle: .ActionSheet)
        alert.addAction(UIAlertAction(title:"카메라",style: .Default,handler:{(alert) in
            self.imageCallback(UIImagePickerControllerSourceType.Camera)
        }))
        alert.addAction(UIAlertAction(title:"사진첩",style: .Default,handler:{(alert) in
            self.imageCallback(UIImagePickerControllerSourceType.PhotoLibrary)
        }))
        alert.addAction(UIAlertAction(title:"치킨이미지",style: .Default,handler:{(alert) in
            self.photoEditorStart(self.eatImage)
        }))
        self.presentViewController(alert, animated: false, completion: {(_) in })
    }
    
    
    
    //이미지 콜백
    func imageCallback(sourceType : UIImagePickerControllerSourceType){
        picker.sourceType = sourceType
        presentViewController(picker, animated: false, completion: nil)
    }
    //이미지 끝
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    //이미지 받아오기
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        var newImage: UIImage
        if let possibleImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            newImage = possibleImage
        } else if let possibleImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            newImage = possibleImage
        } else {
            return
        }
        dismissViewControllerAnimated(true, completion: {(_) in
            self.photoEditorStart(newImage)
        })
    }
    
    
    
    //이미지 에디터 시작
    func photoEditorStart(image: UIImage!){
        dispatch_async(dispatch_get_main_queue()) {
            //AdobeImageEditor 설정
            AdobeImageEditorCustomization.setToolOrder([
                kAdobeImageEditorEnhance,        /* Enhance */
                kAdobeImageEditorEffects,        /* Effects */
                kAdobeImageEditorStickers,       /* Stickers */
                kAdobeImageEditorOrientation,    /* Orientation */
                kAdobeImageEditorCrop,           /* Crop */
                kAdobeImageEditorColorAdjust,    /* Color */
                kAdobeImageEditorLightingAdjust, /* Lighting */
                kAdobeImageEditorSharpness,      /* Sharpness */
                kAdobeImageEditorDraw,           /* Draw */
                kAdobeImageEditorText,           /* Text */
                kAdobeImageEditorRedeye,         /* Redeye */
                kAdobeImageEditorWhiten,         /* Whiten */
                kAdobeImageEditorBlemish,        /* Blemish */
                kAdobeImageEditorBlur,           /* Blur */
                kAdobeImageEditorMeme,           /* Meme */
                kAdobeImageEditorFrames,         /* Frames */
                kAdobeImageEditorFocus,          /* TiltShift */
                kAdobeImageEditorSplash,         /* ColorSplash */
                kAdobeImageEditorOverlay,        /* Overlay */
                kAdobeImageEditorVignette        /* Vignette */
                ])
            
            let adobeViewCtr = AdobeUXImageEditorViewController(image: image)
            adobeViewCtr.delegate = self
            self.presentViewController(adobeViewCtr, animated: true) { () -> Void in
                
            }
        }
    }
    
    
    
    //AdobeCreativeSDK 이미지 받아옴
    func photoEditor(editor: AdobeUXImageEditorViewController, finishedWithImage image: UIImage?) {
        editor.dismissViewControllerAnimated(true, completion: {(_) in
            let imageWidth = self.mainView.frame.width
            let imageHeight = self.mainView.frame.height
            
            let rateWidth = (image?.size.width)!/imageWidth
            let rateHeight = (image?.size.height)!/imageHeight
            
            var widthValue : CGFloat! = imageWidth
            var heightValue : CGFloat! = imageHeight
            
            if rateWidth > rateHeight{
                heightValue = widthValue * (image?.size.height)! / (image?.size.width)!
            }else{
                widthValue = heightValue * (image?.size.width)! / (image?.size.height)!
            }
            self.imageView.frame = CGRect(x: (imageWidth-widthValue)/2, y: (imageHeight-heightValue)/2, width: widthValue, height: heightValue)
            self.imageView.image = image
        })
    }
    
    
    //AdobeCreativeSDK 캔슬
    func photoEditorCanceled(editor: AdobeUXImageEditorViewController) {
        editor.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

