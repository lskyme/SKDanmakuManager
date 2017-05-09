//
//  SKDanmakuManager.h
//
//  Copyright © 2017年 Lskyme. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <CoreAudioKit/CoreAudioKit.h>

/* The manager of danmakus */
@interface SKDanmakuManager : NSObject <CAAnimationDelegate>

/* The layer display danmakus.
 * It should not be nil after initialized. */
@property(nonatomic, strong) CALayer *layer;

/* The maximum value of danmaku‘s movement speed.
 *Defaults to 100. */
@property(nonatomic, assign) float maxSpeed;

/* The minimum value of danmaku‘s movement speed. 
 * Defaults to 50. */
@property(nonatomic, assign) float minSpeed;

/* The spacing of two danmakus where in the tow adjacent tracks.
 * If set during playing, the manager will remove all playing danmakus, and rebuild all tracks.
 * Defaults to 0. */
@property(nonatomic, assign) CGFloat verticalSpacing;

/* The spacing of two danmakus where in same track.
 * Defaults to 0. */
@property(nonatomic, assign) CGFloat horizontalSpacing;

/* When true danmakus were paused. 
 * Call sk_pauseDanmakus() or sk_resumeDanmakus() to change this value.
 * Defaults to true. */
@property(nonatomic, assign, readonly) BOOL isPlaying;

/* When false danmakus were hidden.
 * Call sk_showDanmakus() or sk_hideDanmakus() to change this value.
 * Defaults to true. */
@property(nonatomic, assign, readonly) BOOL isShowing;

/* The custom font name of danmaku's text.
 * If you set a error font name, manager will use system font.
 * Defaults to Helvetica font. */
@property(nonatomic, strong) NSString *fontName;

/* The font size of danmaku's text. 
 * Defaults to 15. */
@property(nonatomic, assign) CGFloat fontSize;

/* When true the manager allow danmakus covered each other. 
 * Defaults to true. */
@property(nonatomic, assign) BOOL allowCovered;

/**
 The main initialization method. 
 Make sure 'layer' must not be nil.
 @param layer the layer of video's view
 @return danmakus manager
 */
+(instancetype)managerWithLayer:(CALayer *)layer;

/**
 Create a danmaku.
 Danmaku will not be created if 'text' is empty or nil, or if 'color' is nil, danmaku's text
 will defaults to white color.
 @param text danmaku's text
 @param color text color
 */
-(void)createDanmakuWithText:(NSString *)text color:(UIColor *)color;

/** 
 Pause all playing danmakus or ready to play.
 */
-(void)pauseDanmakus;

/** 
 Resume all danmakus if them were paused.
 */
-(void)resumeDanmakus;

/** 
 Hide all playing danmakus or ready to play.
 */
-(void)hideDanmakus;

/** 
 Show all danmakus if them were hidden.
 */
-(void)showDanmakus;

/**
 layout if layer's frame changed.
 If the frame of layer changed(eg. video into Full-screen), call this method to rebuild all tracks
 by reset font size of danmaku. If the value of size is 0.0, fontSize will not be changed.
 @param size the font size of danmaku.
 */
-(void)layoutDanmakusWithFontSize:(CGFloat)size;

@end
