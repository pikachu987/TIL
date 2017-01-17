//
//  BookManager.h
//  BookManager
//
//  Created by guanho on 2017. 1. 17..
//  Copyright © 2017년 guanho. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Book.h"

@interface BookManager : NSObject{
    NSMutableArray *bookList;
}

-(void)addBook:(Book *)bookObject;
-(NSString *)showAllBook;
-(NSUInteger)countBook;
-(NSString *)findBook:(NSString *)name;
-(NSString *)removeBook:(NSString *)name;
@end
