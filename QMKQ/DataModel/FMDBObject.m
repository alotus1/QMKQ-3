//
//  MFDBObject.m
//  FAView-master
//
//  Created by shangjin on 15/8/6.
//  Copyright (c) 2015年 skinner. All rights reserved.
//

#import "FMDBObject.h"
#import <FMDB.h>
#import <objc/runtime.h>


@interface FMDBObject ()

@end

@implementation  FMDBObject


+ (BOOL)isClassFromFoundation:(Class)c
{
    if (c == [NSObject class] ) return YES;
    
    __block BOOL result = NO;
    [[NSSet setWithObjects:
      [NSURL class],
      [NSDate class],
      [NSValue class],
      [NSData class],
      [NSArray class],
      [NSDictionary class],
      [NSString class],
      [NSAttributedString class], nil]
     enumerateObjectsUsingBlock:^(Class foundationClass, BOOL *stop) {
        if (c == foundationClass || [c isSubclassOfClass:foundationClass]) {
            result = YES;
            *stop = YES;
        }
    }];
    return result;
}

+ (void)enumerateClasses:(void(^)(Class c, BOOL *stop))enumeration
{
    // 1.没有block就直接返回
    if (enumeration == nil) return;
    
    // 2.停止遍历的标记
    BOOL stop = NO;
    
    // 3.当前正在遍历的类
    Class c = [self class];
    
    // 4.开始遍历每一个类
    while (c && !stop) {
        // 4.1.执行操作
        enumeration(c, &stop);
        
        // 4.2.获得父类
        c = class_getSuperclass(c);
        
        if ([[self class] isClassFromFoundation:c]) break;
    }
}


