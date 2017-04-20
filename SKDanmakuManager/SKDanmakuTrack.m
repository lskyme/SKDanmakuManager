//
//  SKDanmakuTrack.m
//
//  Copyright © 2017年 Lskyme. All rights reserved.
//

#import "SKDanmakuTrack.h"

@implementation SKDanmakuTrack

+(instancetype)trackWithOrigin:(CGPoint)origin {
    return [[SKDanmakuTrack alloc] initWithOrigin:origin];
}

-(instancetype)initWithOrigin:(CGPoint)origin {
    self = [self init];
    if (self) {
        self.origin = origin;
    }
    return self;
}

-(instancetype)init {
    self = [super init];
    if (self) {
        self.origin = CGPointMake(0, 0);
    }
    return self;
}

@end
