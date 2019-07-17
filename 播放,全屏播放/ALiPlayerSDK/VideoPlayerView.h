//
//  AVPlayerView.h
//  ALiPlayerSDK
//
//  Created by 顺 on 2019/7/16Tuesday.
//  Copyright © 2019 智网易联. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@class VideoPlayerView;
@protocol VideoPlayerViewDelegate <NSObject>

- (void)videoPlayerView:(VideoPlayerView *)videoView fullScreenAction:(UIButton *)fullButton;

@end


@interface VideoPlayerView : UIView

@property (nonatomic,copy) NSString * videoUrl ;
@property(nonatomic,readonly,strong)AVPlayer * player;
@property(nonatomic,readonly,strong)AVPlayerLayer * playerLayer;
@property (nonatomic,weak) id<VideoPlayerViewDelegate> delegate ;

@end

NS_ASSUME_NONNULL_END
