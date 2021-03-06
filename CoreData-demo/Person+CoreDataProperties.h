//
//  Person+CoreDataProperties.h
//  PullTableTest
//
//  Created by chenchen on 16/7/18.
//  Copyright © 2016年 chenchen. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Person.h"

NS_ASSUME_NONNULL_BEGIN

@interface Person (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nonatomic) int16_t age;
@property (nullable, nonatomic, retain) Card *card;

@end

NS_ASSUME_NONNULL_END
