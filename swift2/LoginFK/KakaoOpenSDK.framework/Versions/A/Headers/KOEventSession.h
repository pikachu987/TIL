/**
 * Copyright 2015-2016 Kakao Corp.
 *
 * Redistribution and modification in source or binary forms are not permitted without specific prior written permission.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/*!
 @header KOEventSession.h
 카카오계정을 통해 인증 및 로그아웃할 수 있는 기능을 제공합니다.
 */

#import <Foundation/Foundation.h>
#import "KOEventLog.h"

/*!
 * @class KOEventSession
 * @abstract S2 이벤트 관리 클래스.
 */
@interface KOEventSession : NSObject

/*!
 @abstract 현재 session 정보
 */
+ (KOEventSession *)sharedSession;

//- (void)addSingleEvent:(KOEventLog *)event completion:(void(^)(NSError *error))completion;
//- (void)addMultipleEvents:(NSArray<KOEventLog *> *)events completion:(void(^)(NSInteger count, NSError *error))completion;
- (void)addEvent:(KOEventLog *)event;
- (void)sendEventsWithCompletion:(void(^)(NSError *error))completion;

@end
