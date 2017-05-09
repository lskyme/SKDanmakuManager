//
//  VideoViewController.m
//  SKDanmakuManagerDemo
//
//  Created by Dfsx on 17/4/18.
//  Copyright © 2017年 Lskyme. All rights reserved.
//

#import "VideoViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "SKDanmakuManager.h"
@interface VideoViewController ()

@property(nonatomic, strong) UIView *playView;
@property(nonatomic, strong) UIButton *playBtn;
@property(nonatomic, strong) UIButton *danmakuBtn;
@property(nonatomic, strong) UIButton *fullBtn;
@property(nonatomic, strong) UITextField *inputTextField;
@property(nonatomic, strong) UIButton *sendBtn;

@property(nonatomic, strong) NSString *playUrl;
@property(nonatomic, strong) AVPlayer *player;
@property(nonatomic, strong) AVPlayerItem *playerItem;
@property(nonatomic, strong) AVPlayerLayer *playerLayer;

@property(nonatomic, strong) SKDanmakuManager *manager;

@property(nonatomic, assign) BOOL hideStatusBar;

@end

@implementation VideoViewController

-(instancetype)init {
    self = [super init];
    if (self) {
        self.covered = true;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.hideStatusBar = false;
    
    _playView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 250)];
    _playView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:_playView];
    [self initSubViews];
    
    _playUrl = @"http://file.leshantv.net:8101/live/videos/2017-03-16/9121/0sd/0sd.m3u8";
    NSURL *url = [NSURL URLWithString:_playUrl];
    _playerItem = [AVPlayerItem playerItemWithURL:url];
    _player = [AVPlayer playerWithPlayerItem:_playerItem];
    _playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
    _playerLayer.frame = CGRectMake(0, 0, _playView.bounds.size.width, _playView.bounds.size.height - 80);
    _playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    [_playView.layer insertSublayer:_playerLayer atIndex:0];
    _playerLayer.backgroundColor = [UIColor darkGrayColor].CGColor;
    
    ///初始化SKDanmakuManager
    //_manager = [[SKDanmakuManager alloc] init];
    //_manager.layer = _playerLayer;
    _manager = [SKDanmakuManager managerWithLayer:_playerLayer];
    _manager.allowCovered = self.covered;
    
    //设置自定义弹幕字体名称
    //_manager.fontName = @"Papyrus";
    
    //设置弹幕字体大小
    //_manager.fontSize = 20.0f;
    
    //设置弹幕最大/最小速度
    //_manager.maxSpeed = 100.0f;
    //_manager.minSpeed = 50.0f;
    
    //设置弹幕之间的垂直间距
    //_manager.verticalSpacing = 10.0f;
    
    //设置弹幕之间的水平间距
    //_manager.horizontalSpacing = 10.0f;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated {
    [_player pause];
    _player = nil;
    [_playerLayer removeFromSuperlayer];
}

