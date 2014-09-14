//
//  TRMixierManager.h
//  Rapper
//
//  Created by 雪本大樹 on 2014/08/12.
//  Copyright (c) 2014年 tolve. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface TRMixierManager : NSObject

+(TRMixierManager *)defaultManager;

@property (readwrite) double samplingRate;

- (void)startInitData;
- (void)stopAUgraph;

@end
