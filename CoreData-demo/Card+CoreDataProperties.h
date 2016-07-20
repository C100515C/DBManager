//
//  Card+CoreDataProperties.h
//  PullTableTest
//
//  Created by chenchen on 16/7/18.
//  Copyright © 2016年 chenchen. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Card.h"

NS_ASSUME_NONNULL_BEGIN

@interface Card (CoreDataProperties)

@property (nonatomic) int16_t number;
@property (nullable, nonatomic, retain) NSManagedObject *person;

@end

NS_ASSUME_NONNULL_END
