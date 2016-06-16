//
//  PhotoGalleryViewController.m
//  ZJLPhotoGallery
//
//  Created by ZhongZhongzhong on 16/6/15.
//  Copyright © 2016年 ZhongZhongzhong. All rights reserved.
//

#import "PhotoGalleryViewController.h"
#import "CellFrameModel.h"
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
@interface PhotoGalleryViewController ()<UIScrollViewDelegate>{
    CGFloat contentOffsetX;
    UIScrollView *zoomInScrollView;
}
@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, assign) BOOL isZoomIn;
@end

@implementation PhotoGalleryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    self.mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth+20, ScreenHeight)];
    self.mainScrollView.delegate = self;
    self.mainScrollView.contentSize = CGSizeMake((ScreenWidth+20)*self.urlArray.count, ScreenHeight);
    self.mainScrollView.tag = 55;
    self.mainScrollView.backgroundColor = [UIColor blackColor];
    self.mainScrollView.pagingEnabled = YES;
    [self.view addSubview:self.mainScrollView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.mainScrollView setContentOffset:CGPointMake((ScreenWidth+20)*self.index, 0) animated:NO];
    contentOffsetX = self.mainScrollView.contentOffset.x;
    self.isZoomIn = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSUInteger number = self.urlArray.count;
    for (int i = 0; i<number; i++) {
        UIScrollView *imageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake((ScreenWidth+20)*i, 0, ScreenWidth, ScreenHeight)];
        imageScrollView.tag = 44;
        imageScrollView.minimumZoomScale = 1.0f;
        imageScrollView.maximumZoomScale = 2.0f;
        imageScrollView.decelerationRate = 0.1f;
        imageScrollView.backgroundColor = [UIColor blackColor];
        imageScrollView.delegate = self;
        [self.mainScrollView addSubview:imageScrollView];
        
        UIImageView *imageView = [[UIImageView alloc] init];
        [imageView sd_setImageWithURL:[NSURL URLWithString:[self.urlArray objectAtIndex:i]] placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        }];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.tag = 666;
        imageView.clipsToBounds = YES;
        imageView.userInteractionEnabled = YES;
        if (i == self.index) {
            imageView.frame = self.currentFrame;
            [UIView animateWithDuration:0.2 animations:^{
                imageView.frame = CGRectMake(0, ScreenHeight/4, ScreenWidth, ScreenHeight/2);
            } completion:^(BOOL finished) {
                
            }];
        }else{
            imageView.frame = CGRectMake(0, ScreenHeight/4, ScreenWidth, ScreenHeight/2);
        }
        [imageScrollView addSubview:imageView];

        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapAction:)];
        singleTap.numberOfTapsRequired = 1;
        [imageView addGestureRecognizer:singleTap];
        
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapAction:)];
        doubleTap.numberOfTapsRequired = 2;
        [imageView addGestureRecognizer:doubleTap];
        
        [singleTap requireGestureRecognizerToFail:doubleTap];
        
    }
}

- (void)doubleTapAction:(UITapGestureRecognizer *)tap
{
    UIScrollView *imageScrollView = (UIScrollView *)tap.view.superview;
    if (imageScrollView.zoomScale == imageScrollView.maximumZoomScale) {
        self.isZoomIn = NO;
        zoomInScrollView = nil;
        [imageScrollView setZoomScale:1.0 animated:YES];
        return;
    }
    if(self.isZoomIn){
        self.isZoomIn = NO;
        zoomInScrollView = nil;
        [imageScrollView setZoomScale:1.0 animated:YES];
    }else{
        CGPoint finger = [tap locationInView:tap.view];
        [imageScrollView zoomToRect:CGRectMake(finger.x, finger.y, 1, 1) animated:YES];
        self.isZoomIn = YES;
        zoomInScrollView = imageScrollView;
    }
}

- (void)singleTapAction:(UITapGestureRecognizer *)tap
{
    UIImageView *imageView = (UIImageView *)tap.view;
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    self.view.backgroundColor = [UIColor clearColor];
    self.mainScrollView.backgroundColor = [UIColor clearColor];
    [keyWindow addSubview:imageView];
    [UIView animateWithDuration:0.2 animations:^{
        imageView.frame = self.currentFrame;
    } completion:^(BOOL finished) {
        if (self.dismissComplete) {
            self.dismissComplete();
        }
        [imageView removeFromSuperview];
    }];
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return (UIImageView *)[scrollView viewWithTag:666];
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    UIScrollView *superScroll = (UIScrollView *)scrollView.superview;
    CGFloat xCenter = scrollView.center.x-superScroll.contentOffset.x;
    CGFloat yCenter = scrollView.center.y;
    xCenter = scrollView.contentSize.width>scrollView.frame.size.width?scrollView.contentSize.width/2:xCenter;
    yCenter = scrollView.contentSize.height>scrollView.frame.size.height?scrollView.contentSize.height/2:yCenter;
    [[scrollView viewWithTag:666] setCenter:CGPointMake(xCenter, yCenter)];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.tag == 55) {
        if (contentOffsetX!=scrollView.contentOffset.x) {
            contentOffsetX = scrollView.contentOffset.x;
            if (zoomInScrollView) {
                self.isZoomIn = NO;
                [zoomInScrollView setZoomScale:1.0 animated:YES];
            }
        }
        self.index = (NSUInteger)(contentOffsetX/(ScreenWidth+20));
        CellFrameModel *frameModel = [self.frameArray objectAtIndex:self.index];
        self.currentFrame = CGRectMake(frameModel.frame.origin.x, frameModel.frame.origin.y, frameModel.frame.size.width, frameModel.frame.size.height);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
