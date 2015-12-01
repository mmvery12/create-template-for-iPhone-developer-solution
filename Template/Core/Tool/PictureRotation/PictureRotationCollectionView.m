//
//  PictureRotationCollectionView.m
//  Template
//
//  Created by liyuchang on 15/11/3.
//  Copyright (c) 2015年 liyuchang. All rights reserved.
//

#import "PictureRotationCollectionView.h"
static NSString * const reuseIdentifier = @"Cell";

@interface PictureRotationCollectionView ()
{
    UICollectionView *collection;
    
    CGFloat originy;
    CGFloat bannerOriginHeight;
    CGFloat bannerHeight;
    NSInteger _tcount;
    NSInteger preBannerIndex;
    NSInteger curBannerIndex;
    NSInteger _realCount;
    
    NSTimer *timer;
    
    UIPageControl *page;
}
@property (nonatomic,retain)NSMutableArray *appendImagesArr;

@end

@implementation PictureRotationCollectionView


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.frame.size.width, self.frame.size.height);
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        collection = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
        [self addSubview:collection];
        collection.delegate = self;
        collection.dataSource = self;
        [collection mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        page = [[UIPageControl alloc] init];
        [self addSubview:page];
        page.hidesForSinglePage = YES;
        page.pageIndicatorTintColor = [UIColor lightGrayColor];
        page.currentPageIndicatorTintColor = [UIColor whiteColor];
        [page mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@([UIScreen mainScreen].bounds.size.width/3.));
            make.height.equalTo(@33);
            make.right.equalTo(self.mas_right);
            make.bottom.equalTo(self.mas_bottom);
        }];
        
        _appendImagesArr = [NSMutableArray array];
        [collection registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
        bannerOriginHeight = bannerHeight = frame.size.height;
        collection.pagingEnabled = YES;
        collection.showsHorizontalScrollIndicator =
        collection.showsVerticalScrollIndicator = NO;
        [self addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
        self.clipsToBounds = YES;
        self.layer.masksToBounds = YES;
        bannerHeight = self.frame.size.height;
        
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor whiteColor];
        collection.backgroundView = view;
    }
    return self;
}



#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _appendImagesArr.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    cell.backgroundView = view;
    UIImageView *imageView = (id)[cell viewWithTag:99802];
    if (!imageView) {
        imageView = [UIImageView new];
        imageView.tag = 99802;
        [cell addSubview:imageView];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    id imageurl = nil;
    if (self.imageurlatindexcallback) {
        imageurl = self.imageurlatindexcallback(indexPath);
    }
    if ([imageurl isKindOfClass:[NSString class]]) {
        [imageView setImageWithURL:[NSURL URLWithString:imageurl]];
    }
    if ([imageurl isKindOfClass:[UIImage class]]) {
        imageView.image = (id)imageurl;
    }
    imageView.frame = CGRectMake(0, 0, self.frame.size.width, bannerHeight);

    return cell;
}


-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (!_needScale) {
        return;
    }
    if ([object isEqual:self]) {
        [collection reloadData];
    }
}

