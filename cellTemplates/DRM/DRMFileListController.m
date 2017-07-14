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
    
    NSMutableArray * _downFinishArray;
    NSMutableArray * _canDownArray;
    NSMutableArray * _operationArray;  //当前批量操作的数据数组
    NSMutableArray * _batchSourceArray;  //批量处理数据源
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
        task.status = DRMListCellDefaultStyle;
        [_canDownArray addObject:task];
        [_tasks addObject:task];
    }
    
    for (int i = 10; i < 20; i++) {
        MyTask *task = [MyTask new];
        task.title = [NSString stringWithFormat:@"任务：%d", i + 1];
        task.taskId = i;
        task.status = DRMListCellFinishStyle;
        [_downFinishArray addObject:task];
        [_tasks addObject:task];
    }
    
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
    NSInteger row;
    if (task.status == DRMListCellDefaultStyle)
    {
        row = [_tasks indexOfObject:task];
        
    }
    else
    {
        row = [_batchSourceArray indexOfObject:task];
    }
    NSIndexPath *path = [NSIndexPath indexPathForRow:row inSection:0];
    DRMCell *cell = [self.tableView cellForRowAtIndexPath:path];
    [cell loadTask:task];
    
    
    //    [self.tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
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
    if (!_batchSourceArray)
    {
        numberOfRows = [_tasks count];
        if (numberOfRows < 6)
        {
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
    MyTask *task;
    if (_batchSourceArray) {
        task = [_batchSourceArray objectAtIndex:indexPath.row];
    } else {
        task = [_tasks objectAtIndex:indexPath.row];
    }
    DRMCell *cell;
    switch (task.status) {
        case DRMListCellDefaultStyle:
            //
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"DRMTableCellDefaultStyle"];
            cell.addDownData = ^(DRMCell *cell){
                //TODO: 开始下载
                cell.drmModel.status = DRMListCellDowningStyle;
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                [task start];
            };
        }
            break;
        case DRMListCellSelectAbleStyle:
            //默认可选样式
        {
            cell = [self cellTypeSelectForOperation:task];
        }
            break;
        case DRMListCellDowningStyle:
            //取消全部下载，下载队列cell样式
        {
            cell = [self cellTypeDownListForOperation:task];
        }
            break;
        case DRMListCellFinishStyle:
            //
        {
            //TODO:下载完成
            cell = [tableView dequeueReusableCellWithIdentifier:@"DRMTableCellFinishStyle"];
            [cell loadTask:task];
        }
            break;
            
        default:
            break;
    }
    [cell loadTask:task];
    return cell;
}
#pragma mark - 实现几种样式的cell事件
//下载列表
-(DRMCell *)cellTypeDownListForOperation:(MyTask *)task
{
    DRMCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"DRMTableCellDowningStyle"];
    if (_operationType == DRMToDefaultDontOperationType) {
        //
        cell.ibHiddenAddToDownQueueButton.priority = 1000;
        [cell.ibAddToDownQueueButton setHidden:YES];
    }else{
        cell.ibHiddenAddToDownQueueButton.priority = 250;
        [cell.ibAddToDownQueueButton setHidden:NO];
    }
    __weak typeof(self) weakSelf = self;
    cell.downListQueueDatas = ^(DRMCell *cell){
        //添加/移除下载操作数据
        if(cell.ibaSelectForManageButton.selected)
        {
            //FIXME: 下载列表加入取消数据
            [_operationArray addObject:cell];
        }
        else
        {
            //FIXME: 下载列表加入取消数据
            [_operationArray removeObject:cell];
            
        }
    };
    cell.removeDownData = ^(DRMCell *cell){
        //TODO:取消下载
        cell.drmModel.status = DRMListCellSelectAbleStyle;
        if(_operationType == DRMToDefaultDontOperationType)
        {
            cell.drmModel.status = DRMListCellDefaultStyle;
        }
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
            [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }];
    };
    cell.ibAddToDownQueueButton.selected = NO;
    return cell;
}

