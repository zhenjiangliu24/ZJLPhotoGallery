//
//  PhotoGalleryViewController.h
//  ZJLPhotoGallery
//
//  Created by ZhongZhongzhong on 16/6/15.
//  Copyright © 2016年 ZhongZhongzhong. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^dismissGallery)(void);

@interface PhotoGalleryViewController : UIViewController
@property (nonatomic, assign) NSUInteger index;
@property (nonatomic, copy) NSArray *urlArray;
@property (nonatomic, copy) NSArray *frameArray;
@property (nonatomic, assign) CGRect currentFrame;
@property (nonatomic, copy) dismissGallery dismissComplete;
@end
