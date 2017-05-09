//
//  SKDanmaku.m
//
//  Copyright © 2017年 Lskyme. All rights reserved.
//

#import "SKDanmaku.h"

@interface SKDanmaku()

@property(nonatomic, strong) NSString *fontName;

@end

@implementation SKDanmaku

+(instancetype)danmakuWithText:(NSString *)text color:(UIColor *)color speed:(float)speed font:(UIFont *)font {
    return [[SKDanmaku alloc] initWithText:text color:color speed:speed font:font];
}

-(instancetype)initWithText:(NSString *)text color:(UIColor *)color speed:(float)speed font:(UIFont *)font {
    self = [self init];
    if (self) {
        self.backgroundColor = [UIColor clearColor].CGColor;
        self.foregroundColor = color.CGColor;
        [self setWrapped:YES];
        CFTypeRef fontRef = (__bridge CFTypeRef)(font.fontName);
        self.font = fontRef;
        self.fontSize = font.pointSize;
        self.contentsScale = [UIScreen mainScreen].scale;
        self.anchorPoint = CGPointMake(0, 0);
        self.string = text;
        self.moveSpeed = speed;
        self.fontName = font.fontName;
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.moveSpeed = 0;
        self.fontName = @"Helvetica";
    }
    return self;
}

-(CGFloat)calculateDanmakuWidth {
    UIFont *font = [UIFont fontWithName:_fontName size:self.fontSize];
    if (font == nil) {
        font = [UIFont systemFontOfSize:self.fontSize];
    }
    NSDictionary *attrs = @{NSFontAttributeName: font};
    if ([self.string isKindOfClass:NSString.self]) {
        CGSize size = [(NSString *)self.string boundingRectWithSize:CGSizeMake(MAXFLOAT, 100.0) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
        return size.width + 5;
    }
    return 0;
}

-(void)pause {
    CFTimeInterval pauseTime = [self convertTime:CACurrentMediaTime() fromLayer:nil];
    self.speed = 0;
    self.timeOffset = pauseTime;
}

-(void)resume {
    CFTimeInterval pauseTime = self.timeOffset;
    self.speed = 1.0;
    self.timeOffset = 0;
    self.beginTime = 0;
    CFTimeInterval timeSincePause = [self convertTime:CACurrentMediaTime() fromLayer:nil] - pauseTime;
    self.beginTime = timeSincePause;
}

-(void)hide {
    [self setHidden:YES];
}

-(void)show {
    [self setHidden:NO];
}

@end
