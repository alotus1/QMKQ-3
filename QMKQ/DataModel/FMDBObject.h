//
//  MFDBObject.h
//  FAView-master
//
//  Created by shangjin on 15/8/6.
//  Copyright (c) 2015年 skinner. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, TableState) {
    TableStateCreateSuccess,//创建成功
    TableStateExist,//已经存在
    TableStateCreateFailed,//创建失败
    TableStateInexistence,//不存在
};

typedef void(^CreateTableResult)(TableState state);

typedef NS_ENUM(NSUInteger, HandleState) {
    HandleStateSuccess = true,//操作成功
    HandleStateFailed = false,//操作失败
};

typedef void(^HandleResult)(HandleState state);

typedef void(^SelectHandleResult)(HandleState state, NSArray* results);

#ifndef FMDBProperty
#define FMDBProperty

#endif

#pragma mark    ----注意，在这里定义数据库名称和路径
#define DBPath [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"test.db"]
//输出信息，包括错误崩溃等
#define DBTraceExecution NO
/**
 * @abstract 作为一个本地化功能的父类.
 * @brief 需要使用本类请继承. 继承此类的数据模型不能出现自定义类型的属性
 */
@interface FMDBObject : NSObject


#pragma mark    属性<-->字典 相互转换

+ (NSDictionary*)getPropertyListWithPrimaryKey:(NSArray *)primaryKey;
+ (id)setPropertyFromDataList:(NSDictionary*)dataList;

#pragma mark    创建表
/**
 * @abstract 使用本类创建一个表
 * @discussion 把类中所有添加
 * @param name 表名
 * @param result 返回表的状态
 */
+ (void)createTableWithName:(NSString*)name andPropertyList:(NSDictionary*)propertyAndType result:(CreateTableResult)result;

/**
 *  @abstract 查找一个名字叫“name”的表
 *  @param name   表名
 *  @param result 表状态
 */
+ (void)findTableWithName:(NSString*)name result:(CreateTableResult)result;

#pragma mark    清空/删除表

/**
 * 通过表名清除所有数据
 * @param name   表名
 * @param result 结果block
 */
+ (void)clearTableWithName:(NSString*)name result:(HandleResult)result;

/**
 * 通过表名删除某张表
 * @param name   表名
 * @param result 结果
 */
+ (void)deleteTableWithName:(NSString*)name result:(HandleResult)result;

#pragma mark    数据操作    ---增

/**
 * 添加到某张表
 * @param name   表名
 * @param result 结果
 */
- (void)addToTableWithTableName:(NSString*)name result:(HandleResult)result;

#pragma mark    数据操作    ---删

/**
 * 从某个表中删除:某属性为value的数据
 * @discussion 只有当属性类型可以为一个类的时候可以删除
 * @param name     表名
 * @param property 属性名
 * @param value    值
 */
+ (void)deleteDataFromTableWithTableName:(NSString*)name property:(NSString*)property value:(id)value result:(HandleResult)result;

/**
 * 使用sql从某张表中删除某个数据
 * @param name      表名
 * @param sqlString sql语句一般为:(where %@ = '%@'...)某条件
 */
+ (void)deleteDataFromTableWithTableName:(NSString *)name sqlString:(NSString*)sqlString result:(HandleResult)result;

/**
 * 从默认表中删除
 */
- (void)deleteFromTableName:(NSString*)name Result:(HandleResult)result;

#pragma mark    数据操作    ---改

/**
 * 修改本实例中的某属性为value
 * @param property 属性名,如果已经设置了主键，建议property为主键名;如果有主键，则在主键是唯一值的前提下修改，如果没有主见，则修改所有匹配值
 * @param value    新值
 */
- (void)updateDataForTableName:(NSString*)name whereProperty:(NSString*)property equalToValue:(id)value result:(HandleResult)result;

/**
 * 更新所有,调用此接口后，会直接覆盖之前数据
 * @discussion 如果设置了主键，只会更新主键相同的
 * @param sqlString sql语句，一般为(where %@ = '%@'...)某条件，如果不设默认查找主键，如果没有主键则修改全部
 */
- (void)updateDataForTableName:(NSString*)name sqlString:(NSString*)sqlString result:(HandleResult)result;

#pragma mark    数据操作    ---查

/**
 * 查找某个表中的属性为value的数据
 * @param name     表名
 * @param property 属性名
 * @param value    值
 * @param result   结果
 */
+ (void)selectTableWithName:(NSString*)name property:(NSString*)property value:(id)value result:(SelectHandleResult)result;

/**
 * 查找某个表中的属性为value的数据
 * @param name      表名
 * @param sqlString sql语句，一般为(where %@ = '%@'...)某条件
 * @param result    结果
 */
+ (void)selectTableWithName:(NSString*)name sqlString:(NSString*)sqlString result:(SelectHandleResult)result;

/**
 * 查询表中的所有列
 *
 * @param name   表名
 * @param result 结果
 */
+ (void)getColumnsCountWithTableName:(NSString*)name result:(void(^)(NSInteger count, NSArray*columnArray))result;


@end
