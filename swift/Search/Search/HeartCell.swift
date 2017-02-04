//
//  HeartCell.swift
//  Search
//
//  Created by guanho on 2017. 2. 5..
//  Copyright © 2017년 guanho. All rights reserved.
//

import UIKit

class HeartCell: UITableViewCell {
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var saveDT: UILabel!
    var delegate: SearchDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.img.image = nil
        self.title.text = ""
        self.price.text = ""
        self.date.text = ""
        self.saveDT.text = ""
    }
    @IBAction func viewAction(_ sender: UIButton) {
        self.delegate?.searchTableViewAction?(self)
    }
    @IBAction func heartAction(_ sender: UIButton) {
        self.delegate?.searchTableHeartAction?(self, btn: sender)
    }
}
