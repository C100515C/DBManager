//
//  LYJDBManager.m
//  IMTest
//
//  Created by chenchen on 16/3/11.
//  Copyright © 2016年 chenchen. All rights reserved.
//

#import "LYJDBManager.h"
#import <sqlite3.h>
#import <objc/runtime.h>

static LYJDBManager *sharedInstance = nil;
//static sqlite3 *database = nil;
//static sqlite3_stmt *statement = nil;
static NSString const *Type = @"type";
static NSString const *Value = @"value";

@interface LYJDBManager (){
    NSString *databasePath;
}
@end

@implementation LYJDBManager
/* db test
 [[LYJDBManager getSharedInstance] createDBWith:@"test" With:@[@"id",@"name",@"age"]];

- (IBAction)btnaction:(UIButton *)sender {
    
    [[LYJDBManager getSharedInstance] updateWithSql:@"update test set name =?, age =? where id=1" andParams:@[@{@"type":@"text",@"value":@"lyj"},@{@"type":@"text",@"value":@"136"}]];
}

- (IBAction)show:(UIButton *)sender {
    MOSLog(@"%@",[[LYJDBManager getSharedInstance] findBySql:@"select name, age from test where id=?" withParams:@[@{@"type":@"int",@"value":@"1"}]]);
}

- (IBAction)save:(UIButton *)sender {
    [[LYJDBManager getSharedInstance] saveData:@"insert into test (id,name,age) values(?,?,?)" withParam:@[@{@"type":@"int",@"value":@"1"},@{@"type":@"text",@"value":@"cc"},@{@"type":@"text",@"value":@"26"}]];
}

- (IBAction)del:(UIButton *)sender {
    
    [[LYJDBManager getSharedInstance] deletBySql:@"delete from test where id=?" withParams:@[@{@"type":@"int",@"value":@"1"}]];
}
*/

+(LYJDBManager*)getSharedInstance{

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (sharedInstance==nil) {
            sharedInstance = [[LYJDBManager alloc]init];
        }
        
    });
    
    return sharedInstance;
}

//const char *sql_stmt ="create table if not exists studentsDetail (regno integer primary key, name text, department text, year text)";
-(BOOL)createDBWith:(NSString *)tableName With:(NSArray *)param{
    
    NSMutableString *sql_str = [[NSMutableString alloc] initWithFormat:@"create table if not exists %@ (sub)",tableName];
    NSMutableString *newstr = [[NSMutableString alloc] init];
    for (int i = 0; i<param.count; i++) {
        if (i==0) {
            NSString *str = [NSString stringWithFormat:@"%@ integer primary key",param[i]];
            [newstr appendString:str];
        }else{
            NSString *str = [NSString stringWithFormat:@", %@ text",param[i]];
            [newstr appendString:str];
        }
    }
    NSRange range = [sql_str rangeOfString:@"sub"];
    [sql_str replaceCharactersInRange:range withString:newstr];
    
    BOOL ok = [LYJDBManager createTableWithSql:sql_str];
    return ok;
}

//    NSString *insertSQL = [NSString stringWithFormat:@"insert into studentsDetail (regno,name, department, year) values(\"%d\",\"%@\", \"%@\", \"%@\")",[registerNumber integerValue],name, department, year];
-(BOOL)saveData:(NSString*)sql withParam:(NSArray*)params{

    NSMutableString *sql_str = [NSMutableString stringWithFormat:@"insert into %@ (sub) values(vsub)",sql];
    NSMutableArray *subs = [NSMutableArray array];
    NSMutableArray *vsubs = [NSMutableArray array];
    for (NSDictionary *dic in params) {
        NSArray *keys = [dic allKeys];
        
        for (NSString *key in keys) {
            if (![key isEqualToString:@"value"] && ![key isEqualToString:@"type"]) {
                [subs addObject:key];
                [vsubs addObject:@"?"];
            }
        }
    }
    NSString *sub = [subs componentsJoinedByString:@","];
    NSString *vsub = [vsubs componentsJoinedByString:@","];
    
    [sql_str replaceCharactersInRange:[sql_str rangeOfString:@"sub"] withString:sub];
    [sql_str replaceCharactersInRange:[sql_str rangeOfString:@"vsub"] withString:vsub];
    
   return  [LYJDBManager insertTableWithSql:sql_str params:params];
}

