//
//  ViewController.m
//  01.CoreData的简单使用
//
//  Created by apple on 14/12/5.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "ViewController.h"
#import <CoreData/CoreData.h>

#import "Employee.h"

@interface ViewController (){
    NSManagedObjectContext *_context;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    1.创建模型文件 ［相当于一个数据库里的表］
//    2.添加实体 ［一张表］
//    3.创建实体类 [相当模型]
//    4.生成上下文 关联模型文件生成数据库
    /*
     * 关联的时候，如果本地没有数据库文件，Ｃoreadata自己会创建
     */
    
    // 上下文
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] init];
    
    // 上下文关连数据库

    // model模型文件
    NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    // 持久化存储调度器
    // 持久化，把数据保存到一个文件，而不是内存
    NSPersistentStoreCoordinator *store = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    
    // 告诉Coredata数据库的名字和路径
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    NSString *sqlitePath = [doc stringByAppendingPathComponent:@"company.sqlite"];
    NSLog(@"%@",sqlitePath);
    [store addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[NSURL fileURLWithPath:sqlitePath] options:nil error:nil];
    
    context.persistentStoreCoordinator = store;
    _context = context;

}

// 数据库的操作 CURD Create Update  Read Delete
#pragma mark 添加员工
-(IBAction)addEmployee{

    // 创建一个员工对象
    //Employee *emp = [[Employee alloc] init];
    
    for (int i = 0; i < 15; i++) {
        Employee *emp = [NSEntityDescription insertNewObjectForEntityForName:@"Employee" inManagedObjectContext:_context];
        emp.name = [NSString stringWithFormat:@"wangwu%d",i];
        emp.height = @(1.80 + i);
        emp.birthday = [NSDate date];
        
        
    }
   
    
    // 直接保存数据库
    NSError *error = nil;
    [_context save:&error];
    
    if (error) {
        NSLog(@"%@",error);
    }
}

#pragma mark 读取员工
-(IBAction)readEmployee{
    // 1.FectchRequest 抓取请求对象
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Employee"];
    
    
    
    // 3.设置排序
    // 身高的升序排序
    NSSortDescriptor *heigtSort = [NSSortDescriptor sortDescriptorWithKey:@"height" ascending:NO];
    request.sortDescriptors = @[heigtSort];
    
    // 模糊查询
    // 名字以"wang"开头
//    NSPredicate *pre = [NSPredicate predicateWithFormat:@"name BEGINSWITH %@",@"wangwu1"];
//    request.predicate = pre;
    
    // 名字以"1"结尾
//    NSPredicate *pre = [NSPredicate predicateWithFormat:@"name ENDSWITH %@",@"1"];
//    request.predicate = pre;

    
    // 名字包含"wu1"
//    NSPredicate *pre = [NSPredicate predicateWithFormat:@"name CONTAINS %@",@"wu1"];
//    request.predicate = pre;
    
    // like
    //以wangwu1*开头
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"name like %@",@"*wu12"];
    request.predicate = pre;

    // 4.执行请求
    NSError *error = nil;
    
    NSArray *emps = [_context executeFetchRequest:request error:&error];
    
    if (error) {
        NSLog(@"error");
    }
    
    //NSLog(@"%@",emps);
    //遍历员工
    for (Employee *emp in emps) {
        NSLog(@"名字 %@ 身高 %@ 生日 %@",emp.name,emp.height,emp.birthday);
    }
    
    
}

#pragma mark 分页查询
-(void)pageSeacher{
    // 1.FectchRequest 抓取请求对象
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Employee"];
    
    
    
    // 3.设置排序
    // 身高的升序排序
    NSSortDescriptor *heigtSort = [NSSortDescriptor sortDescriptorWithKey:@"height" ascending:NO];
    request.sortDescriptors = @[heigtSort];
    
    // 总有共有15数据
    // 每次获取6条数据
    // 第一页 0,6
    // 第二页 6,6
    // 第三页 12,6 3条数据
    // 分页查询 limit 0,5
    
    // 分页的起始索引
    request.fetchOffset = 12;
    
    // 分页的条数
    request.fetchLimit = 6;
    
    // 4.执行请求
    NSError *error = nil;
    
    NSArray *emps = [_context executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"error");
    }
    
    //NSLog(@"%@",emps);
    //遍历员工
    for (Employee *emp in emps) {
        NSLog(@"名字 %@ 身高 %@ 生日 %@",emp.name,emp.height,emp.birthday);
    }
    
}

@end
