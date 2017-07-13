//
//  DRMCell.h
//  PBB
//
//  Created by pengyucheng on 16/2/26.
//  Copyright © 2016年 pyc.com.cn. All rights reserved.
//

typedef NSUInteger DRMTableCellStyles;
enum DRMTableCellStyles {
    DRMTableCellDefaultStyle,   //默认状态
    DRMTableCellSelectAbleStyle, //批量操作状态
    DRMTableCellDowningStyle,  //正在下载状态
    DRMTableCellFinishStyle,   //已完成
};

#import <UIKit/UIKit.h>
#import "MyTask.h"

@interface DRMCell : UITableViewCell<UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *ibFileName;
@property (weak, nonatomic) IBOutlet UILabel *ibFileDescription;
@property (strong, nonatomic) MyTask *drmModel;
//文件大小
@property (weak, nonatomic) IBOutlet UILabel *ibFileSizeLabel;

@property (weak, nonatomic) IBOutlet UIView *cellView;
@property (weak, nonatomic) IBOutlet UIImageView *ibImageView;

@property (weak, nonatomic) IBOutlet UIButton *ibDelSelected;
@property (nonatomic, copy) void (^SelectedDatas)(DRMCell *);
@property (nonatomic, copy) void (^downListQueueDatas)(DRMCell *);
@property (nonatomic, copy) void (^addDownData)(DRMCell *);
@property (nonatomic, copy) void (^removeDownData)(DRMCell *);


//


//cell样式
@property (nonatomic,assign) DRMTableCellStyles cellStyle;

//单个文件下载
- (IBAction)ibaAddToDownQueue:(id)sender;
//单个文件取消下载
- (IBAction)ibRemoveDownQueue:(id)sender;

//下载列表中的选择按钮的事件
@property (weak, nonatomic) IBOutlet  UIButton *ibAddToDownQueueButton;
- (IBAction)ibaAddToDownQueueAndSelectForCancel:(UIButton *)sender;

//批量处理时的多选框
@property (weak, nonatomic) IBOutlet UIButton *ibaSelectForManageButton;
- (IBAction)ibaSelectForManage:(UIButton *)sender;


//下载进度条
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

//初始状态
-(id)initWithCellStyle:(DRMTableCellStyles)cellStyle;


- (void)loadTask:(MyTask*)task;
@end