-(void)initSubViews {
    _inputTextField = [[UITextField alloc] initWithFrame:CGRectMake(8, _playView.bounds.size.height - 38, _playView.bounds.size.width - 100, 30)];
    _inputTextField.placeholder = @"输入弹幕";
    [_playView addSubview:_inputTextField];
    
    _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _sendBtn.frame = CGRectMake(_playView.bounds.size.width - 78, _inputTextField.frame.origin.y, 70, 30);
    [_sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    [_sendBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_sendBtn addTarget:self action:@selector(sendDanmaku) forControlEvents:UIControlEventTouchUpInside];
    [_playView addSubview:_sendBtn];
    
    _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _playBtn.frame = CGRectMake(8, _sendBtn.frame.origin.y - 33, 25, 25);
    [_playBtn setBackgroundImage:[UIImage imageNamed:@"播放"] forState:UIControlStateNormal];
    [_playBtn setBackgroundImage:[UIImage imageNamed:@"暂停"] forState:UIControlStateSelected];
    [_playBtn addTarget:self action:@selector(clickPlay) forControlEvents:UIControlEventTouchUpInside];
    [_playView addSubview:_playBtn];
    
    _danmakuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _danmakuBtn.frame = CGRectMake(_playView.bounds.size.width - 33, _playBtn.frame.origin.y, 25, 25);
    [_danmakuBtn setBackgroundImage:[UIImage imageNamed:@"弹幕开"] forState:UIControlStateNormal];
    [_danmakuBtn setBackgroundImage:[UIImage imageNamed:@"弹幕管"] forState:UIControlStateSelected];
    [_danmakuBtn addTarget:self action:@selector(clickDanmaku) forControlEvents:UIControlEventTouchUpInside];
    [_playView addSubview:_danmakuBtn];
    
    _fullBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _fullBtn.frame = CGRectMake(_danmakuBtn.frame.origin.x - 33, _danmakuBtn.frame.origin.y, 25, 25);
    [_fullBtn setBackgroundImage:[UIImage imageNamed:@"全屏"] forState:UIControlStateNormal];
    [_fullBtn setBackgroundImage:[UIImage imageNamed:@"退出全屏"] forState:UIControlStateSelected];
    [_fullBtn addTarget:self action:@selector(clickFullScreen) forControlEvents:UIControlEventTouchUpInside];
    [_playView addSubview:_fullBtn];
}

-(void)layoutPlayViewSubviews {
    BOOL playBtnSelected = _playBtn.selected;
    BOOL danmakuBtnSelected = _danmakuBtn.selected;
    BOOL fullScreenBtnSelected = _fullBtn.selected;
    
    [_inputTextField removeFromSuperview];
    [_sendBtn removeFromSuperview];
    [_playBtn removeFromSuperview];
    [_danmakuBtn removeFromSuperview];
    [_fullBtn removeFromSuperview];
    
    [self initSubViews];
    _playBtn.selected = playBtnSelected;
    _danmakuBtn.selected = danmakuBtnSelected;
    _fullBtn.selected = fullScreenBtnSelected;
}

#pragma mark - Buttons Action

-(void)clickPlay {
    _playBtn.selected = !_playBtn.selected;
    if (_playBtn.selected) {
        [_player play];
        [_manager resumeDanmakus];
    }
    else {
        [_player pause];
        [_manager pauseDanmakus];
    }
}

-(void)clickDanmaku {
    _danmakuBtn.selected = !_danmakuBtn.selected;
    if (_danmakuBtn.selected) {
        [_manager hideDanmakus];
    }
    else {
        [_manager showDanmakus];
    }
}

-(void)sendDanmaku {
    [_manager createDanmakuWithText:_inputTextField.text color:[UIColor whiteColor]];
}

-(void)clickFullScreen {
    _fullBtn.selected = !_fullBtn.selected;
    if (_fullBtn.selected) {
        [self enterFullscreen];
    }
    else {
        [self quitFullscreen];
    }
}

#pragma mark - others

-(void)enterFullscreen {
    [self.navigationController setNavigationBarHidden:YES];
    _hideStatusBar = true;
    [self setNeedsStatusBarAppearanceUpdate];
    
    typeof(self) __weak weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        CGRect tmpFrame = weakSelf.playView.frame;
        tmpFrame.size = CGSizeMake(weakSelf.view.frame.size.height, weakSelf.view.frame.size.width);
        weakSelf.playView.frame = tmpFrame;
        weakSelf.playView.center = weakSelf.view.center;
        CGRect tmpLayerFrame = CGRectMake(0, 0, weakSelf.playView.bounds.size.width, weakSelf.playView.bounds.size.height - 80);
        weakSelf.playerLayer.frame = tmpLayerFrame;
        [weakSelf layoutPlayViewSubviews];
        weakSelf.playView.transform = CGAffineTransformMakeRotation(M_PI_2);
    } completion:^(BOOL finished) {
        ///进入全屏以弹幕字体大小24来重新布局弹幕
        [weakSelf.manager layoutDanmakusWithFontSize:24];
    }];
}

-(void)quitFullscreen {
    [self.navigationController setNavigationBarHidden:NO];
    _hideStatusBar = false;
    [self setNeedsStatusBarAppearanceUpdate];
    
    typeof(self) __weak weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.playView.transform = CGAffineTransformIdentity;
        weakSelf.playView.frame = CGRectMake(0, 64, weakSelf.view.frame.size.width, 250);
        weakSelf.playerLayer.frame = CGRectMake(0, 0, weakSelf.playView.bounds.size.width, weakSelf.playView.bounds.size.height - 80);
        [weakSelf layoutPlayViewSubviews];
    } completion:^(BOOL finished) {
        ///退出全屏以弹幕字体大小24来重新布局弹幕
        [weakSelf.manager layoutDanmakusWithFontSize:15];
    }];
}

-(BOOL)prefersStatusBarHidden {
    return _hideStatusBar;
}

-(void)dealloc {
    NSLog(@"controller dealloc");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
