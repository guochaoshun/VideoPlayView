//
//  FullVideoViewController.h
//  ALiPlayerSDK
//
//  Created by 顺 on 2019/7/17Wednesday.
//  Copyright © 2019 智网易联. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoPlayerView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^callBack)(id data);
@interface FullVideoViewController : UIViewController

@property (nonatomic,strong) VideoPlayerView * avPlayer ;
@property (nonatomic,copy) callBack block ;
@end

NS_ASSUME_NONNULL_END
