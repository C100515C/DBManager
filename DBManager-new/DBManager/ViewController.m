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
    DBModel *md1 = [[DBModel alloc] init];
    md1.tb_id = 11;
    md1.name = @"ccc";
    md1.age = @"256";
    md1.gender = @"男";
    md1.arr = @[@"cc",@"dc",@"sd",@"dg"];
    md1.dic = @{@"l":@"vddv",@"edde":@"ssdvv",@"ddgl":@"vervv",@"lrcc":@"ytvv"};
    
    DBModel *md = [[DBModel alloc] init];
    md.tb_id = 1;
    md.name = @"cc";
    md.age = @"25";
//    md.gender = @"女";
    md.wode = md1;
    md.arr = @[@"dd",@"d",@"d",@"d"];
    md.dic = @{@"ll":@"vv",@"ee":@"vv",@"dl":@"vvv",@"lcc":@"vv"};
    md.iswode = YES;
    md.tt = 2;
    self.model = md;
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)create:(UIButton *)sender {
    [[LYJDBManager getSharedInstance] createDBWith:@"myInfor" With:[LYJDBManager getParamArrWith:self.model]];
//    NSLog(@"%@",[LYJDBManager getPropertyAndValueWith:self.model]);
    
}

- (IBAction)save:(UIButton *)sender {
    [[LYJDBManager getSharedInstance] saveData:@"myInfor" withParam:[LYJDBManager getPropertyAndValueWith:self.model]];

}

- (IBAction)find:(UIButton *)sender {
    DBModel *model = [[DBModel alloc] init];
//   NSLog(@"%@",[[LYJDBManager getSharedInstance] findBySql:@"myInfor" andFindKey:@"tb_id" andTabid:@"1" withParams:[LYJDBManager getPropertyAndValueWith:self.model]]);
    model = [LYJDBManager getModel:model findBySql:@"myInfor" andFindKey:@"tb_id" andTabid:@"1" withParams:[LYJDBManager getPropertyAndValueWith:model]];
    NSLog(@"%@=%@=%@=%ld=%d=%@=%@=%@=%d",model.name,model.age,model.gender,(long)model.tt,model.iswode,model.arr,model.dic,model.wode.wode.arr,model.tb_id);
}

- (IBAction)update:(UIButton *)sender {
    self.model.name = @"ddgd";
    self.model.gender = @"男";
    self.model.age = @"300";
    [[LYJDBManager getSharedInstance] updateWithSql:@"myInfor" andUpdateName:@"tb_id" and:@"1" andParams:[LYJDBManager getPropertyAndValueWith:self.model]];
}

- (IBAction)delete:(UIButton *)sender {
    [[LYJDBManager getSharedInstance] deletBySql:@"myInfor" andKey:@"tb_id" andTabid:@"1" withParams:[LYJDBManager getPropertyAndValueWith:self.model]];
}
@end
