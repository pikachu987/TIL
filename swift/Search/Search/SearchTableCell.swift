//
//  SearchTableCell.swift
//  Search
//
//  Created by guanho on 2017. 2. 3..
//  Copyright © 2017년 guanho. All rights reserved.
//

import UIKit

protocol SearchDelegate {
    func searchTableViewAction(_ cell: UITableViewCell)
    func searchCollectionViewAction(_ cell: UICollectionViewCell)
    func searchTableHeartAction(_ cell: UITableViewCell, btn: UIButton)
    func searchCollectionHeartAction(_ cell: UICollectionViewCell, btn: UIButton)
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
        self.delegate?.searchTableViewAction(self)
    }
    @IBAction func heartAction(_ sender: UIButton) {
        self.delegate?.searchTableHeartAction(self, btn: sender)
    }
}
