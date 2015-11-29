//
//  PictureRotationCollectionView.h
//  Template
//
//  Created by liyuchang on 15/11/3.
//  Copyright (c) 2015年 liyuchang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PictureRotationSelectedCallBack)(id datasource);

@interface PictureRotationCollectionView : UIView<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic,retain)NSMutableArray *imagesContentArr;
@property (nonatomic,copy)PictureRotationSelectedCallBack prCallBack;

@property (nonatomic,assign)BOOL needScale;


-(void)beginTimer;
-(void)endTimer;
//此处不用delegate require来保证调用
//require
//拉动产生图片放大效果
-(void)picturescrollViewDidScroll:(UIScrollView *)scrollView;
-(void)picturescrollViewWillBeginDragging:(UIScrollView *)scrollView;
-(void)picturescrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset;
@end
