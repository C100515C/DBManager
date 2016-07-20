//
//  ViewController.m
//  PullTableTest
//
//  Created by chenchen on 16/7/6.
//  Copyright © 2016年 chenchen. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "Person.h"
#import "Card.h"
#import "CoreDataManager.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITableView *mytable;
@property(nonatomic,strong)AppDelegate* myAppDelegate;
@property (nonatomic,strong) CoreDataManager *manager;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    CircleView *c = [[CircleView alloc] initWithFrame:CGRectMake(0, 0,self.view.frame.size.height, 10)];
//    c.backgroundColor = [UIColor redColor];
//    [self.mytable addSubview:c];
//    c.observing = YES;
   
    _myAppDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    _manager = [[CoreDataManager alloc]init];
    
//    [_manager addDataModelWithName:@"Person" and:^(NSManagedObject *model) {
//        Person *p = (Person*)model;
//        [p setName:@"lyj"];
//        [p setAge:29];
//    } andSetFinish:^(BOOL isSuccess, NSError *error) {
//        NSLog(@"is success:%d,error:%@",isSuccess,error);
//    }];
    
//     NSArray *arr = [_manager queryWithModelName:@"Person"];
//    for (Person *p in arr) {
//        NSLog(@"%@,%hd",p.name,p.age);
//    }
    NSLog(@"%@",[_manager addMoreArguments:@"wode = %@,dgdg=%@,dgd=%@",@"C",@"V",@"B", nil]);
    NSLog(@"%@",[_manager testFormat:@"wode = %@,dgdg=%@,dgd=%@",@"C",@"V",@"B",nil]);
    [_manager updateWith:@"Person" andUpdate:^BOOL(NSArray<NSManagedObject *> *results) {
        for (Person *p in results) {
            [p setName:@"Chen"];
        }
        return YES;
    } andFetchCondation:@"name==%@",@"cc",nil];
    
//    [_manager deleteModel:@"Person" and:^(BOOL isFinishSuccess) {
//        if (isFinishSuccess) {
//            NSLog(@"delete");
//        }
//    } andFetchCondation:@"name==%@",@"Chen"];
    
//    [self addIntoDataSource];
//    [self query];
//    [self update];
//    [self del];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//插入数据
- (void)addIntoDataSource{
    Person* p=(Person *)[NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:self.myAppDelegate.managedObjectContext];
    [p setName:@"cc"];
    [p setAge:25];
    NSError* error;
    BOOL isSaveSuccess=[_myAppDelegate.managedObjectContext save:&error];
    if (!isSaveSuccess) {
        NSLog(@"Error:%@",error);
    }else{
        NSLog(@"Save successful!");
    }
    
}
//查询
- (void)query{
    NSFetchRequest* request=[[NSFetchRequest alloc] init];
    NSEntityDescription* user=[NSEntityDescription entityForName:@"Person" inManagedObjectContext:_manager.managedObjectContext];
    [request setEntity:user];
    //    NSSortDescriptor* sortDescriptor=[[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    //    NSArray* sortDescriptions=[[NSArray alloc] initWithObjects:sortDescriptor, nil];
    //    [request setSortDescriptors:sortDescriptions];
    //    [sortDescriptions release];
    //    [sortDescriptor release];
    NSError* error=nil;
    NSMutableArray* mutableFetchResult=[[_manager.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (mutableFetchResult==nil) {
        NSLog(@"Error:%@",error);
    }
    NSLog(@"The count of entry: %lu",(unsigned long)[mutableFetchResult count]);
    for (Person* p in mutableFetchResult) {
        NSLog(@"name:%@----age:%hd----card.num:%hd",p.name,p.age,p.card.number);
    }
}
//更新
- (void)update{
    NSFetchRequest* request=[[NSFetchRequest alloc] init];
    NSEntityDescription* user=[NSEntityDescription entityForName:@"Person" inManagedObjectContext:_manager.managedObjectContext];
    [request setEntity:user];
    Card *c = [NSEntityDescription insertNewObjectForEntityForName:@"Card" inManagedObjectContext:_manager.managedObjectContext];
    [c setNumber:3243];

    //查询条件
    NSPredicate* predicate=[NSPredicate predicateWithFormat:@"name==%@",@"cc"];
    [request setPredicate:predicate];
    NSError* error=nil;
    NSMutableArray* mutableFetchResult=[[_manager.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (mutableFetchResult==nil) {
        NSLog(@"Error:%@",error);
    }
    NSLog(@"The count of entry: %lu",(unsigned long)[mutableFetchResult count]);
    //更新age后要进行保存，否则没更新
    
    for (Person* p in mutableFetchResult) {
        [p setAge:53];
        [p setCard:c];
    }
    [_manager.managedObjectContext save:&error];
}
//删除
- (void)del{
    NSFetchRequest* request=[[NSFetchRequest alloc] init];
    NSEntityDescription* user=[NSEntityDescription entityForName:@"Person" inManagedObjectContext:_manager.managedObjectContext];
    [request setEntity:user];
    NSPredicate* predicate=[NSPredicate predicateWithFormat:@"name==%@",@"cc"];
    [request setPredicate:predicate];
    NSError* error=nil;
    NSMutableArray* mutableFetchResult=[[_manager.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (mutableFetchResult==nil) {
        NSLog(@"Error:%@",error);
    }
    NSLog(@"The count of entry: %lu",(unsigned long)[mutableFetchResult count]);
    for (Person* p in mutableFetchResult) {
        [_manager.managedObjectContext deleteObject:p];
    }
    
    if ([_manager.managedObjectContext save:&error]) {
        NSLog(@"Error:%@,%@",error,[error userInfo]);
    }  
}


@end
