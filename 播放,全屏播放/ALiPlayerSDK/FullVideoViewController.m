//
//  FullVideoViewController.m
//  ALiPlayerSDK
//
//  Created by 顺 on 2019/7/17Wednesday.
//  Copyright © 2019 智网易联. All rights reserved.
//

#import "FullVideoViewController.h"

@interface FullVideoViewController ()<VideoPlayerViewDelegate>


@end

@implementation FullVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.avPlayer];

    self.avPlayer.delegate = self;

}

- (void)videoPlayerView:(VideoPlayerView *)videoView fullScreenAction:(UIButton *)fullButton {
    
    [self.navigationController popViewControllerAnimated:NO];
    [self.avPlayer.player pause];
    self.block(self);

}

- (void)viewDidLayoutSubviews {
    self.avPlayer.frame = self.view.bounds;
}


- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}


@end
