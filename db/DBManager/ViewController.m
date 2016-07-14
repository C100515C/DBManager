//
//  ViewController.m
//  DBManager
//
//  Created by chenchen on 16/4/21.
//  Copyright © 2016年 chenchen. All rights reserved.
//

#import "ViewController.h"
#import "LYJDBManager.h"

@interface ViewController ()
- (IBAction)create:(UIButton *)sender;
- (IBAction)save:(UIButton *)sender;
- (IBAction)find:(UIButton *)sender;
- (IBAction)update:(UIButton *)sender;
- (IBAction)delete:(UIButton *)sender;

@property (nonatomic,strong) DBModel *model;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    DBModel *md = [[DBModel alloc] init];
    md.tb_id = 1;
    md.name = @"cc";
    md.age = @"25";
    md.gender = @"女";
    
    self.model = md;
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)create:(UIButton *)sender {
    [[LYJDBManager getSharedInstance] createDBWith:@"myInfor" With:[LYJDBManager getParamArrWith:self.model]];
    
}

- (IBAction)save:(UIButton *)sender {
    [[LYJDBManager getSharedInstance] saveData:@"myInfor" withParam:[LYJDBManager getPropertyAndValueWith:self.model]];

}

- (IBAction)find:(UIButton *)sender {
   NSLog(@"%@",[[LYJDBManager getSharedInstance] findBySql:@"myInfor" andFindKey:@"tb_id" andTabid:@"1" withParams:[LYJDBManager getPropertyAndValueWith:self.model]]);
}

- (IBAction)update:(UIButton *)sender {
    self.model.name = @"ddgd";
    [[LYJDBManager getSharedInstance] updateWithSql:@"myInfor" andUpdateName:@"tb_id" and:@"1" andParams:[LYJDBManager getPropertyAndValueWith:self.model]];
}

- (IBAction)delete:(UIButton *)sender {
    [[LYJDBManager getSharedInstance] deletBySql:@"myInfor" andKey:@"tb_id" andTabid:@"1" withParams:[LYJDBManager getPropertyAndValueWith:self.model]];
}
@end
