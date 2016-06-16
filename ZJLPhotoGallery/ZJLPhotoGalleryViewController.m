//
//  ZJLPhotoGalleryViewController.m
//  ZJLPhotoGallery
//
//  Created by ZhongZhongzhong on 16/6/15.
//  Copyright © 2016年 ZhongZhongzhong. All rights reserved.
//

#import "ZJLPhotoGalleryViewController.h"
#import "ZJLCollectionViewCell.h"
#import "CellFrameModel.h"
#import "PhotoGalleryViewController.h"
#define ScreenWdith [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

@interface ZJLPhotoGalleryViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) NSMutableArray *imageURLArray;
@property (nonatomic, strong) NSMutableArray *bigImageURLArray;
@property (nonatomic, strong) NSMutableArray *frameArray;
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation ZJLPhotoGalleryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initCollectionView];
    [self initData];
}

- (void)initCollectionView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake((ScreenWdith-60)/4, (ScreenWdith-60)/4);
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 10;
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenWdith, ScreenHeight) collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"ZJLCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"my_cell"];
    [self.view addSubview:self.collectionView];
    
}

- (void)initData
{
    self.imageURLArray = [NSMutableArray arrayWithArray:@[@"http://b.hiphotos.baidu.com/image/h%3D200/sign=ca449e25cdea15ce5eeee70986013a25/fcfaaf51f3deb48f452b517ef41f3a292cf578d4.jpg",
                                                          @"http://f.hiphotos.baidu.com/image/h%3D200/sign=658bab6a553d269731d30f5d65fab24f/0dd7912397dda1446853fa12b6b7d0a20cf4863c.jpg",
                                                          @"http://g.hiphotos.baidu.com/image/h%3D200/sign=b00abd199a510fb367197097e932c893/a8014c086e061d955cbcc4987ff40ad163d9ca9c.jpg",
                                                          @"http://b.hiphotos.baidu.com/image/h%3D200/sign=beeff5de211f95cab9f595b6f9167fc5/83025aafa40f4bfbd2086ef4074f78f0f63618b1.jpg",
                                                          @"http://d.hiphotos.baidu.com/image/h%3D200/sign=1acc1ac4524e9258b93481eeac83d1d1/b7fd5266d0160924b8f750bbd00735fae7cd34bb.jpg"]];
    self.bigImageURLArray = [NSMutableArray arrayWithArray:@[@"http://img.article.pchome.net/00/43/41/54/pic_lib/wm/3.jpg",
                                                             @"http://f.hiphotos.baidu.com/image/h%3D200/sign=658bab6a553d269731d30f5d65fab24f/0dd7912397dda1446853fa12b6b7d0a20cf4863c.jpg",
                                                             @"http://img.shu163.com/uploadfiles/wallpaper/2010/6/2010073106154112.jpg",
                                                             @"http://c.hiphotos.bdimg.com/album/w%3D2048/sign=a3a806ef6609c93d07f209f7ab05fadc/d50735fae6cd7b89f4ee76620e2442a7d8330e54.jpg",
                                                             @"http://h.hiphotos.baidu.com/image/pic/item/8694a4c27d1ed21b61797af2ae6eddc451da3f70.jpg"]];
    self.frameArray = [NSMutableArray new];
}

#pragma mark - collection view data source
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imageURLArray.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZJLCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"my_cell" forIndexPath:indexPath];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[self.imageURLArray objectAtIndex:indexPath.row]] placeholderImage:[UIImage imageNamed:@"placeholder"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (error) {
            NSLog(@"Error occured : %@", [error description]);
        }
    }];
    CellFrameModel *frameModel = [[CellFrameModel alloc] initWithView:cell];
    [self.frameArray addObject:frameModel];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIView *cover = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    cover.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:cover];
    
    ZJLCollectionViewCell *cell = (ZJLCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    PhotoGalleryViewController *photoVC = [[PhotoGalleryViewController alloc] init];
    photoVC.urlArray = [self.bigImageURLArray copy];
    photoVC.frameArray = [self.frameArray copy];
    photoVC.index = indexPath.row;
    photoVC.currentFrame = cell.frame;
    photoVC.dismissComplete = ^{
        [cover removeFromSuperview];
    };
    [self presentViewController:photoVC animated:NO completion:nil];
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
