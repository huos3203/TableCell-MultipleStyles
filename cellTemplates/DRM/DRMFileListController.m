//
//  DRMFileListController.m
//  cellTemplates
//
//  Created by pengyucheng on 12/07/2017.
//  Copyright © 2017 Mgen. All rights reserved.
//

#import "DRMFileListController.h"
#import "MyTask.h"

#import "DRMCell.h"


@interface DRMFileListController ()
{
    NSMutableArray *_tasks;
    
    NSMutableArray * _operationArray;  //当前批量操作的数据数组
    NSArray * _batchSourceArray;  //批量处理数据源
}
@end

@implementation DRMFileListController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _tasks = [NSMutableArray array];
    for (int i = 0; i < 10; i++)
    {
        MyTask *task = [MyTask new];
        task.title = [NSString stringWithFormat:@"任务：%d", i + 1];
        task.taskId = i;
        [_tasks addObject:task];
    }
    _listCellStyle = DRMListCellDefaultStyle;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onTaskPrograssChanged:) name:kTASK_PROG_NOTIFICATION object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kTASK_PROG_NOTIFICATION object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"%@", [[GlobalCounter getInstance] dictionary]);
    NSLog(@"%@", @"=== 等待3秒 ===");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"%@", [[GlobalCounter getInstance] dictionary]);    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onTaskPrograssChanged:(NSNotification *)notification
{
    MyTask *task = notification.object;
    NSLog(@"下载进度....%f",task.progress);
    NSIndexPath *path = [NSIndexPath indexPathForRow:task.taskId inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //MARK:处于默认list时，当少于6个，隐藏toolbar
    NSInteger numberOfRows = 0;
    if(_listCellStyle == DRMListCellDefaultStyle)
    {
        numberOfRows = [_tasks count];
        if (numberOfRows < 6)
        {
            //
            [_ibBottomToolbar setHidden:YES];
            _ibBottomToolBarHeight.constant = 0;
        }
        return numberOfRows;
    }
    else
    {
        numberOfRows = [_batchSourceArray count];
    }
    return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //cell数据源
    MyTask *task = [_tasks objectAtIndex:indexPath.row];
    //
    if (_listCellStyle != DRMListCellDefaultStyle)
    {
        DRMCell *cell;
        switch (_operationType) {
            case DRMListCellDowningStyle:  //取消全部下载，下载队列cell样式
                cell = [self cellTypeDownListForOperation:task];
                break;
            default:   //默认可选样式
                cell = [self cellTypeSelectForOperation:task];
                break;
        }
        //加载数据
        [cell loadTask:task];
        return cell;
    }
    
    if (task.isCompleted)
    {
        //TODO:下载完成
        DRMCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DRMTableCellFinishStyle"];
        [cell loadTask:task];
        return cell;
    }
    else if (task.progress < 1.0 && task.progress > 0)
    {
        DRMCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DRMTableCellDowningStyle"];
        [cell loadTask:task];
        cell.removeDownData = ^(DRMCell *cell){
            //TODO:取消下载
        };
        return cell;
    }
    else{
        
        DRMCell *myCell = [tableView dequeueReusableCellWithIdentifier:@"DRMTableCellDefaultStyle"];
        myCell.addDownData = ^(DRMCell *cell){
            //TODO: 开始下载
            [task start];
        };
        return myCell;
    }
    
}
#pragma mark - 实现几种样式的cell事件
//下载列表
-(DRMCell *)cellTypeDownListForOperation:(MyTask *)task
{
    DRMCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"DRMTableCellDowningStyle"];
    cell.downQueueDatas = ^(DRMCell *cell){
        //添加/移除下载操作数据
        if(cell.ibaSelectForManageButton.selected)
        {
            //FIXME: 下载列表加入取消数据
            [_operationArray addObject:_tasks];
            
            //TODO: 将所选文件加入下载队列
            
        }
        else
        {
            //FIXME: 下载列表加入取消数据
            [_operationArray removeObject:_tasks];
            
        }
    };
    return cell;
}

