//
//  XQToolbarView.h
//  XQToolbar
//
//  Created by 用户 on 16/8/30.
//  Copyright © 2016年 XinQianLiu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XQToolbarView;
@protocol XQToolbarViewDelegate <NSObject>

- (void)didSelectIndex:(NSInteger)selectIndex toolbarView:(XQToolbarView *)toolbarView;

@end

@interface XQToolbarView : UIView <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

+ (instancetype)toolbarViewWithTitles:(NSArray *)titles delegate:(id<XQToolbarViewDelegate>)delegate;

- (instancetype)initWithTitles:(NSArray *)titles delegate:(id<XQToolbarViewDelegate>)delegate;

@property (nonatomic, strong) UICollectionView              *collectionView;
@property (nonatomic, strong) NSArray                       *titlesArray;
@property (nonatomic, assign) NSInteger                     selectedIndex;          // Default 0
@property (nonatomic, strong) UIColor                       *selectTextColor;       // Default blackColor
@property (nonatomic, strong) UIColor                       *selectLineColor;       // Default orangeColor
@property (nonatomic, strong) UIColor                       *deselectTextColor;     // Default grayColor
@property (nonatomic, strong) UIColor                       *deselectLineColor;     // Default whiteColor
@property (nonatomic, strong) UIColor                       *itemBackgroundColor;   // Default whiteColor
@property (nonatomic, assign) CGSize                        itemSize;               // Default CGSizeMake(50, 30);
@property (nonatomic, assign) UIEdgeInsets                  itemInsets;             // Default UIEdgeInsetsMake(0, 5, 0, 5)
@property (nonatomic, assign) id <XQToolbarViewDelegate>    delegate;
@end


@interface XQCollectionViewCell : UICollectionViewCell

@property (nonatomic) UILabel   *titleLabel;
@property (nonatomic) UIView    *lineView;

@end
