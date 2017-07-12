//
//  DRMFileListController.m
//  cellTemplates
//
//  Created by pengyucheng on 12/07/2017.
//  Copyright © 2017 Mgen. All rights reserved.
//

#import "DRMFileListController.h"
#import "MyTask.h"
#import "CompletedCell.h"
#import "NormalCell.h"

#import "DRMCell.h"


@interface DRMFileListController ()
{
    NSMutableArray *_tasks;
    
    NSInteger _currentType;  //1: 批量下载  2:批量删除
}
@end

@implementation DRMFileListController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _tasks = [NSMutableArray array];
    for (int i = 0; i < 100; i++)
    {
        MyTask *task = [MyTask new];
        task.title = [NSString stringWithFormat:@"任务：%d", i + 1];
        task.taskId = i;
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
    return 5;//_tasks.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[GlobalCounter getInstance] add:@"get cell"];
    MyTask *task = [_tasks objectAtIndex:indexPath.row];
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
         [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
     }
     else if (editingStyle == UITableViewCellEditingStyleInsert) {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
 }
 

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a story board-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 
 */



- (IBAction)ibaOperationToSelected:(id)sender
{
    //
    if (_currentType == 1) {
        //TODO: 开始下载
    }
    
    if (_currentType ==2 )
    {
        //TODO: 删除全部
    }
    
}

- (IBAction)ibaDownByBatch:(UIButton *)sender
{
    _currentType = 1;
    [_ibOperationToSelected setHidden:NO];
    [_ibOperationToSelected setTitle:@"开始下载" forState:UIControlStateNormal];
    [_ibDownByBatch setHidden:YES];
    [_ibDeleteBybatch setHidden:YES];
}

- (IBAction)ibaDeleteBybatch:(id)sender
{
    _currentType = 2;
    //隐藏其他bar
    [_ibOperationToSelected setHidden:NO];
    [_ibOperationToSelected setTitle:@"删除全部" forState:UIControlStateNormal];
    [_ibDownByBatch setHidden:YES];
    [_ibDeleteBybatch setHidden:YES];
}
@end

