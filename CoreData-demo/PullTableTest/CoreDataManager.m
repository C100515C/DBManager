//
//  CoreDataManager.m
//  PullTableTest
//
//  Created by chenchen on 16/7/19.
//  Copyright © 2016年 chenchen. All rights reserved.
//

#import "CoreDataManager.h"

@implementation CoreDataManager
@synthesize managedObjectModel=_managedObjectModel;
@synthesize managedObjectContext=_managedObjectContext;
@synthesize persistentStoreCoordinator=_persistentStoreCoordinator;

//托管对象
-(NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel!=nil) {
        return _managedObjectModel;
    }
    NSURL* modelURL=[[NSBundle mainBundle] URLForResource:@"MyDataModel" withExtension:@"momd"];
    _managedObjectModel=[[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    //    _managedObjectModel=[NSManagedObjectModel mergedModelFromBundles:nil];
    return _managedObjectModel;
}
//托管对象上下文
-(NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext!=nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator* coordinator=[self persistentStoreCoordinator];
    if (coordinator!=nil) {
        _managedObjectContext=[[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}
//持久化存储协调器
-(NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator!=nil) {
        return _persistentStoreCoordinator;
    }
    //    NSURL* storeURL=[[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"CoreaDataExample.CDBStore"];
    //    NSFileManager* fileManager=[NSFileManager defaultManager];
    //    if(![fileManager fileExistsAtPath:[storeURL path]])
    //    {
    //        NSURL* defaultStoreURL=[[NSBundle mainBundle] URLForResource:@"CoreDataExample" withExtension:@"CDBStore"];
    //        if (defaultStoreURL) {
    //            [fileManager copyItemAtURL:defaultStoreURL toURL:storeURL error:NULL];
    //        }
    //    }
    NSString* docs=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSURL* storeURL=[NSURL fileURLWithPath:[docs stringByAppendingPathComponent:@"CoreDataExample.sqlite"]];
    NSLog(@"path is %@",storeURL);
    NSError* error=nil;
    _persistentStoreCoordinator=[[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        NSLog(@"Error: %@,%@",error,[error userInfo]);
    }
    return _persistentStoreCoordinator;
}

#pragma mark - 增删改查
-(void)addDataModelWithName:(NSString *)modelName and:(void (^)(NSManagedObject *model))modelSet andSetFinish:(void (^)(BOOL isSuccess, NSError *error))finish{
    NSManagedObject *model = [NSEntityDescription insertNewObjectForEntityForName:modelName inManagedObjectContext:self.managedObjectContext];
    
    if (modelSet) {
        modelSet(model);
        
        NSError *error;
        BOOL isSaveSuccess = [self.managedObjectContext save:&error];
        
        if (finish) {
            finish(isSaveSuccess,error);
        }
    }
    
}

-(NSArray*)queryWithModelName:(NSString*)modelName{
    NSFetchRequest* request=[[NSFetchRequest alloc] init];
    NSEntityDescription* user=[NSEntityDescription entityForName:modelName inManagedObjectContext:self.managedObjectContext];
    [request setEntity:user];
    //    NSSortDescriptor* sortDescriptor=[[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    //    NSArray* sortDescriptions=[[NSArray alloc] initWithObjects:sortDescriptor, nil];
    //    [request setSortDescriptors:sortDescriptions];
    //    [sortDescriptions release];
    //    [sortDescriptor release];
    NSError* error=nil;
    NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (mutableFetchResult==nil) {
        NSLog(@"Error:%@",error);
    }
    NSLog(@"The count of entry: %lu",(unsigned long)[mutableFetchResult count]);
    
    return mutableFetchResult;
}

-(void)updateWith:(NSString*)modelName  andUpdate:(BOOL(^)(NSArray<NSManagedObject *>*results))updateOption andFetchCondation:(NSString*)condation,...{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *des = [NSEntityDescription entityForName:modelName inManagedObjectContext:self.managedObjectContext];
    [request setEntity:des];
    
    va_list cd; // C语言的字符指针, 指针根据offset来指向需要的参数,从而读取参数
    va_start(cd, condation); // 设置指针的起始地址为方法的...参数的第一个参数
    NSPredicate *predicate = [NSPredicate predicateWithFormat:condation arguments:cd];//condation, va_arg(cd, NSString *)
    va_end(cd);

    [request setPredicate:predicate];
    NSError *error;
    NSArray *fetchResult = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (fetchResult==nil) {
        NSLog(@"Error:%@",error);
    }
    
    if (updateOption) {
       BOOL isfinish = updateOption(fetchResult);
        if (isfinish) {
            [self.managedObjectContext save:&error];
        }
    }
}

-(void)deleteModel:(NSString*)modelName and:(void (^)(BOOL isFinishSuccess))finish andFetchCondation:(NSString*)condation,...{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *des = [NSEntityDescription entityForName:modelName inManagedObjectContext:self.managedObjectContext];
    [request setEntity:des];
    
    va_list cd; // C语言的字符指针, 指针根据offset来指向需要的参数,从而读取参数
    va_start(cd, condation); // 设置指针的起始地址为方法的...参数的第一个参数

    NSPredicate *predicate = [NSPredicate predicateWithFormat:condation,va_arg(cd, NSString *)];
    [request setPredicate:predicate];
    NSError *error;
    NSArray *results = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    if (results==nil) {
        NSLog(@"Error:%@",error);
    }
    
    for (NSManagedObject *obj in results) {
        [self.managedObjectContext deleteObject:obj];
    }
    BOOL isfinish = [self.managedObjectContext save:&error];
    if (finish) {
        finish(isfinish);
    }
    va_end(cd);
}

-(NSString*)testFormat:(NSString *)d, ...{
    va_list t;
    va_start(t, d);
    
    NSMutableArray *arr = [NSMutableArray array];
    for (NSString *str = d; str != nil; str = va_arg(t,NSString*)) {
        [arr addObject:str];
    }
    
    va_end(t);

    
    NSString *rt = [arr componentsJoinedByString:@","];
    return rt;
}

- (NSString *)addMoreArguments:(NSString *)firstStr,...
{
    va_list args;
    va_start(args, firstStr); // scan for arguments after firstObject.
    
    // get rest of the objects until nil is found
    NSMutableString *allStr = [[NSMutableString alloc] initWithCapacity:16] ;
    for (NSString *str = firstStr; str != nil; str = va_arg(args,NSString*)) {
        [allStr appendFormat:@"* %@ ",str];
    }
    
    va_end(args);
    return allStr;
}

@end
