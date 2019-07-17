//
//  AVPlayerView.m
//  ALiPlayerSDK
//
//  Created by 顺 on 2019/7/16Tuesday.
//  Copyright © 2019 智网易联. All rights reserved.
//

#import "VideoPlayerView.h"
#import <AVKit/AVKit.h>
#import "FullVideoViewController.h"

#define Screen_Width [[UIScreen mainScreen] bounds].size.width
#define Screen_Height [[UIScreen mainScreen] bounds].size.height


@interface VideoPlayerView ()

@property(nonatomic,strong)AVPlayer * player;
@property(nonatomic,strong)AVPlayerLayer * playerLayer;

@property (weak, nonatomic) IBOutlet UIView *controllView;
@property (weak, nonatomic) IBOutlet UIButton *playButton;

@property (weak, nonatomic) IBOutlet UIButton *fullScreenButton;
/// 当前的播放进度
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

/// 进度条的父视图
@property (weak, nonatomic) IBOutlet UIView *bottomView;
/// 可滑动的进度条
@property (weak, nonatomic) IBOutlet UISlider *progressSlider;
/// 缓存进度
@property (weak, nonatomic) IBOutlet UIProgressView *cashProgress;
@property (weak, nonatomic) IBOutlet UILabel *currentTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *totleTimeLabel;



@end

@implementation VideoPlayerView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.clipsToBounds = YES;
    
    UIImage * image = [UIImage imageNamed:@"圆点"];
    [self.progressSlider setThumbImage:image forState:UIControlStateNormal];
    [self.progressSlider setMinimumTrackImage:[UIImage imageNamed:@"hd-jage-bg"] forState:UIControlStateNormal];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self addGestureRecognizer:tap];
}
- (void)setVideoUrl:(NSString *)videoUrl {
    _videoUrl = videoUrl;
    [self player];
    [self setUpVideo];
}


/// 显示隐藏播放按钮
- (void)tapAction:(UITapGestureRecognizer *)tap{
    
    CGPoint tapPoint = [tap locationInView:self] ;
    if (CGRectContainsPoint(self.bottomView.frame, tapPoint)) {
        [self delayHidden];
        return;
    }
    
    [self showControlView:self.controllView.isHidden];
    
}

- (void)delayHidden{
    [NSObject cancelPreviousPerformRequestsWithTarget:self.controllView];
    
    [self.controllView performSelector:@selector(setHidden:) withObject:@(YES) afterDelay:5];
    
}

- (void)showControlView:(BOOL)shouldShow {
    
    if (shouldShow) {
        self.controllView.hidden = NO;
        self.progressView.hidden = YES;
        [self delayHidden];
    } else {
        self.controllView.hidden = YES;
        self.progressView.hidden = NO;

    }
    
}

/// 播放暂停
- (IBAction)playAction:(id)sender {
    
    if (self.player.rate > 0) {
        [self.player pause];
        [self showControlView:YES];
        
    } else {
        [self.player play];
        [self delayHidden];
    }
    
    self.playButton.selected = !self.playButton.isSelected;
}
/// 点击了全屏
- (IBAction)fullScreenAction:(id)sender {
    
    
    if ([self.delegate respondsToSelector:@selector(videoPlayerView:fullScreenAction:)]){
        [self.delegate videoPlayerView:self fullScreenAction:self.fullScreenButton];
        return;
    }
    
}
/// 进度条改变
- (IBAction)progressChange:(UISlider *)slider {
    
    float total = CMTimeGetSeconds(self.player.currentItem.duration);//总的播放时间(秒）
    int newTime = slider.value * total / 100;
    NSLog(@"%d",newTime);
    
    __weak typeof(self) weakSelf = self;
    [self.player seekToTime:CMTimeMake(slider.value * total, 100) toleranceBefore:CMTimeMake(1, 10) toleranceAfter:CMTimeMake(1, 10) completionHandler:^(BOOL finished) {
        [weakSelf.player play];
    }];
    
    self.progressView.progress = slider.value / 100;
    int time = newTime;
    weakSelf.currentTimeLabel.text = [NSString stringWithFormat:@"%d:%02d",time/60,time%60];

    
}

