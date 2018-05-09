//
//  Model.h
//  Toolbox
//
//  Created by gener on 17/7/10.
//  Copyright © 2017年 Light. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LKDBHelper/LKDBHelper.h>
#import <objc/runtime.h>

//BASE MODEL
@interface Model : NSObject


/**
 写入数据库

 @param data 数据集合（数组或字典）
 */
+(void)saveToDbWith:(id)data;

//直接插入，不检测是否存在
+(void)saveToDbNotCheckWith:(id)data;

/**
 根据查询条件查找
 
 @param query 查询条件
 @param order 排序项
 
 @return Array
 */
+(NSArray*)searchWith:(NSString*)query
              orderBy:(NSString*)order;


+(NSArray*)searchWithSql:(NSString*)sql;

+(BOOL)deleteWith:(NSString*)query;//删除表中数据

+(BOOL)isExistTable;//表是否存在

/**
 创建实例

 @param dic key-value

 @return 实例对象
 */
-(instancetype)modelWith:(NSDictionary*)dic;


/*私有方法，必须由子类重载.外部调用无意义。*/
-(NSString *)getPrimarykey;

@end


@interface AMMModel : Model
@property(nonatomic,copy)NSString * taskCode;
@property(nonatomic,copy)NSString * taskName;
@property(nonatomic,copy)NSString * doc;

@end

@interface MELModel : Model
@property(nonatomic,copy)NSString * code;
@property(nonatomic,copy)NSString * title;
@property(nonatomic,copy)NSString * _description;

@end

@interface TSMModel : Model
@property(nonatomic,copy)NSString * code;
@property(nonatomic,copy)NSString * message;

@end















