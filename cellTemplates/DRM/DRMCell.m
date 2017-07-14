//
//  DRMCell.m
//  PBB
//
//  Created by pengyucheng on 16/2/26.
//  Copyright © 2016年 pyc.com.cn. All rights reserved.
//

#import "DRMCell.h"

@implementation DRMCell

-(id)initWithCellStyle:(DRMTableCellStyles)cellStyle
{
    NSString *cellIdentifier = @"";
    switch (cellStyle) {
        case DRMTableCellDefaultStyle:
            //
            cellIdentifier = @"DRMTableCellDefaultStyle";
            break;
        case DRMTableCellSelectAbleStyle:
            //
            cellIdentifier = @"DRMTableCellSelectAbleStyle";
            break;
        case DRMTableCellDowningStyle:
            //
            cellIdentifier = @"DRMTableCellDowningStyle";
            break;
        case DRMTableCellFinishStyle:
            //
            cellIdentifier = @"DRMTableCellFinishStyle";
            break;
        default:
            break;
    }
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    return self;
}


- (IBAction)ibaAddToDownQueue:(id)sender {
    if (_addDownData) {
        _addDownData(self);
    }
}

- (IBAction)ibRemoveDownQueue:(id)sender {
    if (_removeDownData) {
        _removeDownData(self);
    }
}

- (IBAction)ibaAddToDownQueueAndSelectForCancel:(UIButton *)sender
{
    //下载队列
    if (_downListQueueDatas)
    {
        if (sender.selected)
        {
            sender.selected = NO;
        }else
        {
            sender.selected = YES;
        }
        _downListQueueDatas(self);
    }
}

- (IBAction)ibaSelectForManage:(UIButton *)sender {
    if (_SelectedDatas) {
        if (sender.selected)
        {
            sender.selected = NO;
        }else
        {
            sender.selected = YES;
        }
        _SelectedDatas(self);
    }
}

- (void)loadTask:(MyTask*)task
{
    self.drmModel = task;
    self.ibFileName.text = task.title;
    self.progressView.progress = task.progress;
}

@end
