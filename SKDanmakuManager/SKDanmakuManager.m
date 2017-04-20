//
//  SKDanmakuManager.m
//
//  Copyright © 2017年 Lskyme. All rights reserved.
//

#import "SKDanmakuManager.h"
#import "SKDanmaku.h"
#import "SKDanmakuTrack.h"

@interface SKDanmakuManager()

@property(nonatomic, assign, readwrite) BOOL isPlaying;
@property(nonatomic, assign, readwrite) BOOL isShowing;
@property(nonatomic, strong) NSMutableArray *playingDanmakus;
@property(nonatomic, strong) NSMutableArray *tracks;

@end

@implementation SKDanmakuManager

+(instancetype)managerWithLayer:(CALayer *)layer {
    SKDanmakuManager *manager = [[SKDanmakuManager alloc] init];
    if (manager) {
        manager.layer = layer;
    }
    return manager;
}

-(instancetype)init {
    self = [super init];
    if (self) {
        self.maxSpeed = 100;
        self.minSpeed = 50;
        self.verticalSpacing = 0;
        self.horizontalSpacing = 0;
        self.isPlaying = YES;
        self.isShowing = YES;
        self.fontSize = 15;
        self.allowCovered = YES;
        self.playingDanmakus = [[NSMutableArray alloc] init];
        self.tracks = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)setLayer:(CALayer *)layer {
    if (_layer != layer) {
        _layer = layer;
        [self initTracks];
    }
}

-(void)setVerticalSpacing:(CGFloat)verticalSpacing {
    if (_verticalSpacing != verticalSpacing) {
        _verticalSpacing = verticalSpacing;
        [self layoutDanmakusWithFontSize:_fontSize];
    }
}

-(void)setFontSize:(CGFloat)fontSize {
    if (_fontSize != fontSize) {
        _fontSize = fontSize;
        [self layoutDanmakusWithFontSize:_fontSize];
    }
}

-(void)createDanmakuWithText:(NSString *)text color:(UIColor *)color {
    if (text == nil) {
        return;
    }
    if ([text isEqualToString:@""]) {
        return;
    }
    float randomSpeed = (arc4random() % (int)(_maxSpeed - _minSpeed) + 1) + _minSpeed;
    SKDanmaku *danmaku = [SKDanmaku danmakuWithText:text color:color != nil ? color: [UIColor whiteColor] speed:randomSpeed fontSize:_fontSize];
    [danmaku setHidden:!_isShowing];
    [self customWithDanmaku:danmaku];
}

-(void)pauseDanmakus {
    _isPlaying = NO;
    for (SKDanmaku *danmaku in _playingDanmakus) {
        [danmaku pause];
    }
}

-(void)resumeDanmakus {
    _isPlaying = YES;
    for (SKDanmaku *danmaku in _playingDanmakus) {
        [danmaku resume];
    }
}

-(void)hideDanmakus {
    _isShowing = NO;
    for (SKDanmaku *danmaku in _playingDanmakus) {
        [danmaku hide];
    }
}

-(void)showDanmakus {
    _isShowing = YES;
    for (SKDanmaku *danmaku in _playingDanmakus) {
        [danmaku show];
    }
}

-(void)layoutDanmakusWithFontSize:(CGFloat)size {
    [self clearTracksAndDanmakus];
    if (_layer) {
        if (size != 0.0) {
            _fontSize = size;
        }
        [self initTracks];
    }
}

#pragma mark - Private

/** 
 Remove all playing danmakus and tracks.
 */
-(void)clearTracksAndDanmakus {
    for (SKDanmaku *danmaku in _playingDanmakus) {
        [danmaku removeAllAnimations];
        [danmaku removeFromSuperlayer];
    }
    [_playingDanmakus removeAllObjects];
    [_tracks removeAllObjects];
}

/**
 Build all useful tracks according to the layer's frame.
 */
-(void)initTracks {
    CGFloat trackHeight = [self calculateTrackHeight];
    CGFloat trackMaxY = _layer.bounds.size.height;
    CGFloat danmakuBeginX = _layer.bounds.size.width;
    int trackCount = trackMaxY / (trackHeight + _verticalSpacing);
    for (int i = 0; i < trackCount; i++) {
        SKDanmakuTrack *track = [SKDanmakuTrack trackWithOrigin:CGPointMake(danmakuBeginX, i * (trackHeight + _verticalSpacing))];
        [_tracks addObject:track];
    }
}
/**
 Custom the danmaku's track, frame and play it.
 If manager dont't allow danmakus coverd each other, it will reset the danmaku's speed
 to ensure the last danmaku where in the same track and this danmaku will not covered between.
 @param danmaku danmaku
 */
-(void)customWithDanmaku:(SKDanmaku *)danmaku {
    int trackNumber = 0;
    SKDanmakuTrack *track = nil;
    if (_tracks.count > 0) {
        trackNumber = arc4random() % _tracks.count;
        track = _tracks[trackNumber];
    }
    if (track) {
        danmaku.playOnTrack = track;
        CGFloat danmakuWidth = [danmaku calculateDanmakuWidth];
        danmaku.frame = CGRectMake(track.origin.x, track.origin.y, danmakuWidth + _horizontalSpacing, [self calculateTrackHeight]);
        [_layer addSublayer:danmaku];
        if (!_allowCovered) {
            SKDanmaku *lastDanmaku = nil;
            for (SKDanmaku *tmpDanmaku in _playingDanmakus) {
                if (tmpDanmaku.playOnTrack == track) {
                    lastDanmaku = tmpDanmaku;
                }
            }
            if (lastDanmaku) {
                [self coveredCheckWithNextDanmaku:danmaku previousDanmaku:lastDanmaku];
            }
        }
        [_playingDanmakus addObject:danmaku];
        [self playWithDanmaku:danmaku];
    }
}

/**
 Custom the animation parameters.
 @param danmaku danmaku
 */
-(void)playWithDanmaku:(SKDanmaku *)danmaku {
    CFTimeInterval animationDuration = (danmaku.frame.size.width + danmaku.frame.origin.x) / danmaku.moveSpeed;
    CGFloat animationEndX = _layer.bounds.origin.x - danmaku.frame.size.width;
    [self addAnimationWithDanmaku:danmaku duration:animationDuration toX:animationEndX];
}

/**
 Add animation to the danmaku.
 @param danmaku danmaku
 @param duration animation duration
 @param endX animation end coordinate of x
 */
-(void)addAnimationWithDanmaku:(SKDanmaku *)danmaku duration:(CFTimeInterval)duration toX:(CGFloat)endX {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position.x"];
    animation.delegate = self;
    animation.fromValue = [NSNumber numberWithFloat:danmaku.frame.origin.x];
    animation.toValue = [NSNumber numberWithFloat:endX];
    animation.duration = duration;
    animation.speed = 1.0;
    [animation setRemovedOnCompletion:NO];
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [danmaku addAnimation:animation forKey:@"danmakuAnimation"];
    if (!_isPlaying) {
        [danmaku pause];
    }
}

/**
 Calculate the height of tracks according to the font size of danmaku.
 @return the height of track
 */
-(CGFloat)calculateTrackHeight {
    NSString *str = @"";
    UIFont *font = [UIFont systemFontOfSize:_fontSize];
    NSDictionary *attrs = @{NSFontAttributeName: font};
    CGSize size = [str boundingRectWithSize:CGSizeMake(100.0, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
    return size.height + 5;
}

/**
 Reset danmaku's speed to ensure the previous danmaku and the next danmaku will not
 covered between.
 @param nextDanmaku the danmaku who will playing
 @param previousDanmaku the danmaku where in the same track with next danmaku
 */
-(void)coveredCheckWithNextDanmaku:(SKDanmaku *)nextDanmaku previousDanmaku:(SKDanmaku *)previousDanmaku {
    SKDanmaku *presentationDanmaku = previousDanmaku.presentationLayer;
    if (presentationDanmaku) {
        CFTimeInterval previousTime = (presentationDanmaku.frame.origin.x + presentationDanmaku.frame.size.width) / previousDanmaku.moveSpeed;
        if (presentationDanmaku.frame.origin.x + presentationDanmaku.frame.size.width > _layer.bounds.size.width) {
            CGRect tmpFrame = nextDanmaku.frame;
            tmpFrame.origin.x += presentationDanmaku.frame.origin.x + presentationDanmaku.frame.size.width - _layer.bounds.size.width;
            nextDanmaku.frame = tmpFrame;
        }
        float nextMaxSpeed = nextDanmaku.frame.origin.x / previousTime;
        if (nextMaxSpeed < _minSpeed) {
            nextMaxSpeed = _minSpeed;
        }
        if (nextMaxSpeed > _maxSpeed) {
            nextMaxSpeed = _maxSpeed;
        }
        float nextRandomSpeed = (arc4random() % (int)(nextMaxSpeed - _minSpeed + 1)) + _minSpeed;
        nextDanmaku.moveSpeed = nextRandomSpeed;
    }
}

#pragma mark - CAAnimationDelegate

/**
 Animation's delegate, release danmaku when it aniamtion finished.
 */
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    SKDanmaku *removedDanmaku = nil;
    if (flag) {
        for (int i = 0; i < _playingDanmakus.count; i++) {
            SKDanmaku *danmaku = _playingDanmakus[i];
            if ([danmaku animationForKey:@"danmakuAnimation"] == anim) {
                removedDanmaku = danmaku;
                break;
            }
        }
        if (removedDanmaku) {
            [removedDanmaku removeAllAnimations];
            [removedDanmaku removeFromSuperlayer];
            [_playingDanmakus removeObject:removedDanmaku];
        }
    }
}

@end
