//
//  PersistentDemo.m
//  YaweiTest
//
//  Created by hzzhanyawei on 16/2/4.
//  Copyright © 2016年 hzzhanyawei. All rights reserved.
//

#import "PersistentDemo.h"
#import <sqlite3.h>

/***********Test keyarchiver***********/
@interface Person : NSObject
@property (nonatomic, strong)NSString *name;
@property (nonatomic) NSInteger age;
@property (nonatomic) BOOL gender;


@end
/***********Test keyarchiver***********/
@implementation Person
- (id)initWithCoder:(NSCoder *)aDecoder{
    if ([super init]) {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.age = [aDecoder decodeIntegerForKey:@"age"];
        self.gender = [aDecoder decodeBoolForKey:@"gender"];
    }
    return self;
}


- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeInteger:self.age forKey:@"age"];
    [aCoder encodeBool:self.gender forKey:@"gender"];
}
@end

@interface PersistentDemo ()
{
    sqlite3 *db;
}

@end


@implementation PersistentDemo

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self testDataSavePath];
    [self testPlistData];
    [self testPreferenceData];
    [self testKeyedArchiver];
    
    [self testSqlite];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//路径测试
- (void)testDataSavePath{
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSLog(@"Bundle path is %@", path);
//    NSArray *pathArr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSLog(@"Document path is %@", docPath);
    
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSLog(@"Cache path is %@", cachePath);
    
    NSString *tmpPath = NSTemporaryDirectory();
    NSLog(@"Tmp Paht is%@", tmpPath);
}
//Plist 存储数据测试
- (void)testPlistData{
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *fileName = [docPath stringByAppendingPathComponent:@"test.plist"];
    NSArray *array = @[@"test1",@"test2",@"test3"];
    //write
    [array writeToFile:fileName atomically:YES];
    //read
    NSArray *readArr = [NSArray arrayWithContentsOfFile:fileName];
    NSLog(@"Plist read array is %@", readArr);
}
//Preference 存储数据测试
- (void)testPreferenceData{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:@"john" forKey:@"name"];
    [userDefaults setInteger:27 forKey:@"age"];
    [userDefaults setBool:YES forKey:@"gender"];
    [userDefaults synchronize];//同步
    
    //读取
    NSString *name = [userDefaults objectForKey:@"name"];
    NSInteger age = [userDefaults integerForKey:@"age"];
    BOOL gender = [userDefaults boolForKey:@"gender"];
    NSLog(@"Name is %@, gender is %d, age is %ld", name, gender, age);
}
//KeyedArchiver 存储Object测试
- (void)testKeyedArchiver{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *fileName = [path stringByAppendingPathComponent:@"person.data"];
    Person *person = [[Person alloc] init];
    person.name = @"john";
    person.age = 26;
    person.gender = YES;
    
    [NSKeyedArchiver archiveRootObject:person toFile:fileName];
    
    Person *readPerson = [NSKeyedUnarchiver unarchiveObjectWithFile:fileName];
    if (readPerson) {
        NSLog(@"Name is %@, gender is %d, age is %ld", readPerson.name, readPerson.gender, readPerson.age);
    }
}

- (void)testSqlite{
    //创建数据库
    [self createDb:@"personInfo.sqlite"];
    //创建表
    NSString *sqlCreateTable = @"CREATE TABLE personInfo (ID INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, age INTEGER, address TEXT)";
    [self execSql:sqlCreateTable];
    //插入
    NSString *insertOne = [NSString stringWithFormat:@"INSERT INTO '%@' (name, age, address) VALUES ('%@', '%@', '%@')", @"personInfo", @"张三", @"20", @"西湖区"];
    NSString *insertTwo = [NSString stringWithFormat:@"INSERT INTO '%@' (name, age, address) VALUES ('%@', '%@', '%@')", @"personInfo", @"李四", @"26", @"滨江区"];
    [self execSql:insertOne];
    [self execSql:insertTwo];
    //查询数据
    NSString *search = [NSString stringWithFormat:@"SELECT * FROM '%@' WHERE name='%@'", @"personInfo", @"张三"];
    [self execSearchSql:search];
    [self closeDb];
}

- (void)createDb:(NSString *)name{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *dbName = [path stringByAppendingPathComponent:name];
    if (sqlite3_open([dbName UTF8String], &db) != SQLITE_OK) {
        sqlite3_close(db);
        NSLog(@"数据库打开失败");
    }
}

- (void)execSql:(NSString *)sql{
    char *err;
    if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) {
        sqlite3_close(db);
        NSLog(@"数据库操作失败");
    }
}

- (void)execSearchSql:(NSString *)sql{
    sqlite3_stmt *statement;
    
    if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            char *name = (char *)sqlite3_column_text(statement, 1);
            NSString *nsNameStr = [[NSString alloc] initWithUTF8String:name];
            
            int age = sqlite3_column_int(statement, 2);
            
            char *address = (char *)sqlite3_column_text(statement, 3);
            NSString *nsAddrerss = [[NSString alloc] initWithUTF8String:address];
            NSLog(@"name :%@, age: %d, address: %@", nsNameStr, age, nsAddrerss);
        }
    }
}

- (void)closeDb{
    sqlite3_close(db);
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
