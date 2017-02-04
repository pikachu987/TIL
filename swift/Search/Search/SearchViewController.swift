//
//  SearchViewController.swift
//  Search
//
//  Created by guanho on 2017. 2. 3..
//  Copyright © 2017년 guanho. All rights reserved.
//

import UIKit
import PKCUtil
import Kanna
import CoreData

class SearchViewController: UIViewController {
    enum Sort{
        case rel
        case price_asc
        case price_dsc
        case date
        case review
    }
    enum ListType{
        case table, collection
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var listType: UIButton!
    @IBOutlet weak var spin: UIActivityIndicatorView!
    
    @IBOutlet weak var sortLeftCont: NSLayoutConstraint!
    @IBOutlet weak var sortBottomCont: NSLayoutConstraint!
    @IBOutlet weak var listTypeRightCont: NSLayoutConstraint!
    @IBOutlet weak var listTypeBottomCont: NSLayoutConstraint!
    
    var appDelegate: AppDelegate?
    var managedContext: NSManagedObjectContext?
    
    lazy var goodsArray: [GoodsVO] = [GoodsVO]()
    var search = ""
    var pageSize = 40
    var pageIndex = 1
    var sort: Sort = .rel
    var viewType: ListType = .table
    var touchPoint: CGPoint! = nil
    var isTouch = true
    var heartOn = UIImage(named: "ic_heart_on")
    var heartOff = UIImage(named: "ic_heart_off")
    
    
    let interactor = Interactor()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.keyboardHide(_:))))
        
        self.appDelegate = UIApplication.shared.delegate as? AppDelegate
        self.managedContext = self.appDelegate?.persistentContainer.viewContext
        
        self.spin.isHidden = false
        self.spin.startAnimating()
        
        let flow = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flow.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        flow.itemSize = CGSize(width: self.view.frame.width/3-0.1, height: self.view.frame.width/3-0.1+40)
        flow.minimumInteritemSpacing = 0
        flow.minimumLineSpacing = 0
        
        if self.viewType == .table{
            self.listType.setImage(UIImage(named: "ic_collection"), for: .normal)
            self.tableView.isHidden = false
            self.collectionView.isHidden = true
        }else{
            self.listType.setImage(UIImage(named: "ic_table"), for: .normal)
            self.tableView.isHidden = true
            self.collectionView.isHidden = false
        }
    }
    func keyboardHide(_ sender: AnyObject){
        self.view.endEditing(true)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? ShopViewController {
            destinationViewController.transitioningDelegate = self
            destinationViewController.interactor = interactor
        }
    }
    
    @IBAction func menuAction(_ sender: UIButton) {
        self.performSegue(withIdentifier: "showShop", sender: nil)
    }
    
    
    
    @IBAction func sortAction(_ sender: UIButton, forEvent event: UIEvent) {
        self.touchPoint = nil
        if self.isTouch{
            func alertAction(){
                self.goodsArray = [GoodsVO]()
                self.pageIndex = 1
                self.view.endEditing(true)
                self.spin.isHidden = false
                self.spin.startAnimating()
                DispatchQueue.global(qos: .default).async {
                    self.resultHtml(self.search)
                }
            }
            let alert = UIAlertController(title: "", message: "정렬을 선택해 주세요", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "쇼핑 랭킹순", style: .default, handler: { (_) in
                self.sort = .rel
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
            alert.addAction(UIAlertAction(title: "등록일순", style: .default, handler: { (_) in
                self.sort = .date
                alertAction()
            }))
            alert.addAction(UIAlertAction(title: "상품평순", style: .default, handler: { (_) in
                self.sort = .review
                alertAction()
            }))
            self.present(alert, animated: true, completion: nil)
        }
        self.isTouch = true
    }
    
    
    
    @IBAction func listTypeAction(_ sender: UIButton, forEvent event: UIEvent) {
        self.touchPoint = nil
        if self.isTouch{
            if self.viewType == .table{
                self.viewType = .collection
                self.listType.setImage(UIImage(named: "ic_table"), for: .normal)
                self.tableView.isHidden = true
                self.collectionView.isHidden = false
            }else{
                self.viewType = .table
                self.listType.setImage(UIImage(named: "ic_collection"), for: .normal)
                self.tableView.isHidden = false
                self.collectionView.isHidden = true
            }
        }
        self.isTouch = true
    }
    
    
    
    
    
    
    
    
    
    
    @IBAction func sortDownAction(_ sender: UIButton, forEvent event: UIEvent) {
        if let touch = event.touches(for: sender)?.first {
            self.touchPoint = touch.previousLocation(in: self.view)
            self.isTouch = true
        }
    }
    @IBAction func listTypeDownAction(_ sender: UIButton, forEvent event: UIEvent) {
        if let touch = event.touches(for: sender)?.first {
            self.touchPoint = touch.previousLocation(in: self.view)
            self.isTouch = true
        }
    }
    @IBAction func sortDragAction(_ sender: UIButton, forEvent event: UIEvent) {
        if let touch = event.touches(for: sender)?.first {
            guard self.touchPoint != nil else {
                return
            }
            let point : CGPoint = touch.previousLocation(in: self.view)
            let addWidth = self.touchPoint.x - point.x
            let addHeight = self.touchPoint.y - point.y
            self.sortLeftCont.constant = self.sortLeftCont.constant-addWidth
            self.sortBottomCont.constant = self.sortBottomCont.constant+addHeight
            self.touchPoint = point
            self.view.layoutIfNeeded()
            self.view.setNeedsLayout()
            self.isTouch = false
        }else{
            return
        }
    }
    @IBAction func listTypeDragAction(_ sender: UIButton, forEvent event: UIEvent) {
        if let touch = event.touches(for: sender)?.first {
            guard self.touchPoint != nil else {
                return
            }
            let point : CGPoint = touch.previousLocation(in: self.view)
            let addWidth = self.touchPoint.x - point.x
            let addHeight = self.touchPoint.y - point.y
            self.listTypeRightCont.constant = self.listTypeRightCont.constant+addWidth
            self.listTypeBottomCont.constant = self.listTypeBottomCont.constant+addHeight
            self.touchPoint = point
            self.view.layoutIfNeeded()
            self.view.setNeedsLayout()
            self.isTouch = false
        }else{
            return
        }
    }
    
    
    
    
    
    
    
    
    
    
    func resultHtml(_ str: String){
        if str.characters.count == 0{
            return
        }
        self.search = str
        let naverUrl = "http://shopping.naver.com/search/all.nhn?query=\(str.queryValue())&sort=\(self.sort)&pagingIndex=\(self.pageIndex)&pagingSize=\(self.pageSize)&productSet=total&viewType=list&frm=NVSHPAG&sps=N"
        guard let naverURL = NSURL(string: naverUrl) as? URL, let naverData : Data = NSData(contentsOf: naverURL) as? Data else{
            return
        }
        if let doc = Kanna.HTML(html: naverData, encoding: .utf8){
            if let docList = doc.css("ul.goods_list").first{
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
                for element in docList.xpath("li"){
                    let element_imgarea = element.css("div.img_area")
                    let element_info = element.css("div.info")
                    
                    var imgarea_url = nilTest(element_imgarea.first?.css("a.img").first?["href"])
                    let imgarea_img = element_imgarea.first?.css("a.img").first?.xpath("img").first?["data-original"]
                    let info_title = element_info.first?.css("a.tit").first?.content
                    var info_price = nilTest(element_info.first?.css("span.price").first?.xpath("em").first?.xpath("span").first?.content)
                    let info_date = element_info.first?.css("span.etc").first?.css("span.date").first?.content
                    
                    if !imgarea_url.contains("http"){
                        if imgarea_url.substring(to: imgarea_url.index(imgarea_url.startIndex, offsetBy: 2)) == "//"{
                            imgarea_url = "http:\(imgarea_url)"
                        }else{
                            imgarea_url = "http://m.shopping.naver.com\(imgarea_url)"
                        }
                    }
                    if info_price == "모바일가격"{
                        info_price = nilTest(element_info.first?.css("span.price").first?.xpath("em").first?.css("span.num").first?.content)
                    }
                    
                    var goodsVO = GoodsVO(img: nilTest(imgarea_img), title: nilTest(info_title), price: info_price, date: nilTest(info_date), detailUrl: imgarea_url)
                    goodsVO.isHeart = self.isHeart(goodsVO)
                    self.goodsArray.append(goodsVO)
                }
                DispatchQueue.main.async {
                    self.spin.isHidden = true
                    self.spin.stopAnimating()
                    self.tableView.reloadData()
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    
    
    func isHeart(_ goodsVO: GoodsVO) -> Bool{
        if self.managedContext != nil{
            let fetchRequest = NSFetchRequest<Goods>(entityName: "Goods")
            do{
                guard let goodsArray = try self.managedContext?.fetch(fetchRequest) else{
                    return false
                }
                for goods in goodsArray{
                    if goods.detail == goodsVO.detailUrl{
                        return true
                    }else if goods.title == goodsVO.title && goods.image == goodsVO.imageUrl && goods.price == goodsVO.price{
                        return true
                    }
                }
            }catch let error as NSError{
                print("err : \(error)")
            }
        }
        return false
    }
    
    
    
    func heartOnAction(_ goodsVO: GoodsVO){
        if self.managedContext != nil{
            guard let entity = NSEntityDescription.entity(forEntityName: "Goods", in: managedContext!) else{
                return
            }
            let goods = Goods(entity: entity, insertInto: managedContext)
            goods.image = goodsVO.imageUrl
            goods.title = goodsVO.title
            goods.price = goodsVO.price
            goods.date = goodsVO.date
            goods.detail = goodsVO.detailUrl
            goods.saveDT = NSDate()
            do{
                try managedContext?.save()
            }catch let error as NSError{
                print("err : \(error)")
            }
        }
    }
    
    
    
    func heartOffAction(_ goodsVO: GoodsVO){
        if self.managedContext != nil{
            let fetchRequest = NSFetchRequest<Goods>(entityName: "Goods")
            do{
                guard let goodsArray = try self.managedContext?.fetch(fetchRequest) else{
                    return
                }
                for goods in goodsArray{
                    if goods.detail == goodsVO.detailUrl{
                        self.managedContext?.delete(goods)
                    }else if goods.title == goodsVO.title && goods.image == goodsVO.imageUrl && goods.price == goodsVO.price{
                        self.managedContext?.delete(goods)
                    }
                }
            }catch let error as NSError{
                print("err : \(error)")
            }
        }
    }
    
    
}









extension SearchViewController: UITableViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        let deltaOffset = maximumOffset - currentOffset
        if deltaOffset <= 0 && self.spin.isHidden{
            self.spin.isHidden = false
            self.spin.startAnimating()
            self.pageIndex += 1
            DispatchQueue.global(qos: .default).async {
                self.resultHtml(self.search)
            }
        }
    }
}









extension SearchViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.goodsArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableCell") as! SearchTableCell
        var row = self.goodsArray[indexPath.row]
        cell.delegate = self
        cell.title.text = row.title
        cell.price.text = "\(row.price) 원"
        cell.date.text = row.date
        if row.isHeart == true{
            cell.heart.setImage(self.heartOn, for: .normal)
        }else{
            cell.heart.setImage(self.heartOff, for: .normal)
        }
        if let data = row.imageData{
            cell.img.image = UIImage(data: data)
        }else{
            URLSession(configuration: .default).dataTask(with: URL(string: row.imageUrl
                )!) { (data, response, error) in
                    if error == nil && data != nil && self.goodsArray.count != 0{
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









extension SearchViewController: UICollectionViewDelegate{
    
}
extension SearchViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 10
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.goodsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchCollectionCell", for: indexPath) as! SearchCollectionCell
        cell.delegate = self
        var row = self.goodsArray[indexPath.row]
        cell.title.text = row.title
        cell.price.text = "\(row.price) 원"
        if row.isHeart == true{
            cell.heart.setImage(self.heartOn, for: .normal)
        }else{
            cell.heart.setImage(self.heartOff, for: .normal)
        }
        if let data = row.imageData{
            cell.img.image = UIImage(data: data)
        }else{
            URLSession(configuration: .default).dataTask(with: URL(string: row.imageUrl
                )!) { (data, response, error) in
                    if error == nil && data != nil && self.goodsArray.count != 0{
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










extension SearchViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text?.characters.count != 0{
            self.goodsArray = [GoodsVO]()
            self.pageIndex = 1
            self.view.endEditing(true)
            self.spin.isHidden = false
            self.spin.startAnimating()
            DispatchQueue.global(qos: .default).async {
                self.resultHtml(textField.text!)
            }
            return false
        }
        return true
    }
}










extension SearchViewController: SearchDelegate{
    func searchTableViewAction(_ cell: UITableViewCell) {
        if let indexPath = self.tableView.indexPath(for: cell){
            let url = self.goodsArray[indexPath.row].detailUrl
            if #available(iOS 8.0, *) {
                UIApplication.shared.openURL(NSURL(string: url) as! URL)
            }else{
                UIApplication.shared.open(NSURL(string: url) as! URL, options: [:], completionHandler: nil)
            }
        }
    }
    func searchCollectionViewAction(_ cell: UICollectionViewCell) {
        if let indexPath = self.collectionView.indexPath(for: cell){
            let url = self.goodsArray[indexPath.row].detailUrl
            if #available(iOS 8.0, *) {
                UIApplication.shared.openURL(NSURL(string: url) as! URL)
            }else{
                UIApplication.shared.open(NSURL(string: url) as! URL, options: [:], completionHandler: nil)
            }
        }
    }
    func searchTableHeartAction(_ cell: UITableViewCell, btn: UIButton) {
        if let indexPath = self.tableView.indexPath(for: cell){
            self.heartAction(indexPath, btn: btn){
                self.collectionView.reloadData()
            }
        }
    }
    func searchCollectionHeartAction(_ cell: UICollectionViewCell, btn: UIButton) {
        if let indexPath = self.collectionView.indexPath(for: cell){
            self.heartAction(indexPath, btn: btn){
                self.tableView.reloadData()
            }
        }
    }
    
    func heartAction(_ indexPath: IndexPath, btn: UIButton, handle: ((Void) -> Void)){
        self.goodsArray[indexPath.row].isHeart = !self.goodsArray[indexPath.row].isHeart
        let row = self.goodsArray[indexPath.row]
        handle()
        if row.isHeart == true{
            self.heartOnAction(row)
        }else{
            self.heartOffAction(row)
        }
        UIView.animate(withDuration: 0.2, animations: {
            btn.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        }) { (_) in
            UIView.animate(withDuration: 0.2, animations: {
                btn.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
                if row.isHeart == true{
                    btn.setImage(self.heartOn, for: .normal)
                }else{
                    btn.setImage(self.heartOff, for: .normal)
                }
            }) { (_) in
                UIView.animate(withDuration: 0.2, animations: {
                    btn.transform = CGAffineTransform(scaleX: 1, y: 1)
                })
            }
        }
    }
}



extension SearchViewController: HeartDelegate{
    func heartOff(_ goods: GoodsVO) {
        var idx = 0
        for goodsVO in self.goodsArray{
            if goods.detailUrl == goodsVO.detailUrl{
                self.goodsArray[idx].isHeart = false
                self.tableView.reloadData()
                self.collectionView.reloadData()
            }else if goods.title == goodsVO.title && goods.imageUrl == goodsVO.imageUrl && goods.price == goodsVO.price{
                self.goodsArray[idx].isHeart = false
                self.tableView.reloadData()
                self.collectionView.reloadData()
            }
            idx += 1
        }
    }
}




extension SearchViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PresentMenuAnimator(direction: Direction.right, snapshotNumber: NavHelper.snapshotNumber, menuWidth: NavHelper.menuWidth)
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissMenuAnimator(snapshotNumber: NavHelper.snapshotNumber)
    }
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStarted ? interactor : nil
    }
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStarted ? interactor : nil
    }
}
