//
//  Book.h
//  BookManager
//
//  Created by guanho on 2017. 1. 17..
//  Copyright © 2017년 guanho. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Book : NSObject

//기본값 = atomic 원자와 동시에 접근못함, 하나하나씩 접근해서 값을바꿈, 속도느림
//nonatomic 동시에 접근 가능
//strong = 기본값
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *genre;
@property (nonatomic, strong) NSString *author;

-(void)bookPrint;

@end
