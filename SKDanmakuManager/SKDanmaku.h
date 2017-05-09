//
//  SKDanmaku.h
//
//  Copyright © 2017年 Lskyme. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
#import "SKDanmakuTrack.h"

/* The base danmaku class */
@interface SKDanmaku : CATextLayer

/* The track of danmaku.
 * It must not be nil if danmaku could play. */
@property(nonatomic, strong) SKDanmakuTrack *playOnTrack;

/* The speed of animation.
 * Defaults to 0. */
@property(nonatomic, assign) float moveSpeed;

/**
 The main convenience constructor.
 @param text danmaku's text
 @param color text color
 @param speed the speed of animation
 @param font the font of danmaku
 @return danmaku
 */
+(instancetype)danmakuWithText:(NSString *)text color:(UIColor *)color speed:(float)speed font:(UIFont *)font;

/**
 Calculate the width of the danmaku according to the font size of danmaku's text
 @return the width of the danmaku
 */
-(CGFloat)calculateDanmakuWidth;

/** 
 Pause danmaku.
 */
-(void)pause;

/** 
 Resume danmaku if it has paused.
 */
-(void)resume;

/** 
 Hide danmaku.
 */
-(void)hide;

/** 
 Show danmaku if it has hidden.
 */
-(void)show;

@end
