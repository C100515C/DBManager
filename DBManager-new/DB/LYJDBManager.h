//
//  LYJDBManager.h
//  IMTest
//
//  Created by chenchen on 16/3/11.
//  Copyright © 2016年 chenchen. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  模型属性添加完，属性顺序最好别随意改变，如有修改需要重新创建表格
 */
@interface DBModel : NSObject
@property (nonatomic,assign) int tb_id;
@property (nonatomic,assign) BOOL iswode;
@property (nonatomic,assign) NSInteger tt;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *age;
@property (nonatomic,copy) NSString *gender;
@property (nonatomic,copy) NSArray *arr;
@property (nonatomic,copy) NSDictionary *dic;
@property (nonatomic,strong) DBModel *wode;

@end

@interface LYJDBManager : NSObject
/**
 *  从数据裤读取数据并转成相应数据model
 *
 *  @param model  数据model
 *  @param sql    数据库 表名
 *  @param key    查找的 key
 *  @param tabid  查找的key 值
 *  @param params model属性参数
 *
 *  @return 获取数据后的model
 */
+(id)getModel:(id)model findBySql:(NSString*)sql andFindKey:(NSString*)key andTabid:(NSString*)tabid withParams:(NSArray*)params;
/**
 *  单利
 *
 *  @return 单利对象
 */
+(LYJDBManager*)getSharedInstance;
/**
 *  创建表
 *
 *  @param tableName 表名字
 *  @param param     表字段
 *
 *  @return yes 成功 no 失败
 */
-(BOOL)createDBWith:(NSString*)tableName With:(NSArray*)param;
/**
 *  保存数据
 *
 *  @param sql    表名字
 *  @param params 从model中获取的属性和value（与表中对应）
 *
 *  @return yes 成功 no 失败
 */
-(BOOL) saveData:(NSString*)sql withParam:(NSArray*)params;
/**
 *  查找数据
 *
 *  @param sql    表名字
 *  @param key    查找用的字段名
 *  @param tabid  查找字段 值
 *  @param params  从model中获取的属性和value（与表中对应）
 *
 *  @return yes 成功 no 失败
 */
-(NSArray*)findBySql:(NSString*)sql andFindKey:(NSString*)key andTabid:(NSString*)tabid withParams:(NSArray*)params;
/**
 *  删除数据
 *
 *  @param sql    表名字
 *  @param key    删除用的字段名
 *  @param tabid  删除字段 值
 *  @param params 从model中获取的属性和value（与表中对应）
 *
 *  @return yes 成功 no 失败
 */

-(BOOL)deletBySql:(NSString *)sql andKey:(NSString*)key andTabid:(NSString*)tabid withParams:(NSArray*)params;
/**
 *  更新数据
 *
 *  @param sql    表名字
 *  @param keyid  更新用的字段名
 *  @param tabid  更新 字段值
 *  @param params 从model中获取的属性和value（与表中对应）
 *
 *  @return yes 成功 no 失败
 */
-(BOOL)updateWithSql:(NSString*)sql andUpdateName:(NSString*)keyid and:(NSString*)tabid andParams:(NSArray*)params;

/***************************model 转换 param****************************/
/**
 *  获取model属性名字数组
 *
 *  @param model 数据模型
 *
 *  @return 属性数组
 */
+(NSArray*)getParamArrWith:(id)model;
/**
 *  获取model属性名字 value 类型 数组
 *
 *  @param model 数据模型
 *
 *  @return 属性名字，value，类型，数组
 */
+(NSArray*)getPropertyAndValueWith:(id)model;
/***************************sql*************************/
/*
 创建表
 */
+ (BOOL)createTableWithSql:(NSString *)sql;

/*
 插入数据
 */
+ (BOOL)insertTableWithSql:(NSString *)sql params:(NSArray *)params;

/*
 查询数据(数组)
 */
+(NSArray *)queryForArrayWithSql:(NSString *)sql Params:(NSArray *)params;

/*
 更新数据
 */
+(BOOL)updateTableWithSql:(NSString *)sql Params:(NSArray *)params;


/*
 删除数据
 */
+(BOOL)deleteTableWithSql:(NSString *)sql Params:(NSArray *)params;

/*
 获取包装后的Text类型参数
 */
+(NSArray *)getTextParamsByArray:(NSArray *)valueArray;

@end
