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
    self.image = [UIImage imageNamed:@"image.jpg"];
    self.index = -1;
    
    self.imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    self.imageView.image = self.image;
    [self.view addSubview:self.imageView];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.contentSize = CGSizeMake(0, HEIGHT*2);
    [self.view addSubview:scrollView];
    
    /*
     *开源代码 欢迎贡献 请按照下面格式添加功能
     *1.titles数组中添加滤镜名称
     *2.初始化switch中设置范围（范围值可进入相应.h文件中查看）
     *3.路由switch中调用滤镜方法
     *4.在GPUImage.h中进行标注
     */
    NSArray *titles = [NSArray arrayWithObjects:@"高亮",@"曝光",@"对比度", nil];
    
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
                break;
                
            case 1:
                slider.minimumValue = -10.0f;
                slider.maximumValue = 10.0f;
                slider.value = 0.0f;
                break;
                
            case 2:
                slider.minimumValue = 0.0f;
                slider.maximumValue = 4.0f;
                slider.value = 1.0f;
            default:
                break;
        }
        
        [slider addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
        
    }
    
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




@end
