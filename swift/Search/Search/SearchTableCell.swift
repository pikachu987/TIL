//
//  SearchTableCell.swift
//  Search
//
//  Created by guanho on 2017. 2. 3..
//  Copyright © 2017년 guanho. All rights reserved.
//

import UIKit

@objc protocol SearchDelegate {
    @objc optional func searchTableViewAction(_ cell: UITableViewCell)
    @objc optional func searchCollectionViewAction(_ cell: UICollectionViewCell)
    @objc optional func searchTableHeartAction(_ cell: UITableViewCell, btn: UIButton)
    @objc optional func searchCollectionHeartAction(_ cell: UICollectionViewCell, btn: UIButton)
}

class SearchTableCell: UITableViewCell {
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var heart: UIButton!
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
    }
    @IBAction func viewAction(_ sender: UIButton) {
        self.delegate?.searchTableViewAction?(self)
    }
    @IBAction func heartAction(_ sender: UIButton) {
        self.delegate?.searchTableHeartAction?(self, btn: sender)
    }
}
