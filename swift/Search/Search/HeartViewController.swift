//
//  HeartViewController.swift
//  Search
//
//  Created by guanho on 2017. 2. 5..
//  Copyright © 2017년 guanho. All rights reserved.
//

import UIKit
import PKCUtil
import CoreData

protocol HeartDelegate {
    func heartOff(_ goods: GoodsVO)
}

class HeartViewController: UIViewController {
    enum Sort{
        case saveDT
        case price_asc
        case price_dsc
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    var delegate: HeartDelegate?
    lazy var goodsArray: [Goods] = [Goods]()
    lazy var goodsVOArray: [GoodsVO] = [GoodsVO]()
    var sort: Sort = .saveDT
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.global().async {
            self.arrayAction()
        }
    }
    
    func arrayAction(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Goods>(entityName: "Goods")
        do{
            var goodsArray = try managedContext.fetch(fetchRequest)
            func nilTest(_ str: String?) -> String{
                if str == nil{
                    return ""
                }else{
                    var strValue = str
                    strValue = strValue?.replacingOccurrences(of: "\n", with: "")
                    strValue = strValue?.replacingOccurrences(of: "\t", with: "")
                    return strValue!
                }
            }
            
            func resultPrice(_ price: String?) -> Int{
                var priceValue = nilTest(price)
                priceValue = priceValue.replacingOccurrences(of: ",", with: "")
                if Int(priceValue) != nil{
                    return Int(priceValue)!
                }else{
                    return 0
                }
            }
            if self.sort == Sort.saveDT{
                goodsArray = goodsArray.reversed()
            }else if self.sort == Sort.price_asc{
                goodsArray = goodsArray.sorted(by: { resultPrice($0.price) < resultPrice($1.price) })
            }else if self.sort == Sort.price_dsc{
                goodsArray = goodsArray.sorted(by: { resultPrice($0.price) > resultPrice($1.price) })
            }
            
            self.goodsArray = goodsArray
            self.goodsVOArray = [GoodsVO]()
            for goods in goodsArray{
                let goodsVO = GoodsVO(img: nilTest(goods.image), title: nilTest(goods.title), price: nilTest(goods.price), date: nilTest(goods.date), detailUrl: nilTest(goods.detail), saveDT: nilTest((goods.saveDT as! Date).getFullDate()))
                self.goodsVOArray.append(goodsVO)
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }catch let error as NSError{
            print("err : \(error)")
        }
    }
    
    
    @IBAction func sortAction(_ sender: UIButton) {
        func alertAction(){
            self.arrayAction()
        }
        let alert = UIAlertController(title: "", message: "정렬을 선택해 주세요", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "저장일순", style: .default, handler: { (_) in
            self.sort = .saveDT
            alertAction()
        }))
        alert.addAction(UIAlertAction(title: "낮은 가격순", style: .default, handler: { (_) in
            self.sort = .price_asc
            alertAction()
        }))
        alert.addAction(UIAlertAction(title: "높은 가격순", style: .default, handler: { (_) in
            self.sort = .price_dsc
            alertAction()
        }))
        self.present(alert, animated: true, completion: nil)
    }
}







extension HeartViewController: UITableViewDelegate{
    
}
extension HeartViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.goodsVOArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HeartCell") as! HeartCell
        var row = self.goodsVOArray[indexPath.row]
        cell.delegate = self
        cell.title.text = row.title
        cell.price.text = "\(row.price) 원"
        cell.date.text = row.date
        cell.saveDT.text = "저장일 \(row.saveDT)"
        if let data = row.imageData{
            cell.img.image = UIImage(data: data)
        }else{
            URLSession(configuration: .default).dataTask(with: URL(string: row.imageUrl
                )!) { (data, response, error) in
                    if error == nil && data != nil && self.goodsVOArray.count != 0{
                        row.imageData = data
                        DispatchQueue.main.async {
                            cell.img.image = UIImage(data: row.imageData!)
                        }
                    }
                }.resume()
        }
        return cell
    }
}


extension HeartViewController: SearchDelegate{
    func searchTableViewAction(_ cell: UITableViewCell) {
        if let indexPath = self.tableView.indexPath(for: cell){
            let url = self.goodsVOArray[indexPath.row].detailUrl
            if #available(iOS 8.0, *) {
                UIApplication.shared.openURL(NSURL(string: url) as! URL)
            }else{
                UIApplication.shared.open(NSURL(string: url) as! URL, options: [:], completionHandler: nil)
            }
        }
    }
    func searchTableHeartAction(_ cell: UITableViewCell, btn: UIButton) {
        if let indexPath = self.tableView.indexPath(for: cell){
            self.delegate?.heartOff(self.goodsVOArray[indexPath.row])
            UIView.animate(withDuration: 0.5, animations: {
                cell.transform = CGAffineTransform(scaleX: 0.0001, y: 0.0001)
            }, completion: { (_) in
                cell.transform = CGAffineTransform(scaleX: 1, y: 1)
                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
                    return
                }
                let managedContext = appDelegate.persistentContainer.viewContext
                managedContext.delete(self.goodsArray[indexPath.row])
                appDelegate.saveContext()
                self.arrayAction()
            })
        }
    }
}
