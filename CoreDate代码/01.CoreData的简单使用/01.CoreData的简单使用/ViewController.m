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
    Employee *emp = [NSEntityDescription insertNewObjectForEntityForName:@"Employee" inManagedObjectContext:_context];
    emp.name = @"wangwu";
    emp.height = @1.80;
    emp.birthday = [NSDate date];
    
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
    
    // 2.设置过滤条件
    // 查找zhangsan
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"name = %@",
                        @"zhangsan"];
    //request.predicate = pre;
    
    // 3.设置排序
    // 身高的升序排序
    NSSortDescriptor *heigtSort = [NSSortDescriptor sortDescriptorWithKey:@"height" ascending:NO];
    request.sortDescriptors = @[heigtSort];
    
    
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

#pragma mark 更新员工
-(IBAction)updateEmployee{
    // 改变zhangsan的身高为2m
    
    // 1.查找到zhangsan
    // 1.1FectchRequest 抓取请求对象
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Employee"];
    
    // 1.2设置过滤条件
    // 查找zhangsan
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"name = %@",
                        @"zhangsan"];
    request.predicate = pre;
    
    // 1.3执行请求
    NSArray *emps = [_context executeFetchRequest:request error:nil];
    
    
    // 2.更新身高
    for (Employee *e in emps) {
        e.height = @2.0;
    }
    
    // 3.保存
    [_context save:nil];
}

#pragma mark 删除员工
-(IBAction)deleteEmployee{
    
    // 删除 lisi
    
    // 1.查找lisi
    // 1.1FectchRequest 抓取请求对象
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Employee"];
    
    // 1.2设置过滤条件
    // 查找zhangsan
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"name = %@",
                        @"lisi"];
    request.predicate = pre;
    
    // 1.3执行请求
    NSArray *emps = [_context executeFetchRequest:request error:nil];
    
    // 2.删除
    for (Employee *e in emps) {
        [_context deleteObject:e];
    }
    
    // 3.保存
    [_context save:nil];

}
@end