//普通可选样式cell
-(DRMCell *)cellTypeSelectForOperation:(MyTask *)task
{
    DRMCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"DRMTableCellSelectAbleStyle"];
    //   __unsafe_unretained DRMFileListController *drmFile = self;
    cell.SelectedDatas = ^(DRMCell *cell){
        
        //批量处理：添加/移除操作数据
        if(cell.ibaSelectForManageButton.selected)
        {
            //FIXME: 下载列表加入取消数据
            [_operationArray addObject:_tasks];
        }
        else
        {
            //FIXME: 下载列表加入取消数据
            [_operationArray removeObject:_tasks];
        }
        
        if([_operationArray count] > 0)
        {
            //tool bar状态变化
            switch (_operationType) {
                case DRMAllToOperationStartDown:
                    _operationType = DRMSelectedToOperationStartDown;
                    [_ibOperationToSelected setTitle:@"开始下载" forState:UIControlStateNormal];
                    break;
                case DRMAllToOperationDelete:
                    _operationType = DRMSelectedToOperationDelete;
                    [_ibOperationToSelected setTitle:@"删除所选" forState:UIControlStateNormal];
                    break;
                default:
                    break;
            }
        }
        else
        {
            //
            switch (_operationType) {
                case DRMSelectedToOperationStartDown:
                    _operationType = DRMAllToOperationStartDown;
                    [_ibOperationToSelected setTitle:@"下载全部" forState:UIControlStateNormal];
                    break;
                case DRMSelectedToOperationDelete:
                    _operationType = DRMAllToOperationDelete;
                    [_ibOperationToSelected setTitle:@"删除全部" forState:UIControlStateNormal];
                    break;
                default:
                    break;
            }
        }
        
    };
    
    if ([_operationArray containsObject:_tasks])
    {
        cell.ibaSelectForManageButton.selected = YES;
    }
    else
    {
        cell.ibaSelectForManageButton.selected = NO;
    }
    return cell;
}


#pragma mark cell删除事件
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
     // Return NO if you do not want the specified item to be editable.
     return YES;
 }
 

 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
     if (editingStyle == UITableViewCellEditingStyleDelete) {
         // Delete the row from the data source
         //TODO: 删除单个文件
         [_tasks removeObjectAtIndex:indexPath.row];
         [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
     }
     else if (editingStyle == UITableViewCellEditingStyleInsert) {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
 }



/*
 #pragma mark - Navigation
 
 // In a story board-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 
 */


#pragma mark - toolbar按钮事件
- (IBAction)ibaOperationToSelected:(id)sender
{
    //切换
    [self switchCellStyle:DRMListCellDefaultStyle toolBarOperation:@""];
    switch (_operationType) {
            
        case DRMAllToOperationDelete:
            //TODO: 删除全部
        {
            
        }
            break;
        case DRMSelectedToOperationDelete:
            //TODO: 删除所选
        {
            
        }
            break;
            
        case DRMAllToOperationStartDown:
            //TODO: 下载全部
        {
            //TODO:下载功能 更新cell 由下载通知完成
            
            //更新toolbar和cell
            _operationType = DRMAllToOperationCancelDown;
            [self switchCellStyle:DRMListCellDowningStyle toolBarOperation:@"取消全部"];
        }
            break;
        case DRMSelectedToOperationStartDown:
            //TODO: 开始下载
        {
            //TODO:下载功能 更新cell 由下载通知完成
            
            //更新toolbar和cell
            _operationType = DRMAllToOperationCancelDown;
            [self switchCellStyle:DRMListCellDowningStyle toolBarOperation:@"取消全部"];
        }
            break;
        case DRMAllToOperationCancelDown:
            //TODO: 取消全部
        {
            
        }
            break;
        default:
            break;
    }
    
    //更新cell
    [self.tableView reloadData];
}


//隐藏已下载，更新数据源即可
- (IBAction)ibaDownByBatch:(UIButton *)sender
{
    //
    _operationArray = [NSMutableArray array];
    
    _operationType = DRMAllToOperationStartDown;
    [self switchCellStyle:DRMListCellSelectAbleStyle toolBarOperation:@"下载全部"];
    
    //FIXME: 待替换
    for (int i = 0; i < 10; i++)
    {
        MyTask *task = [MyTask new];
        task.title = [NSString stringWithFormat:@"任务：%d", i + 1];
        task.taskId = i;
        [_tasks addObject:task];
    }
    
    //TODO: 过滤未下载数据源
    _batchSourceArray = [_tasks mutableCopy];
    [self.tableView reloadData];
}

//隐藏未下载，更新数据源即可
- (IBAction)ibaDeleteBybatch:(id)sender
{
    _operationType = DRMAllToOperationDelete;
    [self switchCellStyle:DRMListCellSelectAbleStyle toolBarOperation:@"删除全部"];
    
    //FIXME: 待替换
    _operationArray = [NSMutableArray array];
    [_tasks removeObjectsInRange:NSMakeRange(0, 5)];
    
    //TODO: 过滤未下载数据源
    _batchSourceArray = [_tasks mutableCopy];
    [self.tableView reloadData];
}

//切换底部toolbar 和 tableCell样式
-(void)switchCellStyle:(DRMListCellStyle)style toolBarOperation:(NSString *)operation
{
    _listCellStyle = style;
    if (_ibOperationToSelected.hidden)
    {
        [_ibOperationToSelected setHidden:NO];
        [_ibDownByBatch setHidden:YES];
        [_ibDeleteBybatch setHidden:YES];
        [_ibOperationToSelected setTitle:operation forState:UIControlStateNormal];
    }
    else
    {
        [_ibOperationToSelected setHidden:YES];
        [_ibDownByBatch setHidden:NO];
        [_ibDeleteBybatch setHidden:NO];
    }
}
@end