//NSString *querySQL = [NSString stringWithFormat:@"select name, department, year from studentsDetail where regno=\"%@\"",registerNumber];
//@"select name, age from test where id=?" withParams:@[@{@"type":@"int",@"value":@"1"}]]
-(NSArray*)findBySql:(NSString*)sql andFindKey:(NSString*)key andTabid:(NSString*)tabid withParams:(NSArray*)params{
    
    NSMutableString *sql_str = [NSMutableString stringWithFormat:@"select sub from %@ where %@=%@",sql,key,tabid];
    NSMutableArray *subs = [NSMutableArray array];
 
    for (NSDictionary *dic in params) {
        NSArray *keys = [dic allKeys];
        
        for (NSString *key in keys) {
            if (![key isEqualToString:@"value"] && ![key isEqualToString:@"type"]) {
                [subs addObject:key];
            }
        }
    }
    NSString *sub = [subs componentsJoinedByString:@","];
    
    [sql_str replaceCharactersInRange:[sql_str rangeOfString:@"sub"] withString:sub];
    
    return  [LYJDBManager queryForArrayWithSql:sql_str Params:params];
}

//@"delete from test where id=?" withParams:@[@{@"type":@"int",@"value":@"1"}]];
/*NSMutableArray *subs = [NSMutableArray array];
 
 for (NSDictionary *dic in params) {
 NSArray *keys = [dic allKeys];
 
 for (NSString *key in keys) {
 if (![key isEqualToString:@"value"] && ![key isEqualToString:@"type"]) {
 [subs addObject:key];
 }
 }
 }
 NSString *sub = [subs componentsJoinedByString:@" =?,"];
 
 [sql_str replaceCharactersInRange:[sql_str rangeOfString:@"sub"] withString:sub];*/
-(BOOL)deletBySql:(NSString *)sql andKey:(NSString*)key andTabid:(NSString*)tabid withParams:(NSArray*)params{
    NSMutableString *sql_str = [NSMutableString stringWithFormat:@"delete from %@ where %@=%@",sql,key,tabid];
    
    
   return [LYJDBManager deleteTableWithSql:sql_str  Params:params];
}

//@"update test set name =?, age =? where id=1"

-(BOOL)updateWithSql:(NSString*)sql andUpdateName:(NSString*)keyid and:(NSString*)tabid andParams:(NSArray*)params{
    NSMutableString *sql_str = [NSMutableString stringWithFormat:@"update %@ set sub where %@=%@",sql,keyid,tabid];
    NSMutableArray *subs = [NSMutableArray array];
    
    for (NSDictionary *dic in params) {
        NSArray *keys = [dic allKeys];
        
        for (NSString *key in keys) {
            if (![key isEqualToString:@"value"] && ![key isEqualToString:@"type"] && ![key isEqualToString:keyid]) {
                [subs addObject:key];
            }
        }
    }
    NSString *sub = [subs componentsJoinedByString:@" =?, "];
    sub = [NSString stringWithFormat:@"%@ =?",sub];
    [sql_str replaceCharactersInRange:[sql_str rangeOfString:@"sub"] withString:sub];
    return [LYJDBManager updateTableWithSql:sql_str  Params:params];
}

/****************************model 转换 param*******************************************************/
+(NSArray*)getParamArrWith:(id)model{
    
    Class nowclass = [model class];
    NSMutableArray *propertyNamesArray = [NSMutableArray array];
    unsigned int propertyCount = 0;
    objc_property_t *properties = class_copyPropertyList(nowclass, &propertyCount);
    
    for (unsigned int i = 0; i < propertyCount; ++i) {
        objc_property_t property = properties[i];
        const char * name = property_getName(property);
        
        [propertyNamesArray addObject:[NSString stringWithUTF8String:name]];
    }
    free(properties);
    
    return propertyNamesArray;
}

+(NSArray*)getPropertyAndValueWith:(id)model{
    
    Class nowClass = [model class];
    
    NSMutableArray *propertyNamesAndValues = [NSMutableArray array];
    
    unsigned int propertyCount = 0;
    
    objc_property_t *properties = class_copyPropertyList(nowClass, &propertyCount);
    
    for (int i=0; i<propertyCount; i++) {
        objc_property_t property = properties[i];
        const char *name = property_getName(property);
        const char * attributes = property_getAttributes(property);//获取属性类型
        NSString *propertyAtt = [NSString stringWithUTF8String:attributes];
        NSString *att = [[propertyAtt componentsSeparatedByString:@","] firstObject];
        NSString *type;
        if (att) {
            if ([att isEqualToString:@"Ti"]) {
                type = @"int";
            }else if ([att rangeOfString:@"T@"].location !=NSNotFound && [att rangeOfString:@"NSString"].location !=NSNotFound){
                type = @"text";
            }
        }
        
        NSString *propertyName = [NSString stringWithUTF8String:name];
        id value = [model valueForKey:propertyName];
        
        NSDictionary *dic = @{propertyName:value,Type:type,Value:value};
        [propertyNamesAndValues addObject:dic];
    }
    free(properties);
    
    return propertyNamesAndValues;
}