//普通可选样式cell
-(DRMCell *)cellTypeSelectForOperation:(MyTask *)task
{
    DRMCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"DRMTableCellSelectAbleStyle"];
    if (_operationType == DRMToDefaultDontOperationType) {
        //
        cell.ibHiddenSelectForManageButton.priority = 1000;
        [cell.ibaSelectForManageButton setHidden:YES];
    }else{
        cell.ibHiddenSelectForManageButton.priority = 250;
        [cell.ibaSelectForManageButton setHidden:NO];
    }
    
    //   __unsafe_unretained DRMFileListController *drmFile = self;
    cell.SelectedDatas = ^(DRMCell *cell){
        
        //批量处理：添加/移除操作数据
        if(cell.ibaSelectForManageButton.selected)
        {
            //FIXME: 下载列表加入取消数据
            [_operationArray addObject:cell];
            
            if (_operationType == DRMAllToOperationCancelDown)
            {
                //TODO: 将所选文件加入下载队列
                cell.drmModel.status = DRMListCellDowningStyle;
                NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                [task start];
            }
        } else {
            //FIXME: 下载列表加入取消数据
            [_operationArray removeObject:cell];
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
    cell.ibaSelectForManageButton.selected = NO;
    return cell;
}


#pragma mark cell删除事件
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
     // Return NO if you do not want the specified item to be editable.
     DRMCell *cell = [tableView cellForRowAtIndexPath:indexPath];
     if (cell.drmModel.status == DRMListCellFinishStyle)
     {
         return YES;
     }
     return NO;
 }
 

 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
     if (editingStyle == UITableViewCellEditingStyleDelete) {
         // Delete the row from the data source
         //TODO: 删除单个文件
         DRMCell *cell = [tableView cellForRowAtIndexPath:indexPath];
         [_operationArray addObject:cell];
         [self deleteSelected];
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
    [self switchToolBarOperation:@""];
    switch (_operationType) {
            
        case DRMAllToOperationDelete:
            //TODO: 删除全部
        {
            [self deleteAll];
            _operationType = DRMToDefaultDontOperationType;
            _batchSourceArray = nil;
            _operationArray = nil;
            [self.tableView reloadData];
        }
            break;
        case DRMSelectedToOperationDelete:
            //TODO: 删除所选
        {
            [self deleteSelected];
            _operationType = DRMToDefaultDontOperationType;
            _batchSourceArray = nil;
            _operationArray = nil;
            [self.tableView reloadData];
        }
            break;
            
        case DRMAllToOperationStartDown:
            //TODO: 下载全部
        {
            [self downAll];
            //更新toolbar和cell
            [self switchToolBarOperation:@"取消全部"];
            _operationType = DRMAllToOperationCancelDown;
            [_operationArray removeAllObjects];
            [self.tableView reloadData];
        }
            break;
        case DRMSelectedToOperationStartDown:
            //TODO: 开始下载
        {
            [self downSelected];
            //更新toolbar和cell
            [self switchToolBarOperation:@"取消全部"];
            _operationType = DRMAllToOperationCancelDown;
            [_operationArray removeAllObjects];
        }
            break;
        case DRMAllToOperationCancelDown:
            //TODO: 取消全部,返回到主页并保持现有状态
        {
            [self cancelAllDowning];
            _operationType = DRMToDefaultDontOperationType;
            _batchSourceArray = nil;
            _operationArray = nil;
            [self.tableView reloadData];
        }
            break;
        default:
            break;
    }
}


//隐藏已下载，更新数据源即可
- (IBAction)ibaDownByBatch:(UIButton *)sender
{
    //
    _operationArray = [NSMutableArray array];
    _operationType = DRMAllToOperationStartDown;
    [self switchToolBarOperation:@"下载全部"];
    
    //FIXME: 待替换
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"taskId =< 10"];
    _batchSourceArray = [[_tasks filteredArrayUsingPredicate:predicate] mutableCopy];
    [_batchSourceArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        MyTask *task = (MyTask*)obj;
        task.status = DRMListCellSelectAbleStyle;
    }];
    [self.tableView reloadData];
}

//隐藏未下载，更新数据源即可
- (IBAction)ibaDeleteBybatch:(id)sender
{
    _operationArray = [NSMutableArray array];
    _operationType = DRMAllToOperationDelete;
    [self switchToolBarOperation:@"删除全部"];
    
    //FIXME: 待替换
    //TODO: 过滤未下载数据源
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"taskId >= 10"];
    _batchSourceArray = [[_tasks filteredArrayUsingPredicate:predicate] mutableCopy];
    [_batchSourceArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        MyTask *task = (MyTask*)obj;
        task.status = DRMListCellSelectAbleStyle;
    }];
    [self.tableView reloadData];
}

//切换底部toolbar 和 tableCell样式
-(void)switchToolBarOperation:(NSString *)operation
{
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

#pragma mark - 具体操作实现
#pragma mark 删除已下载文件
-(void)deleteAll
{
    [_batchSourceArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [_tasks removeObject:obj];
    }];
}

-(void)deleteSelected
{
    [_operationArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        DRMCell *cell = (DRMCell *)obj;
//        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
//        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [_tasks removeObject:cell.drmModel];
        [_batchSourceArray removeObject:cell.drmModel];
    }];
    //指定剩余cell的样式
    [_batchSourceArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        MyTask *task = (MyTask *)obj;
        task.status = DRMListCellFinishStyle;
    }];
}

#pragma mark 下载管理
-(void)downAll
{
    [_batchSourceArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        MyTask *task = (MyTask *)obj;
        task.status = DRMListCellDowningStyle;
        [task start];
    }];
}

-(void)downSelected
{
    [_operationArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        DRMCell *cell = (DRMCell *)obj;
        cell.drmModel.status = DRMListCellDowningStyle;
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }];
        [cell.drmModel start];
    }];
}

-(void)cancelAllDowning
{
    [_operationArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        DRMCell *cell = (DRMCell *)obj;
        cell.drmModel.status = DRMListCellDefaultStyle;
        [_batchSourceArray removeObject:cell.drmModel];
    }];
    [_batchSourceArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        MyTask *task = (MyTask *)obj;
        task.status = DRMListCellDefaultStyle;
    }];
}
@end

