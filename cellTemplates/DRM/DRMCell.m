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
}

- (IBAction)ibaAddToDownQueueAndSelectForCancel:(id)sender
{
    //下载队列
    
}

- (IBAction)ibaSelectForManage:(UIButton *)sender {
    if (_SelectedDatas) {
        //        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"删除文件" message:@"一旦删除将无法恢复，确认删除？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        //        [alert show];
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

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1&&[alertView.title isEqualToString:@"删除文件"]) {
        _SelectedDatas(self);
    }
    
}

- (void)loadTask:(MyTask*)task
{
    self.ibFileName.text = task.title;
    self.progressView.progress = task.progress;
}

@end
