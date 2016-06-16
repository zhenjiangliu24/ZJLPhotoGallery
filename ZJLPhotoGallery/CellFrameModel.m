//
//  CellFrameModel.m
//  ZJLPhotoGallery
//
//  Created by ZhongZhongzhong on 16/6/15.
//  Copyright © 2016年 ZhongZhongzhong. All rights reserved.
//

#import "CellFrameModel.h"

@implementation CellFrameModel
- (instancetype)initWithView:(UIView *)cell
{
    if (self = [super init]) {
        _frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height);
    }
    return self;
}
@end
