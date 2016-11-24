//
//  ZYSlider.m
//  ZyGPUImage
//
//  Created by still on 16/11/23.
//  Copyright © 2016年 still. All rights reserved.
//

#import "ZYSlider.h"

@implementation ZYSlider

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        _label = [[UILabel alloc] initWithFrame:self.bounds];
        
        [self addSubview:_label];
        
        _slider = [[UISlider alloc] initWithFrame:self.bounds];
        [self addSubview:_slider];
    }
    return self;
}

-(void)setIndex:(int)index {
    _index = index;
}
-(void)setTitle:(NSString *)title {
    _title = title;
    _label.text = title;
}

-(void)setValue:(float)value {
    _value = value;
    _slider.value = value;
}


-(void)setMinimumValue:(float)minimumValue {
    _minimumValue = minimumValue;
    _slider.minimumValue = minimumValue;
}

-(void)setMaximumValue:(float)maximumValue {
    _maximumValue = maximumValue;
    _slider.maximumValue = maximumValue;
}

-(void)setText:(float)value {
    _text = value;
    _label.text = [NSString stringWithFormat:@"%@%f",_title,value];
}

- (void)addTarget:(nullable id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents {
    _target = target;
    _action = action;
    [_slider addTarget:self action:@selector(delegate:) forControlEvents:controlEvents];
}
-(void)delegate:(UISlider*)slider {
    _value = slider.value;
    if ([_target respondsToSelector:_action]) {
        [_target performSelector:_action withObject:self];
    }
}

@end
