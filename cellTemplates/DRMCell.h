//
//  DRMCell.h
//  PBB
//
//  Created by pengyucheng on 16/2/26.
//  Copyright © 2016年 pyc.com.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZModelSearch.h"
#import "UIImageView+WebCache.h"
@interface DRMCell : UITableViewCell<UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *ibFileName;
@property (weak, nonatomic) IBOutlet UILabel *ibFileDescription;
@property (weak, nonatomic) IBOutlet UIView *cellView;
@property (weak, nonatomic) IBOutlet UIImageView *ibImageView;

@property (weak, nonatomic) IBOutlet UIButton *ibDelSelected;
@property (nonatomic, copy) void (^deleteDatas)(DRMCell *);
- (IBAction)deleteBtn:(UIButton *)sender;

//60:0   0:20
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ibCellViewLeftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ibFileImgLeftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ibRevokeShowLabelConstraint;



@property (weak, nonatomic) SZModelShare *szModel;

@property (strong, nonatomic) SZModelSearch *szSearchModel;

@end
