//
//  Book.m
//  BookManager
//
//  Created by guanho on 2017. 1. 17..
//  Copyright © 2017년 guanho. All rights reserved.
//

#import "Book.h"

@implementation Book

- (void)bookPrint{
    NSLog(@"Name : %@", self.name);
    NSLog(@"Genre : %@", self.genre);
    NSLog(@"Author : %@", self.author);
}
@end
