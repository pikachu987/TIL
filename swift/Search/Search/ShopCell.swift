//
//  ShopCell.swift
//  Search
//
//  Created by guanho on 2017. 2. 5..
//  Copyright © 2017년 guanho. All rights reserved.
//

import UIKit

protocol ShopDelegate {
    func shop(_ cell: UITableViewCell)
}

class ShopCell: UITableViewCell {
    @IBOutlet weak var shop: UILabel!
    @IBOutlet weak var service: UILabel!
    @IBOutlet weak var year: UILabel!
    var delegate: ShopDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.touchAction)))
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.shop.text = ""
        self.service.text = ""
        self.year.text = ""
    }
    
    func touchAction(){
        self.delegate?.shop(self)
    }
}
