//
//  DRMFileListController.h
//  cellTemplates
//
//  Created by pengyucheng on 12/07/2017.
//  Copyright © 2017 Mgen. All rights reserved.
//

#import <UIKit/UIKit.h>
//操作: 开始下载/全部下载   ----   取消全部   -----  删除全部/删除所选
typedef NSUInteger DRMToOperationType;
enum DRMToOperationType {
    DRMSelectedToOperationStartDown,   //开始下载
    DRMAllToOperationStartDown,          //全部下载
    DRMAllToOperationCancelDown,         //取消全部
    DRMSelectedToOperationDelete, //删除所选
    DRMAllToOperationDelete,        //删除全部
};
@interface DRMFileListController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

//批量下载
//@property (weak, nonatomic) IBOutlet UIBarButtonItem *ibDownByBatch;
//- (IBAction)ibaDownByBatch:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *ibDownByBatch;
- (IBAction)ibaDownByBatch:(UIButton *)sender;

//批量删除
@property (weak, nonatomic) IBOutlet UIButton *ibDeleteBybatch;
- (IBAction)ibaDeleteBybatch:(id)sender;

//操作: 开始下载/全部下载   ----   取消全部   -----  删除全部/删除所选
@property (nonatomic,assign) DRMToOperationType operationType;
@property (weak, nonatomic) IBOutlet UIButton *ibOperationToSelected;
- (IBAction)ibaOperationToSelected:(id)sender;


@end