/****************************sql*****************************************/
//数据库路径
#define sqlite_db_path [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/midea.db"]
//列：字段类型
#define column_type sqlite3_column_type(stmt, i)
//列：名
#define column_name [NSString stringWithUTF8String:sqlite3_column_name(stmt,i)]
//列：text值
#define column_value_text [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, i)]
#define column_value_int  [NSString stringWithFormat:@"%d",sqlite3_column_int(stmt, i)]

+ (BOOL)createTableWithSql:(NSString *)sql
{
    //获取数据库路径
    NSString *path = sqlite_db_path;
    
    //创建数据库的指针对象对象
    sqlite3 *db = nil;
    
    //打开数据库
    int db_open = sqlite3_open([path UTF8String], &db);
    if (db_open != SQLITE_OK) {
        NSLog(@"--------------------------打开失败--------------------------");
        sqlite3_close(db);
        return NO;
    }
    
    //执行创建表的sql语句
    char *error = nil;
    int db_exec = sqlite3_exec(db, [sql UTF8String], NULL, NULL, &error);
    if (db_exec != SQLITE_OK) {
        sqlite3_close(db);
        return NO;
    }
    sqlite3_close(db);
    return YES;
}

+ (BOOL)insertTableWithSql:(NSString *)sql params:(NSArray *)params
{
    sqlite3 *db = nil;
    //创建一个数据句柄
    sqlite3_stmt *stmt = nil;
    //获取数据库路径
    NSString *path = sqlite_db_path;
    
    int db_open = sqlite3_open([path UTF8String], &db);
    if (db_open != SQLITE_OK) {
        NSLog(@"--------------------------打开失败--------------------------");
        sqlite3_close(db);
        return NO;
    }
    
    int db_v2 = sqlite3_prepare_v2(db, [sql UTF8String], -1, &stmt, nil);
    if (db_v2 != SQLITE_OK) {
        NSLog(@"--------------------------编译失败--------------------------");
        sqlite3_close(db);
        return NO;
    }
    
    //3.想占位符中绑定数据
    for (int i = 0; i < params.count; i++) {
        
        NSDictionary *dic = params[i];
//        MOSLog(@"%@",params);
        if ([[dic objectForKey:@"type"] isEqualToString:@"text"]) {
            
            sqlite3_bind_text(stmt, i + 1, [dic[@"value"] UTF8String], -1, NULL);
            
        }else if ([[dic objectForKey:@"type"] isEqualToString:@"int"]) {
            
            sqlite3_bind_int(stmt, i + 1, [dic[@"value"] intValue]);
            
        }
    }
    
    //执行sql语句
    int result = sqlite3_step(stmt);
    if (result == SQLITE_ERROR || result == SQLITE_MISUSE) {
        NSLog(@"--------------------------插入失败--------------------------");
        sqlite3_finalize(stmt);
        sqlite3_close(db);
        return NO;
    }
    
    sqlite3_finalize(stmt);
    sqlite3_close(db);
    return YES;
}

+(NSArray *)queryForArrayWithSql:(NSString *)sql Params:(NSArray *)params
{
    //创建数据库指针对象
    sqlite3 *db = nil;
    //创建一个数据句柄
    sqlite3_stmt *stmt = nil;
    //数据库路径
    NSString *path = sqlite_db_path;
    
    int db_open = sqlite3_open([path UTF8String], &db);
    if (db_open != SQLITE_OK) {
        NSLog(@"--------------------------打开失败--------------------------");
        sqlite3_close(db);
        return nil;
    }
    
    //编译sql语句
    int db_v2 = sqlite3_prepare_v2(db, [sql UTF8String], -1, &stmt, nil);
    if (db_v2) {
        NSLog(@"--------------------------编译失败--------------------------");
        sqlite3_close(db);
        return nil;
    }
    
    //占位符绑定参数
    //3.想占位符中绑定数据
    if (params != nil) {
        for (int i = 0; i < params.count; i++) {
            
            NSDictionary *dic = params[i];
            
            if ([[dic objectForKey:@"type"] isEqualToString:@"text"]) {
                
                sqlite3_bind_text(stmt, i + 1, [dic[@"value"] UTF8String], -1, NULL);
                
            }else if ([[dic objectForKey:@"type"] isEqualToString:@"int"]) {
                
                sqlite3_bind_int(stmt, i + 1, [dic[@"value"] intValue]);
                
            }
        }
    }
    
    //执行查询
    int db_step = sqlite3_step(stmt);
    NSMutableArray *mArray = [NSMutableArray array];
    
    while (db_step == SQLITE_ROW) {
        //获取查询了多少列
        int count = sqlite3_column_count(stmt);
        
        //创建字典
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        
        for (int i = 0; i<count; i++) {
            
            //如果是text类型
            if (column_type == SQLITE_TEXT) {
                [dic setValue:column_value_text forKeyPath:column_name];
            }
            if (column_type == SQLITE_INTEGER) {
                [NSString stringWithFormat:@"%d",sqlite3_column_int(stmt, i)];
                [dic setValue:column_value_int forKeyPath:column_name];
            }
        }
        //字典添加到数组中
        [mArray addObject:dic];
        
        db_step = sqlite3_step(stmt);
    }
    
    return mArray;
}