-(void)picturescrollViewDidScroll:(UIScrollView *)scrollView;
{
    [self scrollViewDidScroll:scrollView];
}
-(void)picturescrollViewWillBeginDragging:(UIScrollView *)scrollView;
{
    [self scrollViewWillBeginDragging:scrollView];
}
-(void)picturescrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset;
{
    [self scrollViewWillEndDragging:scrollView withVelocity:velocity targetContentOffset:targetContentOffset];
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    
    CGFloat offy = scrollView.contentOffset.y;
    if (offy<=0 && ![scrollView isEqual:collection] && _needScale) {
        CGFloat thresholdoffset = 0.;
        if ((iOS7||iOS8) && [UINavigationBar appearance].translucent==NO) {
            thresholdoffset = 64;
        }
        CGRect frame = self.frame;
        frame.size.height=-offy+bannerOriginHeight;
        frame.origin.y = offy;
        self.frame = CGRectMake(0, frame.origin.y+thresholdoffset, self.frame.size.width, frame.size.height-thresholdoffset);
        bannerHeight = self.frame.size.height;
    }
    
    if ([collection isEqual:scrollView]) {
        CGFloat offx = scrollView.contentOffset.x;
        CGFloat witdh = scrollView.frame.size.width;
        CGFloat parm1 = offx/witdh;
        preBannerIndex = curBannerIndex = parm1;
        CGFloat offNeedBegin = scrollView.frame.size.width * (_tcount-1);
        CGFloat offNeedEnd = scrollView.frame.size.width * 0;
        if (offx<=offNeedEnd&&_tcount!=1) {//开头
            preBannerIndex = curBannerIndex = _realCount;
            [scrollView setContentOffset:CGPointMake(offNeedBegin-scrollView.frame.size.width, 0)];
        }
        if (offx>=offNeedBegin&&_tcount!=1) {//尾部
            preBannerIndex = curBannerIndex = 1;
            [scrollView setContentOffset:CGPointMake(offNeedEnd+scrollView.frame.size.width, 0)];
        }
        NSInteger index = preBannerIndex;
        if (index==0) {
            index=1;
        }
        NSInteger xx = [[NSString stringWithFormat:@"%ld/%ld",index,_imagesContentArr.count] integerValue];
        page.currentPage = xx-1;
    }
}

-(void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    [collection setContentOffset:CGPointMake([UIScreen mainScreen].bounds.size.width,0)];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:collection]) {
        [self endTimer];
    }
}

-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if ([scrollView isEqual:collection]) {
        [self beginTimer];
    }
}

-(void)recycleShowImages
{
    __weak typeof(collection) tempb = collection;
    NSInteger index = (preBannerIndex+1);
    [UIView animateWithDuration:0.5 animations:^{
        [tempb  setContentOffset:CGPointMake(index*self.frame.size.width-1, 0)];
    } completion:^(BOOL finished) {
        [tempb  setContentOffset:CGPointMake(index*self.frame.size.width, 0)];
    }];
}

-(CGFloat)adjustHeightWithWidth:(CGFloat)width height:(CGFloat)height
{
    CGSize size = self.frame.size;
    CGFloat dheight = size.width/(width/height);
    return dheight;
}

-(void)beginTimer
{
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
    
    if (!_appendImagesArr || _appendImagesArr.count==0) {
        return;
    }

    if (!timer && _imagesContentArr && _imagesContentArr.count>1) {
        timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(recycleShowImages) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    }
}

-(void)setImagesContentArr:(NSMutableArray *)imagesContentArr
{
    page.numberOfPages = imagesContentArr.count;
    if (_imagesContentArr) {
        [_imagesContentArr removeAllObjects];
    }else
        _imagesContentArr = [NSMutableArray array];
    [_imagesContentArr addObjectsFromArray:imagesContentArr];
    {
        _realCount = [imagesContentArr count];
        if (!_appendImagesArr) {
            _appendImagesArr = [NSMutableArray array];
        }
        [_appendImagesArr removeAllObjects];
        CGFloat originBeginOffsetx = 0;
        if (_realCount>1) {
            originBeginOffsetx = self.frame.size.width;
            [_appendImagesArr addObject:[[imagesContentArr lastObject] copy]];
            [_appendImagesArr addObjectsFromArray:imagesContentArr];
            [_appendImagesArr addObject:[[imagesContentArr objectAtIndex:0] copy]];
        }else
        {
            originBeginOffsetx = 0;
            [_appendImagesArr addObjectsFromArray:imagesContentArr];
        }
        _tcount = [_appendImagesArr count];
        [collection setContentOffset:CGPointMake(originBeginOffsetx,0)];
    }
    [collection reloadData];
    [self beginTimer];
}

-(void)endTimer
{
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_prCallBack) {
        _prCallBack(_appendImagesArr[indexPath.row]);
    }
}
@end
