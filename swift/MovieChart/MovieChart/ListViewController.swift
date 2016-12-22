//
//  ListViewController.swift
//  MovieChart
//
//  Created by guanho on 2016. 12. 21..
//  Copyright © 2016년 guanho. All rights reserved.
//

import UIKit

class ListViewController: UITableViewController {
    
//    lazy var list : [MovieVo] = {
//        var dataList = [MovieVo]()
//        var mvo = MovieVo()
//        mvo.title = "다크나이트"
//        mvo.description = "영웅물에 철학......예술이되다"
//        mvo.opendate = "2008-09-04"
//        mvo.rating = 8.95
//        
//        dataList.append(mvo)
//        
//        mvo = MovieVo()
//        mvo.title = "호우시절"
//        mvo.description = "때를 알고어쩌고"
//        mvo.opendate = "2009-10-18"
//        mvo.rating = 7.31
//        
//        dataList.append(mvo)
//        
//        mvo = MovieVo()
//        mvo.title = "말할수없는 비밀"
//        mvo.description = "여기서 너까지 다섯걸음"
//        mvo.opendate = "2009-10-10"
//        mvo.rating = 7.39
//        
//        dataList.append(mvo)
//        
//        return dataList
//    }()
    lazy var list: [MovieVo] = {
        var datalist = [MovieVo]()
        return datalist
    }()
    
    
    var page = 1
    var isAdd = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.tableView.estimatedRowHeight = 80
        //self.tableView.rowHeight = UITableViewAutomaticDimension
        
        
        self.add()
        
    }
    
    func add(){
        if self.isAdd == false{
            return
        }
        let url = "http://swiftapi.rubypaper.co.kr:2029/hoppin/movies?version=1&page=\(self.page)&count=10&genreId=&order=releasedateasc"
        let apiURI : URL! = URL(string: url)
        let apidata = try! Data(contentsOf: apiURI)
        do{
            let apiDic = try JSONSerialization.jsonObject(with: apidata, options: []) as! NSDictionary
            
            let hoppin = apiDic["hoppin"] as! NSDictionary
            let totalCnt = (hoppin["totalCount"] as? NSString)!.integerValue
            
            if self.list.count >= totalCnt{
                self.isAdd = false
            }
            let movies = hoppin["movies"] as! NSDictionary
            let movie = movies["movie"] as! NSArray
            
            for row in movie{
                let r = row as! NSDictionary
                let mvo = MovieVo()
                mvo.title = r["title"] as? String
                mvo.description = r["genreNames"] as? String
                mvo.thumbnail = r["thumbnailImage"] as? String
                mvo.detail = r["linkUrl"] as? String
                mvo.rating = (r["ratingAverage"] as! NSString).doubleValue
                mvo.detail = r["linkUrl"] as? String
                self.list.append(mvo)
            }
            self.tableView.reloadData()
            self.page += 1
        }catch{
            
        }
    }
    
    
    func getThumbnailImage(_ index: Int) -> UIImage{
        let mvo = self.list[index]
        if let savedImage = mvo.thumbnailImage{
            return savedImage
        }else{
            let url: URL! = URL(string: mvo.thumbnail!)
            let imageData = try! Data(contentsOf: url)
            mvo.thumbnailImage = UIImage(data: imageData)
            return mvo.thumbnailImage!
        }
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = self.list[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell") as! MovieCell
//        (cell.viewWithTag(101) as? UILabel)?.text = row.title
//        (cell.viewWithTag(102) as? UILabel)?.text = row.description
//        (cell.viewWithTag(103) as? UILabel)?.text = row.opendate
//        (cell.viewWithTag(104) as? UILabel)?.text = "\(row.rating!)"
        cell.title.text = row.title
        cell.desc.text = row.description
        cell.opendate.text = row.opendate
        cell.rating.text = "\(row.rating!)"
        
        DispatchQueue.main.async {
            cell.thumbnail.image = self.getThumbnailImage(indexPath.row)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        let deltaOffset = maximumOffset - currentOffset
        if deltaOffset <= 0{
            if scrollView == self.tableView{
                self.add()
            }
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segue_detail"{
            let path = self.tableView.indexPath(for: sender as! MovieCell)
            let detailVC = segue.destination as? DetailViewController
            detailVC?.mvo = self.list[path!.row]
        }
    }
}
