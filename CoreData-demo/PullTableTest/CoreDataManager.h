//
//  CoreDataManager.h
//  PullTableTest
//
//  Created by chenchen on 16/7/19.
//  Copyright © 2016年 chenchen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CoreDataManager : NSObject
@property(strong,nonatomic,readonly) NSManagedObjectModel* managedObjectModel;

@property(strong,nonatomic,readonly) NSManagedObjectContext* managedObjectContext;

@property(strong,nonatomic,readonly) NSPersistentStoreCoordinator* persistentStoreCoordinator;

-(void)addDataModelWithName:(NSString*)modelName and:(void(^)(NSManagedObject *model))modelSet andSetFinish:(void(^)(BOOL isSuccess, NSError *error))finish;
-(NSArray*)queryWithModelName:(NSString*)modelName;
-(void)updateWith:(NSString*)modelName  andUpdate:(BOOL(^)(NSArray<NSManagedObject *>*results))updateOption andFetchCondation:(NSString*)condation,...NS_REQUIRES_NIL_TERMINATION;
-(void)deleteModel:(NSString*)modelName and:(void (^)(BOOL isFinishSuccess))finish andFetchCondation:(NSString*)condation,...;

-(NSString*)testFormat:(NSString*)d,...NS_REQUIRES_NIL_TERMINATION;
- (NSString *)addMoreArguments:(NSString *)firstStr,...NS_REQUIRES_NIL_TERMINATION;

@end
