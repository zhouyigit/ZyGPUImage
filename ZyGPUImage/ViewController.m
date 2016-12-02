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

#pragma mark 渲染流程示例 仅仅用于让读者明白单个滤镜的渲染流程 无用方法
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
    
    _originalImage = [UIImage imageNamed:@"image.jpg"];

    self.imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.imageView];

    _titles = [NSMutableArray arrayWithCapacity:0];
    
    [self resetDemo];
    

}

#pragma mark 调用相册
-(void)getAlbum {
    _picker = [[UIImagePickerController alloc] init];
    _picker.delegate = self;
    _picker.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    _picker.allowsEditing = YES;
    _picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:_picker animated:YES completion:^{
        //
    }];
}

#pragma mark 相册回调
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {

    NSLog(@"%@",info);
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:@"public.image"]) {
        _originalImage = info[UIImagePickerControllerOriginalImage];
        [self resetDemo];
    }
    [self dismissViewControllerAnimated:YES completion:^{
        _picker.delegate = nil;
        _picker = nil;
    }];
}

#pragma mark 相册取消
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:^{
        _picker.delegate = nil;
        _picker = nil;
    }];
}

#pragma mark 保存图片
-(void)saveImage {
    UIImageWriteToSavedPhotosAlbum(_imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}

#pragma mark 图片保存完毕的回调
- (void) image: (UIImage *) image didFinishSavingWithError:(NSError *) error contextInfo: (void *)contextInf{
    if (!error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"保存成功" message:nil delegate:nil cancelButtonTitle:@"哦" otherButtonTitles:nil, nil];
        [alert show];
    }
}

/*
 *看我！！！
 *看我！！！
 *看我！！！
 *开源代码 欢迎贡献 请按照下面格式添加功能 （旨在让大家看到各种滤镜效果）
 *1.在重置方法resetDemo中 为_titles数组添加滤镜名称 并 设置该滤镜的范围和默认值（范围值可进入相应.h文件中查看，没有范围的就自定义吧）
 *2.在路由方法sliderChanged中调用滤镜方法
 *3.在GPUImage.h中进行标注，以纪录您的贡献
 */

#pragma mark 重置
-(void)resetDemo {
    
    [_titles removeAllObjects];
    self.index = -1;
    self.image = _originalImage;
    self.imageView.image = self.image;
    
    [_scrollView removeFromSuperview];
    _scrollView = nil;
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_scrollView];
    
    float buttonCount = 4.0;
    float width = WIDTH/buttonCount;
    float height = 44.0;
    
    UIButton *buttonAlbum = [[UIButton alloc] initWithFrame:CGRectMake(width*0, 20, width, height)];
    [buttonAlbum addTarget:self action:@selector(getAlbum) forControlEvents:UIControlEventTouchUpInside];
    [buttonAlbum setTitle:@"相册" forState:UIControlStateNormal];
    [_scrollView addSubview:buttonAlbum];
    
    UIButton *buttonSave = [[UIButton alloc] initWithFrame:CGRectMake(width*2, 20, width, height)];
    [buttonSave addTarget:self action:@selector(saveImage) forControlEvents:UIControlEventTouchUpInside];
    [buttonSave setTitle:@"保存" forState:UIControlStateNormal];
    [_scrollView addSubview:buttonSave];
    
    UIButton *buttonReset = [[UIButton alloc] initWithFrame:CGRectMake(width*3, 20, width, height)];
    [buttonReset addTarget:self action:@selector(resetDemo) forControlEvents:UIControlEventTouchUpInside];
    [buttonReset setTitle:@"重置" forState:UIControlStateNormal];
    [_scrollView addSubview:buttonReset];
    
    
#pragma mark 为了滤镜名称和范围值写在一起，所以
    int sliderIndex = 0;
    BOOL hasMore = YES;
    do {
        
        ZYSlider *slider = [[ZYSlider alloc] initWithFrame:CGRectMake(0, 20+height+height*sliderIndex, WIDTH, height)];
        
        switch (sliderIndex) {
            case 0:
                [_titles addObject:@"高亮"];
                slider.minimumValue = -1.0f;//滤镜最小值
                slider.maximumValue = 1.0f;//滤镜最大值
                slider.value = 0.0f;//滤镜默认值
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
                break;
                
            case 3:
                [_titles addObject:@"高斯模糊"];
                slider.minimumValue = 0.0f;
                slider.maximumValue = 10.0f;
                slider.value = 1.0f;
                break;
                
            case 4:
                [_titles addObject:@"素描"];
                slider.minimumValue = 0.0f;
                slider.maximumValue = 10.0f;
                slider.value = 1.0f;
                break;
                
            default:
                hasMore = NO;
                break;
        }
        
        if (hasMore == NO) {
            slider = nil;
            break;
        } else {
            slider.index = sliderIndex;
            slider.title = [_titles objectAtIndex:sliderIndex];
            [slider addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
            [_scrollView addSubview:slider];
            sliderIndex++;
        }
        
    } while (YES);
    
    _scrollView.contentSize = CGSizeMake(0, 20+height+height*_titles.count+HEIGHT);//可以把滑块滚上去看效果
    
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
            
        case 4:
            filter = [self changeSketch:slider];//素描
            
        default:
            break;
    }
    
    if (filter == nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"爱心提醒" message:@"路由方法未设置filter" delegate:self cancelButtonTitle:@"哦" otherButtonTitles:nil, nil];
        [alert show];
    } else {
        
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

#pragma mark 素描
-(GPUImageFilter*)changeSketch:(ZYSlider*)slider {
    GPUImageSketchFilter *filter = [[GPUImageSketchFilter alloc] init];
    filter.edgeStrength = slider.value;
    return filter;
    //素描继承自其父类的默认值 设置1.0即可，实际是其父类效果
}

@end
