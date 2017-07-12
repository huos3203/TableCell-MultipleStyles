//
//  ViewController.m
//  cellTemplates
//
//  Created by MgenLiu on 13-12-26.
//  Copyright (c) 2013年 Mgen. All rights reserved.
//

#import "ViewController.h"
#import "MyTask.h"
#import "CompletedCell.h"
#import "NormalCell.h"

@interface ViewController ()
{
    NSMutableArray *_tasks;
}
@end

@implementation ViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

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
        [task start];
    }

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onTaskPrograssChanged:) name:kTASK_PROG_NOTIFICATION object:nil];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    return _tasks.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[GlobalCounter getInstance] add:@"get cell"];
    
    MyTask *task = [_tasks objectAtIndex:indexPath.row];
    if (task.isCompleted)
    {
        return [self getCompletedCell:task];
    }
    else
    {
        return [self getNormalCell:task];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[GlobalCounter getInstance] add:@"get height"];
    
    //Cell均只创建一次
    static NormalCell *normalCell = nil;
    static CompletedCell *compCell = nil;
    
    MyTask *task = [_tasks objectAtIndex:indexPath.row];
    if (task.isCompleted)
    {
        if (!compCell) //加载一种Cell
            compCell = [self getCompletedCell:task];
        return [self getCellHeight:compCell];
    }
    else
    {
        if (!normalCell) //加载另一种Cell
            normalCell = [self getNormalCell:task];
        return [self getCellHeight:normalCell];
    }
}

//获取Cell高度
- (CGFloat)getCellHeight:(UITableViewCell*)cell
{
    [cell layoutIfNeeded];
    [cell updateConstraintsIfNeeded];
    
    CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    return height;
}

- (CompletedCell*)getCompletedCell:(MyTask*)task
{
    CompletedCell *myCell = [self.tableView dequeueReusableCellWithIdentifier:@"CompletedCell"];
    if (!myCell)
    {
        myCell = [[CompletedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CompletedCell"];
    }
    [myCell loadTask:task];
    return myCell;
}

- (NormalCell*)getNormalCell:(MyTask*)task
{
    NormalCell *myCell = [self.tableView dequeueReusableCellWithIdentifier:@"NormalCell"];
    if (!myCell)
    {
        myCell = [[NormalCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NormalCell"];
    }
    [myCell loadTask:task];
    return myCell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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

@end
