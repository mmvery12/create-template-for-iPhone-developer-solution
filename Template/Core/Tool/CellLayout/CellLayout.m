//
//  CellLayout.m
//  ListDemo
//
//  Created by FeiNiu-Mac on 15/3/31.
//  Copyright (c) 2015年 FeiNiu-Mac. All rights reserved.
//

#import "CellLayout.h"

@interface CellLayout ()
{
    NSMutableArray *_attributeArray;
    NSMutableArray *_cellFrameArray;
}
@end

@implementation CellLayout
- (instancetype)init
{
    self = [super init];
    if (self) {
        _contentInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        _lineSpace = 10.;
        _sectionSpace = 10;
        _innerItemSpace = 10.;
        _direction = UICollectionViewScrollDirectionVertical;
        _numsOfCellsLine = 1;
        _cellHeight = 44;
    }
    return self;
}

-(void)traversalAttrs
{
    if (!_attributeArray) {
        _attributeArray = [NSMutableArray array];
    }
    [_attributeArray removeAllObjects];
    for (int section=0; section<[self numOfSection]; section++) {
        NSMutableArray *tempAttributeOfSectionArray = [NSMutableArray array];
        for (int row=0; row<[self numOfRowsInSection:section]; row++) {
            [tempAttributeOfSectionArray addObject:[self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]]];
        }
        [_attributeArray addObject:tempAttributeOfSectionArray];
    }
}


-(void)traversalFrame
{
    if (!_cellFrameArray) {
        _cellFrameArray = [NSMutableArray array];
    }
    [_cellFrameArray removeAllObjects];
    for (int section=0; section<[self numOfSection]; section++) {
        NSMutableArray *tempFrameArray = [NSMutableArray array];
        for (int row=0; row<[self numOfRowsInSection:section]; row++) {
            [tempFrameArray addObject:[self cellFrame:[NSIndexPath indexPathForRow:row inSection:section]]];
        }
        [_cellFrameArray addObject:tempFrameArray];
    }
}

-(NSValue *)cellFrame:(NSIndexPath *)indexPath
{
    CGFloat cellWidth = (self.collectionView.frame.size.width - (_contentInsets.left+_contentInsets.right) - _innerItemSpace*(_numsOfCellsLine -1))/_numsOfCellsLine;
    CGFloat cellHeight = _cellHeight;

    CGFloat lastSectionCellOrightHeight = 0.;
    if (indexPath.section!=0) {
        CGRect frame = [[[_cellFrameArray objectAtIndex:indexPath.section-1] lastObject] CGRectValue];
        lastSectionCellOrightHeight = frame.origin.y + frame.size.height;
    }
    NSInteger rows = indexPath.item / _numsOfCellsLine;
    NSInteger columns = indexPath.item % _numsOfCellsLine;
    CGFloat xex = _contentInsets.left + columns * _innerItemSpace + cellWidth * columns;
    CGFloat yex = (indexPath.section==0?_contentInsets.top:0) + indexPath.section * _sectionSpace + rows * _lineSpace + cellHeight * rows + lastSectionCellOrightHeight;
    CGRect rect = CGRectMake(xex , yex, cellWidth, cellHeight);
    return [NSValue valueWithCGRect:rect];
}


-(NSInteger)numOfSection
{
    return [self.collectionView numberOfSections];
}

-(NSInteger)numOfRowsInSection:(NSInteger)section
{
    return [self.collectionView numberOfItemsInSection:section];
}

-(NSInteger)totalHeight
{
    NSValue * frame = [[_cellFrameArray lastObject] lastObject];
    CGRect rect = [frame CGRectValue];
    return rect.origin.y+rect.size.height+_contentInsets.bottom;
}

-(NSInteger)vectCellsCount:(NSInteger)section
{
    NSInteger rowsInSection = 0;
    NSInteger itemsInSection = [self.collectionView numberOfItemsInSection:section];
    rowsInSection =itemsInSection / _numsOfCellsLine + (itemsInSection % _numsOfCellsLine > 0 ? 1 : 0);
    return rowsInSection;
}

#pragma mark layout override

-(void)prepareLayout
{
    [self traversalFrame];
    [self traversalAttrs];
}

-(CGSize)collectionViewContentSize
{
    return CGSizeMake(self.collectionView.frame.size.width, [self totalHeight]);
}

-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *visibleAttributes = [NSMutableArray array];
    for (NSArray *sectionAttributes in _attributeArray) {
        for (UICollectionViewLayoutAttributes *attributes in sectionAttributes) {
            [visibleAttributes addObject:attributes];
        }
    }
    return [visibleAttributes copy];
}


-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attribute.frame = [[[_cellFrameArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] CGRectValue];
    return attribute;
}

-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    if (!CGRectEqualToRect(newBounds, self.collectionView.bounds)) {
        return YES;
    }
    return NO;
}

#pragma mark -setter/getter
-(void)setNumsOfCellsLine:(NSInteger)numsOfCellsLine
{
    _numsOfCellsLine = numsOfCellsLine;
}

@end
