//
//  XQToolbarView.m
//  XQToolbar
//
//  Created by 用户 on 16/8/30.
//  Copyright © 2016年 XinQianLiu. All rights reserved.
//

#import "XQToolbarView.h"

static NSString *const cellID = @"cellID";

@implementation XQToolbarView

#pragma mark - Initialize
+ (instancetype)toolbarViewWithTitles:(NSArray *)titles delegate:(id<XQToolbarViewDelegate>)delegate
{
    XQToolbarView *toolbarView = [[[self class] alloc] init];
    toolbarView.backgroundColor = [UIColor whiteColor];
    toolbarView.titlesArray = titles;
    toolbarView.delegate = delegate;
    return toolbarView;
}

- (instancetype)initWithTitles:(NSArray *)titles delegate:(id<XQToolbarViewDelegate>)delegate
{
    XQToolbarView *toolbarView = [[[self class] alloc] init];
    toolbarView.backgroundColor = [UIColor whiteColor];
    toolbarView.titlesArray = titles;
    toolbarView.delegate = delegate;
    return toolbarView;
}

- (instancetype)init
{
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = self.backgroundColor;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[XQCollectionViewCell class] forCellWithReuseIdentifier:cellID];
        _collectionView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_collectionView];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_collectionView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_collectionView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_collectionView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_collectionView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
        
        _selectedIndex = 0;
        _selectTextColor = [UIColor blackColor];
        _selectLineColor = [UIColor orangeColor];
        _deselectTextColor = [UIColor grayColor];
        _deselectLineColor = [UIColor whiteColor];
        _itemBackgroundColor = [UIColor whiteColor];
        _itemSize = CGSizeMake(50, 30);
        _itemInsets = UIEdgeInsetsMake(0, 5, 0, 5);
    }
    
    return self;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.titlesArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    XQCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    
    cell.titleLabel.text = self.titlesArray[indexPath.row];
    cell.contentView.backgroundColor = _itemBackgroundColor;
    if (_selectedIndex == indexPath.row) {
        cell.titleLabel.textColor = _selectTextColor;
        cell.lineView.backgroundColor = _selectLineColor;
    }
    else {
        cell.titleLabel.textColor = _deselectTextColor;
        cell.lineView.backgroundColor = _deselectLineColor;
    }
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    XQCollectionViewCell *cell;
    
    if ((_selectedIndex != indexPath.row) && (_selectedIndex < _titlesArray.count)) {
        NSIndexPath *path = [NSIndexPath indexPathForItem:_selectedIndex inSection:0];
        cell = (XQCollectionViewCell *)[collectionView cellForItemAtIndexPath:path];
        cell.titleLabel.textColor = _deselectTextColor;
        cell.lineView.backgroundColor = _deselectLineColor;
    }
    
    cell = (XQCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.titleLabel.textColor = _selectTextColor;
    cell.lineView.backgroundColor = _selectLineColor;
    _selectedIndex = indexPath.row;
    [_collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    
    if ([_delegate respondsToSelector:@selector(didSelectIndex:toolbarView:)]) {
        [_delegate didSelectIndex:_selectedIndex toolbarView:self];
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return _itemSize;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return _itemInsets;
}


#pragma mark - Setters
- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    _selectedIndex = selectedIndex;
    if ([NSThread isMainThread]) {
        [self performSelector:@selector(toSelectItem) withObject:nil afterDelay:0.1f];
    }
}

- (void)toSelectItem
{
    NSIndexPath *path = [NSIndexPath indexPathForItem:_selectedIndex inSection:0];
    [_collectionView selectItemAtIndexPath:path animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    [_collectionView reloadData];
}

- (void)setTitlesArray:(NSArray *)titlesArray
{
    _titlesArray = titlesArray;
    [_collectionView reloadData];
}

@end

@implementation XQCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:13];
        _titleLabel.textColor = [UIColor grayColor];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:_titleLabel];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1 constant:-3]];
        
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor clearColor];
        _lineView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:_lineView];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_lineView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_titleLabel attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_lineView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_lineView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_lineView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    }
    
    return self;
}

@end
