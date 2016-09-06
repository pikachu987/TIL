//
//  KOEventLog.h
//  kakao-open-sdk-ios
//
//  Created by Richard Jeon on 2016. 8. 25..
//  Copyright © 2016년 Kakao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KOEventLog : NSObject

@property (readonly) NSDate *time;
@property (readonly) NSString *from;
@property (readonly) NSString *to;
@property (readonly) NSString *action;
@property (readonly) NSDictionary<NSString *, id> *props;

+ (instancetype)eventWithAction:(NSString *)action from:(NSString *)from to:(NSString *)to;
+ (instancetype)eventWithAction:(NSString *)action from:(NSString *)from to:(NSString *)to props:(NSDictionary<NSString *, id> *)props;
- (instancetype)initWithAction:(NSString *)action from:(NSString *)from to:(NSString *)to;
- (instancetype)initWithAction:(NSString *)action from:(NSString *)from to:(NSString *)to props:(NSDictionary<NSString *, id> *)props;

@end
