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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.image = [UIImage imageNamed:@"image.jpg"];
    self.index = -1;
    
    self.imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    self.imageView.image = self.image;
    [self.view addSubview:self.imageView];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.contentSize = CGSizeMake(0, HEIGHT*2);
    [self.view addSubview:scrollView];
    
    NSArray *titles = [NSArray arrayWithObjects:@"高亮",@"曝光", nil];
    
    for (int i=0; i<titles.count; i++) {
        
        ZYSlider *slider = [[ZYSlider alloc] initWithFrame:CGRectMake(0, 20+44*i, WIDTH, 44)];
        [scrollView addSubview:slider];
        slider.index = i;
        slider.title = [titles objectAtIndex:i];
        
        switch (i) {
            case 0:
                slider.minimumValue = -1.0f;
                slider.maximumValue = 1.0f;
                slider.value = 0.0f;
                [slider addTarget:self action:@selector(changeBrightness:) forControlEvents:UIControlEventValueChanged];
                break;
                
            case 1:
                slider.minimumValue = -10.0f;
                slider.maximumValue = 10.0f;
                slider.value = 0.0f;
                [slider addTarget:self action:@selector(changeExposure:) forControlEvents:UIControlEventValueChanged];
                break;
                
            default:
                break;
        }
        
        
        
    }
    
}

-(void)updateSourceImageForIndex:(int)index {
    if (_index == -1) {
        _index = index;
    } else if (_index == index) {
        
    } else {
        _index = index;
        self.image = self.imageView.image;
    }
}

//高亮
-(void)changeBrightness:(id)sender {
    ZYSlider *slider = (ZYSlider*)sender;
    slider.text = slider.value;
    [self updateSourceImageForIndex:slider.index];
    
    //创建一个高亮滤镜
    GPUImageBrightnessFilter *filter = [[GPUImageBrightnessFilter alloc] init];
    filter.brightness = slider.value;
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

//曝光
-(void)changeExposure:(id)sender {
    ZYSlider *slider = (ZYSlider*)sender;
    slider.text = slider.value;
    [self updateSourceImageForIndex:slider.index];
    
    GPUImageExposureFilter *filter = [[GPUImageExposureFilter alloc] init];
    filter.exposure = slider.value;
    [filter forceProcessingAtSize:_image.size];
    [filter useNextFrameForImageCapture];
    GPUImagePicture *picture = [[GPUImagePicture alloc] initWithImage:_image];
    [picture addTarget:filter];
    [picture processImage];
    UIImage *gpuImage = [filter imageFromCurrentFramebuffer];
    self.imageView.image = gpuImage;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
