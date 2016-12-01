//
//  ViewController.m
//  ZyGPUImage
//
//  Created by still on 16/11/22.
//  Copyright © 2016年 still. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 渲染流程示例 仅仅用于让读者明白单个滤镜的渲染流程
-(void)example {
    //创建一个高亮滤镜
    GPUImageBrightnessFilter *filter = [[GPUImageBrightnessFilter alloc] init];
    filter.brightness = 0.0f;//在此处设置滤镜值
    //设置渲染区域
    [filter forceProcessingAtSize:_image.size];
    [filter useNextFrameForImageCapture];
    //获取数据源
    GPUImagePicture *picture = [[GPUImagePicture alloc] initWithImage:_image];
    //添加滤镜
    [picture addTarget:filter];
    //开始渲染
    [picture processImage];
    //获取渲染后的图片
    UIImage *gpuImage = [filter imageFromCurrentFramebuffer];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    self.imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.imageView];

    /*
     *开源代码 欢迎贡献 请按照下面格式添加功能 （旨在让大家看到各种滤镜效果）
     *1.titles数组中添加滤镜名称
     *2.初始化switch中设置范围和默认值（范围值可进入相应.h文件中查看）
     *3.路由switch中调用滤镜方法
     *4.在GPUImage.h中进行标注
     */
    _titles = [NSMutableArray arrayWithCapacity:0];
    
    [self resetDemo];
    
}

#pragma mark 重置
-(void)resetDemo {
    
    self.index = -1;
    self.image = [UIImage imageNamed:@"image.jpg"];
    self.imageView.image = self.image;
    
    [_scrollView removeFromSuperview];
    _scrollView = nil;
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_scrollView];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 20+0, WIDTH, 44)];
    [button addTarget:self action:@selector(resetDemo) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"重置" forState:UIControlStateNormal];
    [_scrollView addSubview:button];
    
    //为了滤镜名称和范围值写在一起，所以for循环次数粗暴的写死了
    for (int i=0; i<4; i++) {
        
        ZYSlider *slider = [[ZYSlider alloc] initWithFrame:CGRectMake(0, 20+44+44*i, WIDTH, 44)];
        [_scrollView addSubview:slider];
        
        switch (i) {
            case 0:
                [_titles addObject:@"高亮"];
                slider.minimumValue = -1.0f;
                slider.maximumValue = 1.0f;
                slider.value = 0.0f;
                break;
                
            case 1:
                [_titles addObject:@"曝光"];
                slider.minimumValue = -10.0f;
                slider.maximumValue = 10.0f;
                slider.value = 0.0f;
                break;
                
            case 2:
                [_titles addObject:@"对比度"];
                slider.minimumValue = 0.0f;
                slider.maximumValue = 4.0f;
                slider.value = 1.0f;
                
            case 3:
                [_titles addObject:@"高斯模糊"];
                slider.minimumValue = 0.0f;
                slider.maximumValue = 10.0f;
                slider.value = 1.0f;
                
            default:
                break;
        }
        
        slider.index = i;
        slider.title = [_titles objectAtIndex:i];
        [slider addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
        
    }
    
    _scrollView.contentSize = CGSizeMake(0, 20+44+44*_titles.count+HEIGHT);//可以把滑块滚上去看效果
}

#pragma mark 路由方法 用于调用slider对应的滤镜
-(void)sliderChanged:(id)sender {
    ZYSlider *slider = (ZYSlider*)sender;
    slider.text = slider.value;
    [self updateSourceImageForIndex:slider.index];
    
    GPUImageFilter *filter = nil;
    
    switch (slider.index) {
        case 0:
            filter = [self changeBrightness:slider];//高亮
            break;
            
        case 1:
            filter = [self changeExposure:slider];//曝光
            break;
            
        case 2:
            filter = [self changeContrast:slider];//对比度
            break;
            
        case 3:
            filter = [self changeGaussianBlur:slider];//高斯模糊
            break;
            
        default:
            break;
    }
    
    //设置渲染区域
    [filter forceProcessingAtSize:_image.size];
    [filter useNextFrameForImageCapture];
    //获取数据源
    GPUImagePicture *picture = [[GPUImagePicture alloc] initWithImage:_image];
    //添加滤镜
    [picture addTarget:filter];
    //开始渲染
    [picture processImage];
    //获取渲染后的图片
    UIImage *gpuImage = [filter imageFromCurrentFramebuffer];
    
    self.imageView.image = gpuImage;
    
}

#pragma mark 切换滤镜时 保存当前图片 在当前图片的基础上 新增滤镜效果
-(void)updateSourceImageForIndex:(int)index {
    if (_index == -1) {
        _index = index;
    } else if (_index == index) {
        
    } else {
        _index = index;
        self.image = self.imageView.image;
    }
}

#pragma mark 高亮
-(GPUImageFilter*)changeBrightness:(ZYSlider*)slider {
    
    //创建一个高亮滤镜
    GPUImageBrightnessFilter *filter = [[GPUImageBrightnessFilter alloc] init];
    //设置滤镜值
    filter.brightness = slider.value;
    return filter;
}

#pragma mark 曝光
-(GPUImageFilter*)changeExposure:(ZYSlider*)slider {
    
    GPUImageExposureFilter *filter = [[GPUImageExposureFilter alloc] init];
    filter.exposure = slider.value;
    return filter;
}

#pragma mark 对比度
-(GPUImageFilter*)changeContrast:(ZYSlider*)slider {
    
    GPUImageContrastFilter *filter = [[GPUImageContrastFilter alloc] init];
    filter.contrast = slider.value;
    return filter;
}

#pragma mark 高斯模糊
-(GPUImageFilter*)changeGaussianBlur:(ZYSlider*)slider {
    GPUImageGaussianBlurFilter *filter = [[GPUImageGaussianBlurFilter alloc] init];
    filter.texelSpacingMultiplier = slider.value;
    return filter;
}


@end
