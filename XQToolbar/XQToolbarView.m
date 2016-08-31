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
        _itmeBackgroundColor = [UIColor whiteColor];
        _itmeSize = CGSizeMake(50, 30);
        _itmeInsets = UIEdgeInsetsMake(0, 5, 0, 5);
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
    cell.contentView.backgroundColor = _itmeBackgroundColor;
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
    return _itmeSize;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return _itmeInsets;
}


#pragma mark - Setters
- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    _selectedIndex = selectedIndex;
    
    if (selectedIndex < _titlesArray.count) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSIndexPath *path = [NSIndexPath indexPathForItem:selectedIndex inSection:0];
            [_collectionView selectItemAtIndexPath:path animated:NO scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
            [_collectionView reloadData];
        });
    }
}


- (void)setTitlesArray:(NSArray *)titlesArray
{
    _titlesArray = titlesArray;
    [_collectionView reloadData];
}

@end