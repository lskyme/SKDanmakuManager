//
//  SKDanmakuTrack.h
//
//  Copyright © 2017年 Lskyme. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

/* The base danmaku track */
@interface SKDanmakuTrack : NSObject

/* The track's original point, It‘s the starting point of animation.
 * Defaults to (0, 0). */
@property(nonatomic, assign) CGPoint origin;

/** 
 The main convenience constructor.
 @param origin track's original point
 @return track
 */
+(instancetype)trackWithOrigin:(CGPoint)origin;

@end
