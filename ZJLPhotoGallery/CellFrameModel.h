//
//  CellFrameModel.h
//  ZJLPhotoGallery
//
//  Created by ZhongZhongzhong on 16/6/15.
//  Copyright © 2016年 ZhongZhongzhong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CellFrameModel : NSObject
@property (nonatomic, assign) CGRect frame;

- (instancetype)initWithView:(UIView *)cell;
@end