#pragma mark - 公共方法
+ (NSMutableArray *)properties
{
    static const char MJCachedPropertiesKey = '\0';
    
    NSMutableArray *cachedProperties = objc_getAssociatedObject(self, &MJCachedPropertiesKey);
    //***
    if (cachedProperties == nil) {
        cachedProperties = [NSMutableArray array];
        
        /**遍历这个类的父类*/
        [[self class] enumerateClasses:^(__unsafe_unretained Class c, BOOL *stop) {
            // 1.获得所有的成员变量
            unsigned int outCount = 0;
            /**
             class_copyIvarList 成员变量，提示有很多第三方框架会使用 Ivar，能够获得更多的信息
             但是：在 swift 中，由于语法结构的变化，使用 Ivar 非常不稳定，经常会崩溃！
             class_copyPropertyList 属性
             class_copyMethodList 方法
             class_copyProtocolList 协议
             */
            
            objc_property_t * properties = class_copyPropertyList(c, &outCount);
            
            for (unsigned int i = 0; i < outCount; i++) {
                objc_property_t property = properties[i];
                [cachedProperties addObject:@{@"name":[NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding],//名称
                                              @"type":[NSString stringWithCString:property_getAttributes(property) encoding:NSUTF8StringEncoding]//类型
                                              }];
            }
            
            free(properties);
            
            /*
            Ivar *vars = class_copyIvarList(c, &outCount);
            
            // 2.遍历每一个成员变量
            for (unsigned int i = 0; i<outCount; i++) {
                Ivar thisIvar = vars[i];
                [cachedProperties addObject:@{
                                              @"name":[[NSString stringWithCString:ivar_getName(thisIvar) encoding:NSUTF8StringEncoding] substringFromIndex:1]//获取成员变量的名字
                                              ,@"type":[NSString stringWithUTF8String:ivar_getTypeEncoding(thisIvar)]//获取成员变量的数据类型
                                              }];
            }
             
            
            // 3.释放内存
            free(vars);
             */
        }];
        //*** 在此时设置当前这个类为关联对象，这样下次就不会重复获取类的相关属性。
        objc_setAssociatedObject(self, &MJCachedPropertiesKey, cachedProperties, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        //***
    }
    
    return cachedProperties;
}

+ (void)enumerateProperties:(void(^)(NSDictionary *property, BOOL *stop))enumeration
{
    // 获得成员变量
    NSArray *cachedProperties = [self properties];
    
    // 遍历成员变量
    BOOL stop = NO;
    for (NSDictionary *property in cachedProperties) {
        enumeration(property, &stop);
        if (stop) break;
    }
}

+ (NSString*)typeString:(NSString*)type
{
    NSString*str=nil;
    /*** 
    // Ivar 获得的属性
    if (type.length > 3 && [type hasPrefix:@"@\""]) {
        // 去掉@"和"，截取中间的类型名称
        type = [type substringWithRange:NSMakeRange(2, type.length - 3)];
    }
     */
    // objc_property_t 获得的属性
    if (type.length >3 && [type rangeOfString:@"@\""].location != NSNotFound) {
        NSString*fir=[[type componentsSeparatedByString:@","] objectAtIndex:0];
        type = [type substringWithRange:NSMakeRange(3, fir.length - 4)];
    }else if (type.length >3) {
        type = [type substringWithRange:NSMakeRange(1, 1)];
    }
    NSString*lowerType = type.lowercaseString;
    if ([lowerType isEqualToString:@"i"]) {
        str = @"int";
    }else if ([lowerType isEqualToString:@"s"]) {
        str = @"short";
    }else if ([lowerType isEqualToString:@"f"]) {
        str = @"float";
    }else if ([lowerType isEqualToString:@"d"]) {
        str = @"double";
    }else if ([lowerType isEqualToString:@"q"]) {
        str = @"long";
    }else if ([lowerType isEqualToString:@"c"]) {
        str = @"char";
    }else if ([lowerType isEqualToString:@"c"] || [type.lowercaseString isEqualToString:@"b"]) {
        str = @"bool";
    }else if ([lowerType isEqualToString:@"@"]) {
        return @"NSObject";
    }
    else if ([NSClassFromString(type) class] == [NSDictionary class] || [NSClassFromString(type) class] == [NSArray class]) {
        return @"NSString";
    }
    else if ([[type class] isKindOfClass:[NSObject class]]) {
        return type;
    }else {
        return @"";
    }
    return str;
}

+ (NSDictionary*)getKeyValuesFrom:(NSObject*)obj
{
    NSArray*array = [[obj class] properties];
    NSMutableArray*a=[NSMutableArray array];
    for (NSDictionary*dic in array) {
        [a addObject:[dic objectForKey:@"name"]];
    }
    NSDictionary*dic = [obj dictionaryWithValuesForKeys:a];
    return dic;
}

#pragma mark    - 公用方法

+ (NSDictionary *)getPropertyListWithPrimaryKey:(NSArray *)primaryKeys
{
    NSMutableDictionary*dic=[NSMutableDictionary dictionary];
    [[self class] enumerateProperties:^(NSDictionary *property, BOOL *stop) {
        if (property && property.count>0) {
            [dic setObject:[[self class] typeString:[property objectForKey:@"type"]] forKey:[property objectForKey:@"name"]];
        }
    }];
//    NSLog(@"property %@",dic);
    if (primaryKeys) {
        if (primaryKeys.count>0) {
            [dic setObject:primaryKeys forKey:@"primary key"];
        }
    }
    return dic;
}

+ (id)setPropertyFromDataList:(NSDictionary*)dataList
{
    if (!dataList || dataList.count<=0) {
        return nil;
    }
    id ss = [[[self class] alloc] init];
    
    NSMutableDictionary*finally=[NSMutableDictionary dictionary];
    NSDictionary*dic = [[self class] getPropertyListWithPrimaryKey:nil];
    for (NSString*key in dic.allKeys) {
        NSString*type=[dic objectForKey:key];
        id value = [dataList objectForKey:key];
        if (value) {
            if (value == [NSNull null]) {
                value = @"";
            }else if (([[NSClassFromString(type) class] isSubclassOfClass: [NSString class]] || [[NSClassFromString(type) class] isSubclassOfClass: [NSArray class]] || [[NSClassFromString(type) class] isSubclassOfClass: [NSDictionary class]]) && [value isKindOfClass:[NSString class]]) {
                if (([value rangeOfString:@"{"].location==0 || [value rangeOfString:@"["].location==0 || [value rangeOfString:@"("].location==0)) {
                    
                    //value是个string
                    NSMutableString * str = [NSMutableString stringWithString:value];
                    [str replaceOccurrencesOfString:@"null" withString:@"\"\"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, str.length)];
                    [str replaceOccurrencesOfString:@"(" withString:@"[" options:NSCaseInsensitiveSearch range:NSMakeRange(0, str.length)];
                    [str replaceOccurrencesOfString:@")" withString:@"]" options:NSCaseInsensitiveSearch range:NSMakeRange(0, str.length)];
                    
                    NSData*tempData = [str dataUsingEncoding:NSUTF8StringEncoding];
                    
                    NSError *err = nil;
                    id tempjson = [NSJSONSerialization JSONObjectWithData:tempData options:NSJSONReadingMutableContainers error:&err];
                    if (tempjson && err==nil) {
                        value = tempjson;
                    }
                }
            }else if ([NSClassFromString(type) class] == [NSString class])
            {
                value = [NSString stringWithFormat:@"%@",value];
            }else if ([NSClassFromString(type) class] == [NSMutableString class]) {
                value = [NSMutableString stringWithFormat:@"%@",value];
            }
        }
        if (value) {
            [finally setObject:value forKey:key];
        }
    }
    [ss setValuesForKeysWithDictionary:finally];
    return ss;
}


- (NSString *)description
{
    unsigned int outCount = 0;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    // 2.遍历每一个成员变量
    NSString*desc=@"";
    for (unsigned int i = 0; i<outCount; i++) {
        NSString*name = [NSString stringWithCString:property_getName(properties[i]) encoding:NSUTF8StringEncoding];
        //获取get方法
        SEL getSel = NSSelectorFromString(name);
        
        if ([self respondsToSelector:getSel]) {
            
            id returnValue = [self valueForKey:name];
            
            desc = [desc stringByAppendingFormat:@" %@ = %@,",name,returnValue];
        }
    }
    if (desc.length>0) {
        desc = [@"peoperties *****" stringByAppendingString:[desc substringToIndex:desc.length-1]];
    }
    return desc;
}

#pragma mark    create table

+ (void)createTableWithName:(NSString*)name andPropertyList:(NSDictionary*)propertyAndType result:(CreateTableResult)result
{
    FMDatabaseQueue*queue=[FMDatabaseQueue databaseQueueWithPath:DBPath];
    if (!propertyAndType||propertyAndType.count<=0) {
        propertyAndType = [self getPropertyListWithPrimaryKey:nil];
    }
    [queue inDatabase:^(FMDatabase *db) {
        db.traceExecution=DBTraceExecution;
        db.checkedOut=DBTraceExecution;
        db.logsErrors=DBTraceExecution;
        BOOL re = [db tableExists:name];
        if (re) {//存在
            //更新column
            for (NSString*key in propertyAndType) {
                if ([key isEqualToString:@"primary key"]) {
                    continue;
                }
                BOOL hav = [db columnExists:key inTableWithName:name];
                if (!hav) {
                    [db executeUpdate:[NSString stringWithFormat:@"ALTER table %@ add column %@ %@",name,key,[propertyAndType objectForKey:key]]];
                }
            }
            //修改主键
            if ([propertyAndType objectForKey:@"primary key"]) {
                [db executeUpdate:[NSString stringWithFormat:@"ALTER TABLE %@ DROP PRIMARY KEY",name]];
                NSString * priKe = [[propertyAndType objectForKey:@"primary key"] componentsJoinedByString:@","];
                [db executeUpdate:[NSString stringWithFormat:@"ALTER TABLE %@ add PRIMARY KEY (%@)",name,priKe]];
            }
            //
            if (result) {
                result(TableStateExist);
            }
            return;
        }else {
            //表不存在
            re = [db executeUpdate:[NSString stringWithFormat:@"create table if not exists %@ (%@)",name,[[self class] addColumnSqlWithPropertyList:propertyAndType]]];
            //注入属性
            //alter table [表名] add [字段名] [类型名] default [默认值]
            //                  add [字段名] [类型名] default [默认值] NOT NULL
            //                  ADD PRIMARY KEY (EMP_NO, WORK_DEPT)
            if (result) {
                if (re) {
                    result(TableStateCreateSuccess);
                }else {
                    result(TableStateCreateFailed);
                }
            }
        }
    }];
}


+ (void)findTableWithName:(NSString*)name result:(CreateTableResult)result
{
    [[self class] createTableWithName:name andPropertyList:[[self class] getPropertyListWithPrimaryKey:nil] result:result];
}


+ (NSString*)addColumnSqlWithPropertyList:(NSDictionary*)propertyList
{
    NSString*sql=nil;
    if (propertyList.count>0) {
        sql = @"";
        for (NSString*key in propertyList) {
            if ([key isEqualToString:@"primary key"]) {
                continue;
            }
            sql = [sql stringByAppendingFormat:@"%@ %@,",key,[propertyList objectForKey:key]];
        }
        if ([propertyList objectForKey:@"primary key"]) {
            NSString * priKe = [[propertyList objectForKey:@"primary key"] componentsJoinedByString:@","];
            sql = [sql stringByAppendingFormat:@"PRIMARY KEY (%@)",priKe];
        }else {
            if (sql.length>0) {
                sql = [sql substringToIndex:sql.length-1];
            }
        }
    }
    return sql;
}

#pragma mark    清空/删除表

+ (void)clearTableWithName:(NSString*)name result:(HandleResult)result
{
    FMDatabaseQueue*queue=[FMDatabaseQueue databaseQueueWithPath:DBPath];
    [queue inDatabase:^(FMDatabase *db) {
        db.traceExecution=DBTraceExecution;
        db.checkedOut=DBTraceExecution;
        db.logsErrors=DBTraceExecution;
        BOOL re = [db executeUpdate:[NSString stringWithFormat:@"DELETE FROM %@",name]];
        if (result) {
            result(re);
        }
    }];
}


+ (void)deleteTableWithName:(NSString*)name result:(HandleResult)result
{
    FMDatabaseQueue*queue=[FMDatabaseQueue databaseQueueWithPath:DBPath];
    [queue inDatabase:^(FMDatabase *db) {
        db.traceExecution=DBTraceExecution;
        db.checkedOut=DBTraceExecution;
        db.logsErrors=DBTraceExecution;
        BOOL re = [db executeUpdate:[NSString stringWithFormat:@"drop table %@",name]];
        if (result) {
            result(re);
        }
    }];
}

#pragma mark    数据操作    ---增


- (void)addToTableWithTableName:(NSString*)name result:(HandleResult)result
{
    FMDatabaseQueue*queue=[FMDatabaseQueue databaseQueueWithPath:DBPath];
    [queue inDatabase:^(FMDatabase *db) {
        db.traceExecution=DBTraceExecution;
        db.checkedOut=DBTraceExecution;
        db.logsErrors=DBTraceExecution;
        BOOL re = [self addDataForTable:name from:db];
        if (result) {
            result(re);
        }
    }];
}

- (BOOL)addDataForTable:(NSString*)name from:(FMDatabase*)db
{
    NSDictionary*keyValues=[[self class] getKeyValuesFrom:self];
    NSString*str = nil;
    NSMutableArray*values = [NSMutableArray array];
    if (keyValues.count>0) {
        NSString*columnString = nil;
        NSString*valueString = nil;
        columnString=@"(";
        valueString=@"(";
        for (NSString*key in keyValues) {
            columnString = [columnString stringByAppendingFormat:@"%@,",key];
            valueString = [valueString stringByAppendingFormat:@"?,"];
            id vvalue = [keyValues objectForKey:key];
            if (([vvalue isKindOfClass:[NSDictionary class]] || [vvalue isKindOfClass:[NSArray class]]) && [NSJSONSerialization isValidJSONObject:vvalue]) {
                vvalue = [NSJSONSerialization dataWithJSONObject:vvalue options:NSJSONWritingPrettyPrinted error:nil];
                vvalue = [[NSString alloc] initWithData:vvalue encoding:NSUTF8StringEncoding];
            }
            [values addObject:vvalue];
        }
        columnString = [columnString substringToIndex:columnString.length-1];
        valueString = [valueString substringToIndex:valueString.length-1];
        columnString = [columnString stringByAppendingString:@")"];
        valueString = [valueString stringByAppendingString:@")"];
        str = [NSString stringWithFormat:@"%@ values %@",columnString,valueString];
    }
    return [db executeUpdate:[NSString stringWithFormat:@"INSERT INTO %@ %@",name,str] withArgumentsInArray:values];
}

- (NSString*)valueFromSelf
{
    NSDictionary*keyValues=[[self class] getKeyValuesFrom:self];
    NSString*str = nil;
    if (keyValues.count>0) {
        NSString*columnString = nil;
        NSString*valueString = nil;
        columnString=@"(";
        valueString=@"(";
        for (NSString*key in keyValues) {
            columnString = [columnString stringByAppendingFormat:@"%@,",key];
            id vvalue = [keyValues objectForKey:key];
            valueString = [valueString stringByAppendingFormat:@"'%@',",vvalue];
        }
        columnString = [columnString substringToIndex:columnString.length-1];
        valueString = [valueString substringToIndex:valueString.length-1];
        columnString = [columnString stringByAppendingString:@")"];
        valueString = [valueString stringByAppendingString:@")"];
        str = [NSString stringWithFormat:@"%@ values %@",columnString,valueString];
    }
    return str;
}

#pragma mark    数据操作    ---删

+ (void)deleteDataFromTableWithTableName:(NSString*)name property:(NSString*)property value:(id)value result:(HandleResult)result
{
    FMDatabaseQueue*queue=[FMDatabaseQueue databaseQueueWithPath:DBPath];
    [queue inDatabase:^(FMDatabase *db) {
        db.traceExecution=DBTraceExecution;
        db.checkedOut=DBTraceExecution;
        db.logsErrors=DBTraceExecution;
        BOOL re = [db executeUpdate:[NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ = '%@'",name,property,value]];
        if (result) {
            result(re);
        }
    }];
}


+ (void)deleteDataFromTableWithTableName:(NSString *)name sqlString:(NSString*)sqlString result:(HandleResult)result
{
    FMDatabaseQueue*queue=[FMDatabaseQueue databaseQueueWithPath:DBPath];
    [queue inDatabase:^(FMDatabase *db) {
        db.traceExecution=DBTraceExecution;
        db.checkedOut=DBTraceExecution;
        db.logsErrors=DBTraceExecution;
        BOOL re = [db executeUpdate:[NSString stringWithFormat:@"DELETE FROM %@ %@",name,sqlString]];
        if (result) {
            result(re);
        }
    }];
}


- (void)deleteFromTableName:(NSString*)name Result:(HandleResult)result
{
    FMDatabaseQueue*queue=[FMDatabaseQueue databaseQueueWithPath:DBPath];
    [queue inDatabase:^(FMDatabase *db) {
        db.traceExecution=DBTraceExecution;
        db.checkedOut=DBTraceExecution;
        db.logsErrors=DBTraceExecution;
        FMResultSet*r = [db getTableSchema:name];
        NSMutableArray*key=[NSMutableArray array];
        if (r) {
            while ([r next]) {
                BOOL pk = [[r objectForColumnName:@"pk"] boolValue];
                if (pk) {
                    [key addObject:[r objectForColumnName:@"name"]];
                }
            }
        }
        BOOL re = [db executeUpdate:[NSString stringWithFormat:@"DELETE FROM %@ %@",name,[self deleteFromTableWithPrimaryKey:key]]];
        if (result) {
            if (re) {
                result(HandleStateSuccess);
            }else {
                result(HandleStateFailed);
            }
        }
    }];
}


- (NSString*)deleteFromTableWithPrimaryKey:(NSArray*)key
{
    NSString*str=[self stringForKeyValueWithChar:@"and" withPrimaryKey:key];
    str = [@"where " stringByAppendingString:str];
    return str;
}

- (NSString*)stringForKeyValueWithChar:(NSString*)cha withPrimaryKey:(NSArray*)key
{
    NSString*str=@"";
    NSDictionary*keyValues=[[self class] getKeyValuesFrom:self];
    if (keyValues.count>0) {
        if (key.count>0) {
            for (NSString*k in key) {
                str = [str stringByAppendingFormat:@"%@ = '%@' and ",k,[keyValues objectForKey:k]];
            }
            if (str.length>0) {
                str = [str substringToIndex:str.length-5];
            }
        }else {
            for (NSString*k in keyValues) {
                str = [str stringByAppendingFormat:@"%@ = '%@' %@ ",k,[keyValues objectForKey:k],cha];
            }
            if (str.length>0) {
                str = [str substringToIndex:str.length-cha.length-2];
            }
        }
    }
    return str;
}

#pragma mark    数据操作    ---改

- (void)updateDataForTableName:(NSString*)name whereProperty:(NSString*)property equalToValue:(id)value result:(HandleResult)result
{
    FMDatabaseQueue*queue=[FMDatabaseQueue databaseQueueWithPath:DBPath];
    [queue inDatabase:^(FMDatabase *db) {
        db.traceExecution=DBTraceExecution;
        db.checkedOut=DBTraceExecution;
        db.logsErrors=DBTraceExecution;
        BOOL re = [db executeUpdate:[NSString stringWithFormat:@"UPDATE %@ set %@ where %@ = '%@'",name,[self updateFromTableWithPrimaryKey:nil],property,value]];
        if (result) {
            result(re);
        }
    }];
}

- (void)updateDataForTableName:(NSString*)name sqlString:(NSString*)sqlString result:(HandleResult)result
{
    FMDatabaseQueue*queue=[FMDatabaseQueue databaseQueueWithPath:DBPath];
    [queue inDatabase:^(FMDatabase *db) {
        db.traceExecution=DBTraceExecution;
        db.checkedOut=DBTraceExecution;
        db.logsErrors=DBTraceExecution;
        //查询语句
        NSString*whereSql = sqlString;
        if (sqlString.length<=0 || !sqlString) {
            FMResultSet*r = [db getTableSchema:name];
            NSMutableArray*key=[NSMutableArray array];
            if (r) {
                while ([r next]) {
                    BOOL pk = [[r objectForColumnName:@"pk"] boolValue];
                    if (pk) {
                        [key addObject:[r objectForColumnName:@"name"]];
                    }
                }
            }
            if (key.count>0) {
                whereSql = [@"where " stringByAppendingString:[self updateFromTableWithPrimaryKey:key]];
            }else {
                whereSql = @"";
            }
        }
        
        NSAssert(whereSql.length > 0, @"因为主键为空，所以sql语句不能为空");
        
        NSString*updateSql = [self updateFromTableWithPrimaryKey:nil] ;
        BOOL re = [db executeUpdate:[NSString stringWithFormat:@"UPDATE %@ set %@ %@",name,updateSql,whereSql]];
        if (result) {
            result(re);
        }
    }];
}

- (NSString*)updateFromTableWithPrimaryKey:(NSArray*)key
{
    NSString*str=[self stringForKeyValueWithChar:@"," withPrimaryKey:key];
    return str;
}


#pragma mark    数据操作    ---查

+ (void)selectTableWithName:(NSString*)name property:(NSString*)property value:(id)value result:(SelectHandleResult)result
{
    FMDatabaseQueue*queue=[FMDatabaseQueue databaseQueueWithPath:DBPath];
    [queue inDatabase:^(FMDatabase *db) {
        db.traceExecution=DBTraceExecution;
        db.checkedOut=DBTraceExecution;
        db.logsErrors=DBTraceExecution;
        FMResultSet*r = [db executeQueryWithFormat:@"SELECT * FROM %@ where %@ = '%@'",name,property,value];
        if (r) {
            NSMutableArray*arr=[NSMutableArray array];
            while ([r next]) {
                NSMutableDictionary*dic=[NSMutableDictionary dictionary];
                for (NSString*columnName in r.columnNameToIndexMap.allKeys)
                {
                    [dic setObject:[r objectForColumnName:columnName] forKey:columnName];
                }
                if (dic.count>0) {
                    [arr addObject:[[self class] setPropertyFromDataList:dic]];
                }
            }
            if (result) {
                result(HandleStateSuccess,arr);
            }
        }else {
            if (result) {
                result(HandleStateFailed,nil);
            }
        }
    }];
}

+ (void)selectTableWithName:(NSString*)name sqlString:(NSString*)sqlString result:(SelectHandleResult)result
{
    FMDatabaseQueue*queue=[FMDatabaseQueue databaseQueueWithPath:DBPath];
    [queue inDatabase:^(FMDatabase *db) {
        db.traceExecution=DBTraceExecution;
        db.checkedOut=DBTraceExecution;
        db.logsErrors=DBTraceExecution;
        FMResultSet*r = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM %@ %@",name,sqlString==nil?@"":sqlString]];
        if (r) {
            NSMutableArray*arr=[NSMutableArray array];
            while ([r next]) {
                NSMutableDictionary*dic=[NSMutableDictionary dictionary];
                for (NSString*columnName in r.columnNameToIndexMap.allKeys) {
                    [dic setObject:[r objectForColumnName:columnName] forKey:[r columnNameForIndex:[[r.columnNameToIndexMap objectForKey:columnName] intValue]]];
                }
                if (dic.count>0) {
                    [arr addObject:[[self class] setPropertyFromDataList:dic]];
                }
            }
            if (result) {
                result(HandleStateSuccess,arr);
            }
        }else {
            if (result) {
                result(HandleStateFailed,nil);
            }
        }
    }];
}

+ (void)getColumnsCountWithTableName:(NSString *)name result:(void (^)(NSInteger, NSArray *))result
{
    FMDatabaseQueue*queue=[FMDatabaseQueue databaseQueueWithPath:DBPath];
    [queue inDatabase:^(FMDatabase *db) {
        db.traceExecution=DBTraceExecution;
        db.checkedOut=DBTraceExecution;
        db.logsErrors=DBTraceExecution;
        FMResultSet*r = [db getTableSchema:name];
        NSInteger count = r.columnCount;
        NSMutableArray*arr=[NSMutableArray array];
        while ([r next]) {
            if ([[r objectForColumnName:@"name"] length]>0) {
                [arr addObject:[r objectForColumnName:@"name"]];
            }
        }
        if (result) {
            result(count,arr);
        }
    }];
}


@end
