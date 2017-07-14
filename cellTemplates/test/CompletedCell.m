//
//  CompletedCell.m
//  cellTemplates
//
//  Created by MgenLiu on 13-12-25.
//  Copyright (c) 2013年 Mgen. All rights reserved.
//

#import "CompletedCell.h"

@implementation CompletedCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [[GlobalCounter getInstance] add:@"create completed cell"];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)loadTask:(MyTask *)task
{
    self.titleLabel.text = task.title;
}


@end
