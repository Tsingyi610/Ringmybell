//
//  SearchViewController.h
//  impossible
//
//  Created by Blessed on 16/4/17.
//  Copyright © 2016年 ringmybell. All rights reserved.
//

#import "BaseViewController.h"

@interface HotCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;

@end

@interface SearchViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UICollectionView *hotCollectionView;
@property (weak, nonatomic) IBOutlet UITextField *searchInput;

@end
