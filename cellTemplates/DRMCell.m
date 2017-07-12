//
//  DRMCell.m
//  PBB
//
//  Created by pengyucheng on 16/2/26.
//  Copyright © 2016年 pyc.com.cn. All rights reserved.
//

#import "DRMCell.h"

@implementation DRMCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [[NSBundle mainBundle] loadNibNamed:@"SendCelliPad" owner:nil options:nil][1];
    return self;
}

//-(void)setSzModel:(SZModelShare *)szModel
//{
//    self.szModel = szModel;
//    
//}

- (IBAction)deleteBtn:(UIButton *)sender {
    MyLog(@"delete once datas ");
    if (_deleteDatas) {
//        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"删除文件" message:@"一旦删除将无法恢复，确认删除？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
//        [alert show];
        if (sender.selected)
        {
            sender.selected = NO;
        }else
        {
            sender.selected = YES;
        }
         _deleteDatas(self);
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1&&[alertView.title isEqualToString:@"删除文件"]) {
        _deleteDatas(self);
    }
    
}


#pragma mark 侧滑按钮实现
- (void)setShowViewState:(BOOL)show animation:(BOOL)animation
{
    if (show) {
        [self showWithViewAnimation:animation];
        
    } else {
        [self hideWihtViewAnimation:animation];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}


#pragma mark 显示view的位置
- (void)showWithViewAnimation:(BOOL)animation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        [self setFrameWithView:_cellView point:(CGPoint){-100,0} animation:animation];
    }else{
        [self setFrameWithView:_cellView point:(CGPoint){-200,0} animation:animation];
    }
}

#pragma  mark 隐藏view的位置`
- (void)hideWihtViewAnimation:(BOOL)animation
{
    [self setFrameWithView:_cellView point:(CGPoint){0,0} animation:animation];
}


#pragma mark 修改view的位置 ,使用动画
- (void)setFrameWithView:(UIView *)view point:(CGPoint)point animation:(BOOL)animation
{
    if (animation) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        CGRect frame = view.frame;
        frame.origin = point;
        view.frame = frame;
        [UIView commitAnimations];
    } else {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        CGRect frame = view.frame;
        frame.origin = point;
        view.frame = frame;
        [UIView commitAnimations];
    }
}


@end
