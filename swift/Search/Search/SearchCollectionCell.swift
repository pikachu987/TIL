//
//  SearchCollectionCell.swift
//  Search
//
//  Created by guanho on 2017. 2. 3..
//  Copyright © 2017년 guanho. All rights reserved.
//

import UIKit

class SearchCollectionCell: UICollectionViewCell {
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var price: UILabel!
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
    }
    @IBAction func viewAction(_ sender: UIButton) {
        self.delegate?.searchCollectionViewAction(self)
    }
    @IBAction func heartAction(_ sender: UIButton) {
        self.delegate?.searchCollectionHeartAction(self, btn: sender)
    }
}
