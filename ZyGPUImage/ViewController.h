//
//  ViewController.h
//  ZyGPUImage
//
//  Created by still on 16/11/22.
//  Copyright © 2016年 still. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPUImage.h"
#import "ZYSlider.h"

#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height

@interface ViewController : UIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    NSMutableArray *_titles;
    UIScrollView *_scrollView;
    UIImage *_originalImage;
    UIImagePickerController *_picker;
}

@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) UIImageView *imageView;
@property (assign, nonatomic) int index;
@end

