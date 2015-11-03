//
//  CellLayout.h
//  ListDemo
//
//  Created by FeiNiu-Mac on 15/3/31.
//  Copyright (c) 2015年 FeiNiu-Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellLayout : UICollectionViewLayout
@property (nonatomic,assign) UIEdgeInsets contentInsets;//def 10*10*10*10
@property (nonatomic,assign) CGFloat cellHeight;//def 44
@property (nonatomic,assign) CGFloat lineSpace;//def 10.
@property (nonatomic,assign) CGFloat sectionSpace;//def 20
@property (nonatomic,assign) CGFloat innerItemSpace;//def 10.
@property (nonatomic,assign) UICollectionViewScrollDirection direction;//def ver
@property (nonatomic,assign) NSInteger numsOfCellsLine;//def 2

@end