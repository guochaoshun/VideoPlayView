//
//  ProgressSlider.m
//  ALiPlayerSDK
//
//  Created by 顺 on 2019/7/16Tuesday.
//  Copyright © 2019 智网易联. All rights reserved.
//

#import "ProgressSlider.h"

@implementation ProgressSlider

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    CGRect t = [self trackRectForBounds: [self bounds]];
    
    float v = [self minimumValue] + ([[touches anyObject] locationInView: self].x - t.origin.x - 4.0) * (([self maximumValue]-[self minimumValue]) / (t.size.width - 8.0));
    
    [self setValue: v];
    
    [super touchesBegan: touches withEvent: event];
    
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    
}

@end
