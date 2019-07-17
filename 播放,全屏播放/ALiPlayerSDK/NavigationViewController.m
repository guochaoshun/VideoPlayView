//
//  NavigationViewController.m
//  ALiPlayerSDK
//
//  Created by 顺 on 2019/7/17Wednesday.
//  Copyright © 2019 智网易联. All rights reserved.
//

#import "NavigationViewController.h"

@interface NavigationViewController ()

@end

@implementation NavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (BOOL)shouldAutorotate
{
    return [self.topViewController shouldAutorotate];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return [self.topViewController supportedInterfaceOrientations];
}

@end
