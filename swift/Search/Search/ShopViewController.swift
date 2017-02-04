//
//  NavViewController.swift
//  Search
//
//  Created by guanho on 2017. 2. 5..
//  Copyright © 2017년 guanho. All rights reserved.
//

import UIKit
import PKCUtil

class ShopViewController: UIViewController{
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var spin: UIActivityIndicatorView!
    
    var interactor:Interactor? = nil
    
    lazy var shopArray: [ShopVO] = [ShopVO]()
    var pageIndex = 1
    var search = ""
    var totCnt = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.keyboardHide(_:))))
        self.spin.isHidden = false
        self.spin.startAnimating()
        DispatchQueue.global(qos: .default).async {
            self.arrayAction()
        }
    }
    func keyboardHide(_ sender: AnyObject){
        self.view.endEditing(true)
    }
    
    func arrayAction(){
        let apiUrl = "http://openAPI.seoul.go.kr:8088/7a7a43644b70696b36387856747951/json/ServiceInternetShopInfo/\(self.pageIndex)/\(self.pageIndex+29)/\(self.search.queryValue())/"
        URLSession(configuration: .default).dataTask(with: URL(string: apiUrl)!) { (data, response, error) in
                if error == nil && data != nil{
                    let dataDic = Util.convertStringToDictionary(data!)
                    if let serviceInternetShopInfo = dataDic["ServiceInternetShopInfo"] as? [String: AnyObject]{
                        func rsl(_ str: AnyObject?) -> String{
                            if str != nil{
                                return "\(str!)"
                            }else{
                                return ""
                            }
                        }
                        if let totCnt = serviceInternetShopInfo["list_total_count"] as? String{
                            self.totCnt = Int(totCnt)!
                        }else if let totCnt = serviceInternetShopInfo["list_total_count"] as? Int{
                            self.totCnt = totCnt
                        }else{
                            self.totCnt = 0
                        }
                        if let row = serviceInternetShopInfo["row"] as? [[String: AnyObject]]{
                            for shop in row{
                                let shopVO = ShopVO(shop: rsl(shop["SHOP_NAME"]), domain: rsl(shop["DOMAIN_NAME"]), service: rsl(shop["SERVICE"]), year: rsl(shop["KAESOL_YEAR"]))
                                self.shopArray.append(shopVO)
                            }
                        }
                    }
                }
                DispatchQueue.main.async {
                    self.spin.isHidden = true
                    self.spin.stopAnimating()
                    self.tableView.reloadData()
                }
            }.resume()
    }
    
    
    @IBAction func handleGesture(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        let progress = NavHelper.calculateProgress(translation, viewBounds: view.bounds, direction: .left)
        NavHelper.mapGestureStateToInteractor(sender.state,progress: progress,interactor: interactor){
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func closeMenu(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension ShopViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.shopArray = [ShopVO]()
        self.pageIndex = 1
        self.view.endEditing(true)
        self.spin.isHidden = false
        self.spin.startAnimating()
        self.search = textField.text!
        DispatchQueue.global(qos: .default).async {
            self.arrayAction()
        }
        return false
    }
}

extension ShopViewController: UITableViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        let deltaOffset = maximumOffset - currentOffset
        if deltaOffset <= 0 && self.spin.isHidden && self.pageIndex+30 < self.totCnt{
            self.spin.isHidden = false
            self.spin.startAnimating()
            self.pageIndex += 30
            DispatchQueue.global(qos: .default).async {
                self.arrayAction()
            }
        }
    }
}
extension ShopViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.shopArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShopCell") as! ShopCell
        let row = self.shopArray[indexPath.row]
        cell.delegate = self
        cell.shop.text = row.shop
        cell.service.text = row.service
        cell.year.text = "개설일: \(row.year)"
        return cell
    }
}

extension ShopViewController: ShopDelegate{
    func shop(_ cell: UITableViewCell) {
        guard let indexPath = self.tableView.indexPath(for: cell) else {
            return
        }
        var url = self.shopArray[indexPath.row].domain
        if url.substring(from: 0, length: 4) != "http"{
            url = "http://\(url)"
        }
        if #available(iOS 8.0, *) {
            UIApplication.shared.openURL(NSURL(string: url) as! URL)
        }else{
            UIApplication.shared.open(NSURL(string: url) as! URL, options: [:], completionHandler: nil)
        }
    }
}