-(AVPlayer*) player{
    if (!_player) {
        
        //流媒体播放源
        NSURL * url = [NSURL URLWithString:self.videoUrl];
        
        AVPlayerItem * playerItem = [AVPlayerItem playerItemWithURL:url];
        _player = [AVPlayer playerWithPlayerItem:playerItem];//实例化播放器
        
        //实例化播放层
        AVPlayerLayer * playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
        playerLayer.frame = self.bounds;
        playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill ;
//        playerLayer.videoGravity = AVLayerVideoGravityResize ;

        
        _playerLayer = playerLayer;
        //将播放层添加到视图上
        [self.layer addSublayer:playerLayer];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemDidPlayToEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
        
        for (UIView * sub in self.subviews) {
            [self bringSubviewToFront:sub];
        }
        
        __weak typeof(self) weakSelf = self;
        [_player addPeriodicTimeObserverForInterval:CMTimeMake(1, 10) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
            
            if (weakSelf.progressSlider.isTracking) {
                [weakSelf.player pause];
                return ;
            }
            float currentTime = CMTimeGetSeconds(time);//获得当前播放的时间（秒）
            float total = CMTimeGetSeconds(playerItem.duration);//总的播放时间(秒）
            
            if (currentTime) {
                
            
                // 设置当前进度条
                weakSelf.progressSlider.value = currentTime/total * 100;//更新进度
                weakSelf.progressView.progress = currentTime/total;

                // 设置时间
                int time = currentTime;
                weakSelf.currentTimeLabel.text = [NSString stringWithFormat:@"%d:%02d",time/60,time%60];
                time = total;
                weakSelf.totleTimeLabel.text = [NSString stringWithFormat:@"%d:%02d",time/60,time%60];
                
                // 设置缓冲进度
                NSArray *loadedTimeRanges = [[weakSelf.player currentItem] loadedTimeRanges];
                CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域
                float startSeconds = CMTimeGetSeconds(timeRange.start);
                float durationSeconds = CMTimeGetSeconds(timeRange.duration);
                NSTimeInterval result = startSeconds + durationSeconds;// 计算缓冲总进度
                // 手在拖动过程中startSeconds,durationSeconds为Nan,所以判断下
                if (isnan(result) ) {
                    return ;
                }
                weakSelf.cashProgress.progress = result / total ;

            }
            
        }];
        
    }
    return _player;
}

- (void)layoutSubviews {
    [super layoutSubviews];
//    _playerLayer.frame = self.bounds;
    
    //获取视频的屏幕宽高比，让播放的宽高比与视频的一致。
    AVURLAsset  *asset = [AVURLAsset assetWithURL: [NSURL URLWithString:self.videoUrl]];
    NSArray *array = asset.tracks;
    CGSize videoSize = CGSizeZero;
    for(AVAssetTrack  *track in array) {
        if([track.mediaType isEqualToString:AVMediaTypeVideo]) {
            videoSize = track.naturalSize;
            CGFloat sacle = videoSize.width / videoSize.height;
            CGFloat height = self.bounds.size.height ;
            CGFloat width = self.bounds.size.width;
            CGFloat marginX = 0;
            CGFloat marginY = 0;
            if (sacle > 1) {
                //如果屏幕的宽高比大于1，说明宽度大于高度，那以屏幕的宽度为准，适配视频的高度
                height =  width / sacle;
                marginY = (self.bounds.size.height - height) * 0.5;
            }else {
                //如果屏幕的宽高比小于1，说明宽度小于高度，那以屏幕的高度为准，适配视频的宽度
                width = height * sacle;
                marginX = (self.bounds.size.width - width) * 0.5;
            }
            self.playerLayer.frame = CGRectMake(marginX, marginY, width, height);
            
        }
    }
    self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill ;
    
}

- (void)playerItemDidPlayToEnd:(NSNotification *)notification{
    
    CGFloat a=0;
    NSInteger dragedSeconds = floorf(a);
    CMTime dragedCMTime = CMTimeMake(dragedSeconds, 1);
    [self.player seekToTime:dragedCMTime];
}

// 初始化video,获取视频第一帧,获取视频总时长
- (void)setUpVideo {
    
    /// 如果没有设置播放的封面,就用第一帧
    [self playerItemDidPlayToEnd:nil];

    NSURL * url = [NSURL URLWithString:self.videoUrl] ;
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL: url options:nil];
    CMTime audioDuration = asset.duration;
    float audioDurationSeconds = CMTimeGetSeconds(audioDuration);
    int totleTime = (int)audioDurationSeconds;
    self.totleTimeLabel.text = [NSString stringWithFormat:@"%d:%02d",totleTime/60,totleTime%60];

}

@end
