//
//  ViewController.swift
//  Lotto
//
//  Created by guanho on 2016. 11. 23..
//  Copyright © 2016년 guanho. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var lottoNumbers = Array<Array<Int>>()
    @IBOutlet var tb: UITableView!
    var databasePath = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fileMgr = FileManager.default
        let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let docsDir = dirPaths[0]
        self.databasePath = "\(docsDir)/lotto.db"
        
        if !fileMgr.fileExists(atPath: self.databasePath as String){
            let db = FMDatabase(path: self.databasePath as String)
            if db == nil{
                NSLog("DB 생성 오류")
            }
            if((db?.open()) != nil){
                let sql_statement = "Create table if not exists lotto(id integer primary key autoincrement, number1 integer, number2 integer, number3 integer, number4 integer, number5 integer, number6 integer)"
                if !((db?.executeStatements(sql_statement))!){
                    NSLog("테이블 생성 오류")
                }
                db?.close()
            }else{
                NSLog("DB 연결 오류")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func doDraw(_ sender: UIBarButtonItem) {
        lottoNumbers = Array<Array<Int>>()
        
        var originalNumbers = Array(1 ... 45)
        var index = 0
        
        for _ in 0 ... 4{
            originalNumbers = Array(1 ... 45)
            var columnArray = Array<Int>()
            
            for _ in 0 ... 5{
                index = Int(arc4random_uniform(UInt32(originalNumbers.count)))
                columnArray.append(originalNumbers[index])
                originalNumbers.remove(at: index)
            }
            
            columnArray.sort(by: { $0 < $1 })
            lottoNumbers.append(columnArray)
        }
        
        tb.reloadData()
    }
    @IBAction func loadData(_ sender: UIBarButtonItem) {
        lottoNumbers = Array<Array<Int>>()
        let db = FMDatabase(path: self.databasePath as String)
        
        if((db?.open()) != nil){
            let selectQuery = "select number1, number2, number3, number4, number5, number6 from lotto"
            let result: FMResultSet? = db?.executeQuery(selectQuery, withArgumentsIn: nil)
            
            if result != nil{
                while result!.next(){
                    var columnArray = Array<Int>()
                    columnArray.append(Int(result!.string(forColumn: "number1"))!)
                    columnArray.append(Int(result!.string(forColumn: "number2"))!)
                    columnArray.append(Int(result!.string(forColumn: "number3"))!)
                    columnArray.append(Int(result!.string(forColumn: "number4"))!)
                    columnArray.append(Int(result!.string(forColumn: "number5"))!)
                    columnArray.append(Int(result!.string(forColumn: "number6"))!)
                    lottoNumbers.append(columnArray)
                }
            }
            self.tb.reloadData()
        }
    }
    @IBAction func saveData(_ sender: UIBarButtonItem) {
        let db = FMDatabase(path: self.databasePath as String)
        
        if((db?.open()) != nil){
            let _ = db?.executeUpdate("delete from lotto", withArgumentsIn: nil)
            if ((db?.hadError()) != nil){
                NSLog("DB 초기화 오류")
            }
            for numbers in lottoNumbers{
                let insertQuery = "insert into lotto(number1, number2, number3, number4, number5, number6) values(\(numbers[0]), \(numbers[1]), \(numbers[2]), \(numbers[3]), \(numbers[4]), \(numbers[5]))"
                let _ = db?.executeUpdate(insertQuery, withArgumentsIn: nil)
            }
        }
    }
    
}

extension ViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int{
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return lottoNumbers.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "lottoCell", for: indexPath as IndexPath) as! LottoCell
        let row: Int = indexPath.row
        cell.n1.text = "\(lottoNumbers[row][0])"
        cell.n2.text = "\(lottoNumbers[row][1])"
        cell.n3.text = "\(lottoNumbers[row][2])"
        cell.n4.text = "\(lottoNumbers[row][3])"
        cell.n5.text = "\(lottoNumbers[row][4])"
        cell.n6.text = "\(lottoNumbers[row][5])"
        
        return cell
    }
}
