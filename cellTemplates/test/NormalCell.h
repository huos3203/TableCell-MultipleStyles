//
//  NormalCell.h
//  cellTemplates
//
//  Created by MgenLiu on 13-12-25.
//  Copyright (c) 2013年 Mgen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyTask.h"

@interface NormalCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

- (void)loadTask:(MyTask*)task;

@end
