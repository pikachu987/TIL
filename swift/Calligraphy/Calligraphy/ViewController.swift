//
//  ViewController.swift
//  Calligraphy
//
//  Created by guanho on 2016. 11. 24..
//  Copyright © 2016년 guanho. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var h1: UIImageView!
    @IBOutlet var h2: UIImageView!
    @IBOutlet var hourChar: UIImageView!
    @IBOutlet var m1: UIImageView!
    @IBOutlet var m2: UIImageView!
    @IBOutlet var m3: UIImageView!
    @IBOutlet var minChar: UIImageView!
    @IBOutlet var s1: UIImageView!
    @IBOutlet var s2: UIImageView!
    @IBOutlet var s3: UIImageView!
    @IBOutlet var secChar: UIImageView!
    
    @IBOutlet var fullDisplay: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateTime()
        let language = Locale.preferredLanguages[0]
        let timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateTime(_:)), userInfo: language, repeats: true)
        //self.preferLabel.text = "Language: \(Locale.preferredLanguages[0]) Locale: \((Locale.current as NSLocale).object(forKey: .countryCode)!)"
    }

    func updateTime(_ timer: Timer? = nil){
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute, .second], from: date)
        let hour = components.hour! <= 12 ? components.hour : components.hour! - 12
        let minutes = components.minute
        let seconds = components.second
        let hours: Array = ["영","한","두","세","네","다섯","여섯","일곱","여덟","아홉","열","열 한","열 두"]
        let numbers: Array = ["영","일","이","삼","사","오","육","칠","팔","구","십"]
        
        let timestamp = DateFormatter.localizedString(from: date, dateStyle: .none, timeStyle: .medium)
        self.fullDisplay.text = timestamp
        
        if hours[hour!].characters.count > 1{
            self.h1.image = UIImage(named: "\(hours[hour!].characters.first!).png")
            self.h2.image = UIImage(named: "\(hours[hour!].characters.last!).png")
        }else{
            self.h1.image = UIImage()
            self.h2.image = UIImage(named: "\(hours[hour!]).png")
        }
        self.hourChar.image = UIImage(named: "시.png")
        if minutes! <= 10{
            self.m1.image = UIImage()
            self.m2.image = UIImage()
            self.m3.image = UIImage(named: "\(numbers[minutes!]).png")
        }else if minutes! < 20{
            self.m1.image = UIImage()
            self.m2.image = UIImage(named: "\(numbers[10]).png")
            self.m3.image = UIImage(named: "\(numbers[minutes!%10]).png")
        }else{
            if minutes! % 10 == 0{
                self.m1.image = UIImage()
                self.m2.image = UIImage(named: "\(numbers[minutes!/10]).png")
                self.m3.image = UIImage(named: "\(numbers[10]).png")
            }else{
                self.m1.image = UIImage(named: "\(numbers[minutes!/10]).png")
                self.m2.image = UIImage(named: "\(numbers[10]).png")
                self.m3.image = UIImage(named: "\(numbers[minutes!%10]).png")
            }
        }
        self.minChar.image = UIImage(named: "분.png")
        if seconds! <= 10{
            self.s1.image = UIImage()
            self.s2.image = UIImage()
            self.s3.image = UIImage(named: "\(numbers[seconds!]).png")
        }else if seconds! < 20{
            self.s1.image = UIImage()
            self.s2.image = UIImage(named: "\(numbers[10]).png")
            self.s3.image = UIImage(named: "\(numbers[seconds!%10]).png")
        }else{
            if seconds! % 10 == 0{
                self.s1.image = UIImage()
                self.s2.image = UIImage(named: "\(numbers[seconds!/10]).png")
                self.s3.image = UIImage(named: "\(numbers[10]).png")
            }else{
                self.s1.image = UIImage(named: "\(numbers[seconds!/10]).png")
                self.s2.image = UIImage(named: "\(numbers[10]).png")
                self.s3.image = UIImage(named: "\(numbers[seconds!%10]).png")
            }
        }
        self.secChar.image = UIImage(named: "초.png")
        
        if timer != nil && String(describing: timer?.userInfo).range(of: "ko") == nil{
            self.fullDisplay.text = timestamp
        }else{
            self.fullDisplay.text = ""
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

