//
//  ViewController.m
//  ALiPlayerSDK
//
//  Created by 顺 on 2019/7/16Tuesday.
//  Copyright © 2019 智网易联. All rights reserved.
//

#import "ViewController.h"
#import "VideoPlayerView.h"
#import "FullVideoViewController.h"
#import <AVKit/AVKit.h>

#define WeakSelf  __weak __typeof(self)weakSelf = self;
#define Screen_Width [[UIScreen mainScreen] bounds].size.width
#define Screen_Height [[UIScreen mainScreen] bounds].size.height

@interface ViewController ()<VideoPlayerViewDelegate>

@property (nonatomic,strong) VideoPlayerView * avplayer ;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    VideoPlayerView * avplayer = [[[NSBundle mainBundle]loadNibNamed:@"VideoPlayerView" owner:nil options:nil] firstObject];
    avplayer.delegate = self;
    avplayer.videoUrl = @"http://200024424.vod.myqcloud.com/200024424_709ae516bdf811e6ad39991f76a4df69.f20.mp4";
    avplayer.frame = CGRectMake(0, 100, Screen_Width, 200);
    
    [self.view addSubview:avplayer];
    self.avplayer = avplayer;


}

- (void)videoPlayerView:(id)videoView fullScreenAction:(UIButton *)fullButton {
    // 自己写全屏播放
    FullVideoViewController * full = [[FullVideoViewController alloc] init];
    full.avPlayer = self.avplayer;
    [self.navigationController pushViewController:full animated:NO];
    WeakSelf
    [full setBlock:^(FullVideoViewController *  _Nonnull data) {
        weakSelf.avplayer = data.avPlayer;
        weakSelf.avplayer.delegate = self;
        [weakSelf.view addSubview:weakSelf.avplayer];
    }];
    
    // 用系统的全屏播放
//        AVPlayerViewController * av = [[AVPlayerViewController alloc] init];
//        av.player = [AVPlayer playerWithURL:[NSURL URLWithString:self.avplayer.videoUrl]];
//        [self presentViewController:av animated:NO completion:^{
//        }];
}

- (void)viewDidLayoutSubviews {
    self.avplayer.frame = CGRectMake(0, 100, Screen_Width, 200);

}



- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait ; //正向
}
@end
