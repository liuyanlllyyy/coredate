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
#import "Status.h"

@interface ViewController (){
    NSManagedObjectContext *_context;
    NSManagedObjectContext *_companyContext;
    NSManagedObjectContext *_weiboContext;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // 一个数据库对应一个上下文
    _companyContext = [self setupContextWithModelName:@"Company"];
    _weiboContext = [self setupContextWithModelName:@"Weibo"];

    //_context = context;

}

/**
 *  根据模型文件，返回一个上下文
 */
-(NSManagedObjectContext *)setupContextWithModelName:(NSString *)modelName{
    
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
    
    // 使用下面的方法，如果 bundles为nil 会把bundles里面的所有模型文件的表放在一个数据库
    //NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:nil];
    NSLog(@"%@",[[NSBundle mainBundle] bundlePath]);
    
    NSURL *companyURL = [[NSBundle mainBundle] URLForResource:modelName withExtension:@"momd"];
    NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:companyURL];
    
    // 持久化存储调度器
    // 持久化，把数据保存到一个文件，而不是内存
    NSPersistentStoreCoordinator *store = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    
    // 告诉Coredata数据库的名字和路径
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    NSString *sqliteName = [NSString stringWithFormat:@"%@.sqlite",modelName];
    NSString *sqlitePath = [doc stringByAppendingPathComponent:sqliteName];
    NSLog(@"%@",sqlitePath);
    [store addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[NSURL fileURLWithPath:sqlitePath] options:nil error:nil];
    
    context.persistentStoreCoordinator = store;
    
    return context;
}

// 数据库的操作 CURD Create Update  Read Delete
#pragma mark 添加员工
-(IBAction)addEmployee{
    // 添加员工
    Employee *emp = [NSEntityDescription insertNewObjectForEntityForName:@"Employee" inManagedObjectContext:_companyContext];
    emp.name = @"zhagsan";
    emp.height = @2.3;
    emp.birthday = [NSDate date];
    
    // 直接保存数据库
    NSError *error = nil;
    [_companyContext save:&error];
    
    if (error) {
        NSLog(@"%@",error);
    }
    
    // 发微博
    Status *status =[NSEntityDescription insertNewObjectForEntityForName:@"Status" inManagedObjectContext:_weiboContext];
    
    status.text = @"毕业，挺激动";
    status.createDate = [NSDate date];
    
    [_weiboContext save:nil];
}

#pragma mark 读取员工
-(IBAction)readEmployee{
   
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Employee"];
    
    // 4.执行请求
    NSError *error = nil;
    
    NSArray *emps = [_companyContext executeFetchRequest:request error:&error];
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
