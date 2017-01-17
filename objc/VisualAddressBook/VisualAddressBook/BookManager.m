//
//  BookManager.m
//  BookManager
//
//  Created by guanho on 2017. 1. 17..
//  Copyright © 2017년 guanho. All rights reserved.
//

#import "BookManager.h"

@implementation BookManager

- (id)init{
    self = [super init];
    if (self) {
        bookList = [[NSMutableArray alloc]init];
    }
    return self;
}

- (void)addBook:(Book *)bookObject{
    [bookList addObject:bookObject];
}
- (NSString *)showAllBook{
    NSMutableString *strTmp = [[NSMutableString alloc]init];
    for (Book *bookTmp in bookList) {
        [strTmp appendString:@"Name : "];
        [strTmp appendString:bookTmp.name];
        [strTmp appendString:@"\r\n"];
        [strTmp appendString:@"Genre : "];
        [strTmp appendString:bookTmp.genre];
        [strTmp appendString:@"\r\n"];
        [strTmp appendString:@"Author : "];
        [strTmp appendString:bookTmp.author];
        [strTmp appendString:@"\r\n-------------------\r\n"];
    }
    return strTmp;
}
- (NSUInteger)countBook{
    return [bookList count];
}

- (NSString *)findBook:(NSString *)name{
    NSMutableString *strTmp = [[NSMutableString alloc]init];
    for (Book *bookTmp in bookList) {
        if([bookTmp.name isEqualToString:name]){
            [strTmp appendString:@"Name : "];
            [strTmp appendString:bookTmp.name];
            [strTmp appendString:@"\r\n"];
            [strTmp appendString:@"Genre : "];
            [strTmp appendString:bookTmp.genre];
            [strTmp appendString:@"\r\n"];
            [strTmp appendString:@"Author : "];
            [strTmp appendString:bookTmp.author];
            return strTmp;
        }
    }
    return nil;
}

- (NSString *)removeBook:(NSString *)name{
    for (Book *bookTmp in bookList) {
        if([bookTmp.name isEqualToString:name]){
            [bookList removeObject:bookTmp];
            return name;
        }
    }
    return nil;
}
@end
