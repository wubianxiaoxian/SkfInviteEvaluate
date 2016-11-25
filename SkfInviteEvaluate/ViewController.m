//
//  ViewController.m
//  SkfInviteEvaluate
//
//  Created by 孙凯峰 on 2016/11/25.
//  Copyright © 2016年 孙凯峰. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIAlertViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)InviteEvaluate:(id)sender {
    [self QuestionGetAppInfoForComment];
    //
    
}
#pragma mark   ------------- 邀请用户去appstore评价  --------------
-(void)QuestionGetAppInfoForComment{
    //去appstore评分  //当前版本号
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    float appVersion = [[infoDictionary objectForKey:@"CFBundleShortVersionString"] floatValue];
    //userDefaults里的天数
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger usertheDays = [[userDefaults objectForKey:@"theDays"] intValue];
    
    NSLog(@"appVersion %f udtheDays %ld",appVersion,(long)usertheDays);
    //userDefaults里的版本号
    float udAppVersion = [[userDefaults objectForKey:@"appVersion"] floatValue];
    //userDefaults里用户上次的选项
    NSInteger udUserChoose = [[userDefaults objectForKey:@"userOptChoose"] intValue];
    //时间戳的天数
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970];
    NSInteger daySeconds = 24 * 60 * 60;
    NSInteger currentDays = interval / daySeconds;
    NSLog(@"appVersion %@",[userDefaults objectForKey:@"appVersion"]);
    NSLog(@"userOptChoose %@",[userDefaults objectForKey:@"userOptChoose"]);
    NSLog(@"theDays %@",[userDefaults objectForKey:@"theDays"]);
    NSLog(@"udAppVersion %f",udAppVersion);
    //版本升级之后的处理,全部规则清空,开始弹窗
    NSLog(@"theDays%ld udtheDays%ld",(long)currentDays,(long)usertheDays);
    if (udAppVersion && appVersion>udAppVersion) {
        [userDefaults removeObjectForKey:@"theDays"];
        [userDefaults removeObjectForKey:@"appVersion"];
        [userDefaults removeObjectForKey:@"userOptChoose"];
        NSLog(@"版本升级之后的处理,清空存储信息,开始弹窗");
        [self alertUserCommentView];
    }
    
    //1,从来没弹出过的
    //2,用户选择不好用我要提意见，7天之后再弹出
    //3,用户选择残忍的拒绝后，7天内，每过1天会弹一次
    else if (!udUserChoose ||
             (udUserChoose==2 && currentDays-usertheDays>7) ||
             (udUserChoose==3 && currentDays-usertheDays<=7 && currentDays-usertheDays>0))
    {
        [self alertUserCommentView];
    }
    
}
#pragma mark   ------------- 跳槽alerview --------------
-(void)alertUserCommentView{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //当前时间戳的天数
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970];
    NSInteger daySeconds = 24 * 60 * 60;
    NSInteger currentDays = interval / daySeconds;
    //当前版本号
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    float appVersion = [[infoDictionary objectForKey:@"CFBundleShortVersionString"] floatValue];
    //userDefaults里版本号
    float udAppVersion = [[userDefaults objectForKey:@"appVersion"] floatValue];
    //userDefaults里用户选择项目
    NSInteger udUserChoose = [[userDefaults objectForKey:@"userOptChoose"] intValue];
    //userDefaults里用户天数
    //当前版本比userDefaults里版本号高
    if (appVersion>udAppVersion) {
        [userDefaults setObject:[NSString stringWithFormat:@"%f",appVersion] forKey:@"appVersion"];
    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请给个好评吧"message:@"如果您喜欢XXXX，请给我们个好评，也可以直接反馈意见给我们"preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *praise  = [UIAlertAction actionWithTitle:@"给个好评" style:UIAlertActionStyleDefault handler:^(UIAlertAction*action){
        NSLog(@"点击给个好评");
        [userDefaults setObject:@"1" forKey:@"userOptChoose"];
        [userDefaults setObject:[NSString stringWithFormat:@"%ld",currentDays] forKey:@"theDays"];
        [self StoreComment];
    }];
    UIAlertAction *opinion = [UIAlertAction actionWithTitle:@"不好用，我要提意见" style:UIAlertActionStyleDefault handler:^(UIAlertAction*action){
        NSLog(@"不好用，我要提意见");
        [userDefaults setObject:@"2" forKey:@"userOptChoose"];
        [userDefaults setObject:[NSString stringWithFormat:@"%ld",currentDays] forKey:@"theDays"];
        //可以调转到程序内部的反馈意见页面
    }];
    UIAlertAction *reject = [UIAlertAction actionWithTitle:@"残忍的拒绝" style:UIAlertActionStyleDefault handler:^(UIAlertAction*action){
        NSLog(@"残忍的拒绝 udUserChoose%ld",(long)udUserChoose);
            [userDefaults setObject:@"3" forKey:@"userOptChoose"];
            [userDefaults setObject:[NSString stringWithFormat:@"%ld",currentDays] forKey:@"theDays"];
    }];
    [alert addAction:praise];
    [alert addAction:opinion];
    [alert addAction:reject];
    [self presentViewController:alert animated:YES completion:nil];
    
    
}

#pragma mark   ------------- 跳转到appstore评论 --------------

-(void)StoreComment{
    NSString *str = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@",@"888237539"];
    NSURL * url = [NSURL URLWithString:str];
    [[UIApplication sharedApplication] openURL:url];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
