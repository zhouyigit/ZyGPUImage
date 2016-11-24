//
//  ZYSlider.h
//  ZyGPUImage
//
//  Created by still on 16/11/23.
//  Copyright © 2016年 still. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZYSlider : UIView
{
    UISlider *_slider;
    UILabel *_label;
    id _target;
    SEL _action;
}

@property (strong, nonatomic) NSString *title;
@property (assign, nonatomic) int index;
@property (assign, nonatomic) float value;
@property (assign, nonatomic) float minimumValue;
@property (assign, nonatomic) float maximumValue;
@property (assign, nonatomic) float text;

-(instancetype)initWithFrame:(CGRect)frame;
- (void)addTarget:(nullable id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;

@end