+(BOOL)updateTableWithSql:(NSString *)sql Params:(NSArray *)params
{
    sqlite3 *db = nil;
    //创建一个数据句柄
    sqlite3_stmt *stmt = nil;
    //获取数据库路径
    NSString *path = sqlite_db_path;
    
    int db_open = sqlite3_open([path UTF8String], &db);
    if (db_open != SQLITE_OK) {
        NSLog(@"--------------------------打开失败--------------------------");
        sqlite3_close(db);
        return NO;
    }
    
    int db_v2 = sqlite3_prepare_v2(db, [sql UTF8String], -1, &stmt, nil);
    if (db_v2 != SQLITE_OK) {
        NSLog(@"--------------------------编译失败--------------------------");
        sqlite3_close(db);
        return NO;
    }
    
    //3.想占位符中绑定数据
    for (int i = 0; i < params.count; i++) {
        
        NSDictionary *dic = params[i];
        
        if ([[dic objectForKey:@"type"] isEqualToString:@"text"]) {
            
            sqlite3_bind_text(stmt, i + 1, [dic[@"value"] UTF8String], -1, NULL);
            
        }else if ([[dic objectForKey:@"type"] isEqualToString:@"int"]) {
            
            sqlite3_bind_int(stmt, i + 1, [dic[@"value"] intValue]);
            
        }
    }
    
    //执行sql语句
    int result = sqlite3_step(stmt);
    if (result == SQLITE_ERROR || result == SQLITE_MISUSE) {
        NSLog(@"--------------------------更新失败--------------------------");
        sqlite3_finalize(stmt);
        sqlite3_close(db);
        return NO;
    }
    
    sqlite3_finalize(stmt);
    sqlite3_close(db);
    return YES;
}


+(BOOL)deleteTableWithSql:(NSString *)sql Params:(NSArray *)params
{
    sqlite3 *db = nil;
    //创建一个数据句柄
    sqlite3_stmt *stmt = nil;
    //获取数据库路径
    NSString *path = sqlite_db_path;
    
    int db_open = sqlite3_open([path UTF8String], &db);
    if (db_open != SQLITE_OK) {
        NSLog(@"--------------------------打开失败--------------------------");
        sqlite3_close(db);
        return NO;
    }
    
    int db_v2 = sqlite3_prepare_v2(db, [sql UTF8String], -1, &stmt, nil);
    if (db_v2 != SQLITE_OK) {
        NSLog(@"--------------------------编译失败--------------------------");
        sqlite3_close(db);
        return NO;
    }
    
    //3.想占位符中绑定数据
    for (int i = 0; i < params.count; i++) {
        
        NSDictionary *dic = params[i];
        
        if ([[dic objectForKey:@"type"] isEqualToString:@"text"]) {
            
            sqlite3_bind_text(stmt, i + 1, [dic[@"value"] UTF8String], -1, NULL);
            
        }else if ([[dic objectForKey:@"type"] isEqualToString:@"int"]) {
            
            sqlite3_bind_int(stmt, i + 1, [dic[@"value"] intValue]);
            
        }
    }
    
    //执行sql语句
    int result = sqlite3_step(stmt);
    if (result == SQLITE_ERROR || result == SQLITE_MISUSE) {
        NSLog(@"--------------------------删除失败--------------------------");
        sqlite3_finalize(stmt);
        sqlite3_close(db);
        return NO;
    }
    
    sqlite3_finalize(stmt);
    sqlite3_close(db);
    return YES;
}

+(NSArray *)getTextParamsByArray:(NSArray *)valueArray
{
    NSMutableArray *params = [NSMutableArray array];
    //将所有字段设置成text类型
    for (int i =0 ;i<valueArray.count;i++) {
        NSDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:(valueArray[i] == nil)?@"":valueArray[i] forKey:@"value"];
        [dic setValue:@"text" forKey:@"type"];
        [params addObject:dic];
    }
    return params;
}

+(NSArray *)getTextParamsByModel:(id)model{
    NSMutableArray *params = [NSMutableArray array];
    
    
    
    return params;
}

@end

@implementation DBModel


@end
