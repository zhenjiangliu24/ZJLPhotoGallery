//
//  PhotoGalleryViewController.m
//  ZJLPhotoGallery
//
//  Created by ZhongZhongzhong on 16/6/15.
//  Copyright © 2016年 ZhongZhongzhong. All rights reserved.
//

#import "PhotoGalleryViewController.h"
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
@interface PhotoGalleryViewController ()<UIScrollViewDelegate>{
    CGFloat contentOffsetX;
}
@property (nonatomic, strong) UIScrollView *mainScrollView;
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
        [self.mainScrollView addSubview:imageScrollView];
        
        UIImageView *imageView = [UIImageView alloc] ini
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
