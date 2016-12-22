//
//  TheaterListController.swift
//  MovieChart
//
//  Created by guanho on 2016. 12. 21..
//  Copyright © 2016년 guanho. All rights reserved.
//

import UIKit

class TheaterListController: UITableViewController {
    var list = [NSDictionary]()
    
    var startPoint = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.callTheaterAPI()
    }
    
    func callTheaterAPI(){
        let requestURI = "http://swiftapi.rubypaper.co.kr:2029/theater/list"
        let sList = 100
        let type = "json"
        
        let urlObj = URL(string: "\(requestURI)?s_page=\(self.startPoint)&s_list=\(sList)&type=\(type)")
        
        do{
            let stringdata = try NSString(contentsOf: urlObj!, encoding: 0x80_000_422)
            let encdata = stringdata.data(using: String.Encoding.utf8.rawValue)
            
            do{
                let apiArray = try JSONSerialization.jsonObject(with: encdata!, options: []) as? NSArray
                for obj in apiArray!{
                    self.list.append(obj as! NSDictionary)
                }
            }catch{
                
            }
            self.startPoint += sList
        }catch{
            
        }
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let obj = self.list[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "tCell") as! TheaterCell
        cell.name?.text = obj["상영관명"] as? String
        cell.tel?.text = obj["연락처"] as? String
        cell.addr?.text = obj["소재지도로명주소"] as? String
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segue_map"{
            let path = self.tableView.indexPath(for: sender as! UITableViewCell)
            let data = self.list[path!.row]
            (segue.destination as? TheaterViewController)?.param = data
        }
    }
}
