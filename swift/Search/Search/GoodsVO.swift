//
//  ProductVO.swift
//  Search
//
//  Created by guanho on 2017. 2. 3..
//  Copyright © 2017년 guanho. All rights reserved.
//

import Foundation

struct GoodsVO {
    var imageUrl: String
    var imageData: Data?
    var title: String
    var price: String
    var date: String
    var detailUrl: String
    var isHeart: Bool = false
    
    init(img: String, title: String, price: String, date: String, detailUrl: String) {
        self.imageUrl = img
        self.title = title
        self.price = price
        self.date = date
        self.detailUrl = detailUrl
    }
}
