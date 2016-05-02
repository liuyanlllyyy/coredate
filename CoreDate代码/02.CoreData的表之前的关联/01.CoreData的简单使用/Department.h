//
//  Department.h
//  01.CoreData的简单使用
//
//  Created by apple on 14/12/5.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Department : NSManagedObject

@property (nonatomic, retain) NSString * name;//部门名称
@property (nonatomic, retain) NSString * departNo;//部门的编号
@property (nonatomic, retain) NSDate * createDate;//部门的成立日期

@end
