//
//  XmlParserViewController.m
//  YaweiTest
//
//  Created by hzzhanyawei on 16/4/25.
//  Copyright © 2016年 hzzhanyawei. All rights reserved.
//

#import "XmlParserViewController.h"
#import "Item.h"


#define ITEM @"item"
#define TITLE @"title"
#define LINK @"link"
#define DESCRIPTION @"description"
#define PUBDATE @"pubDate"

@interface XmlParserViewController ()<NSURLConnectionDelegate,NSURLConnectionDataDelegate,NSXMLParserDelegate>
//下载下来的xmldata
@property (nonatomic, strong)NSMutableData *xmlData;
@property (nonatomic, assign)BOOL isDone;
//选中的解析方式索引
@property (nonatomic, assign)NSUInteger choosedIndex;

//xml解析完成的数据
@property (nonatomic, strong)NSMutableArray *items;
@property (nonatomic, strong)Item *currentItem;
//nsxmlparser need
@property (nonatomic, assign)BOOL isStore;
@property (nonatomic, strong)NSMutableString *storeString;


@end

@implementation XmlParserViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    
    _dataArr = [[NSMutableArray alloc] initWithObjects:@"NSXMLParser", @"libxml2", @"TBXMLParser", nil];
    
    
    _items = [NSMutableArray array];
}

- (void)downloadXmlDataInNewThreadWithUrl:(NSURL *)aUrl{
    if (!self.xmlData) {//如果xmldata不存在则下载
        self.xmlData = [NSMutableData data];
        [NSThread detachNewThreadSelector:@selector(downloadXmlData:) toTarget:self withObject:aUrl];
    }
}
- (void)downloadXmlData:(NSURL *)aUrl{
    self.isDone = NO;
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    NSURLRequest *request = [NSURLRequest requestWithURL:aUrl];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (connection) {
        do{
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        }while (!self.isDone);
    }
}

- (void)parseXMLData{
    if (self.choosedIndex == 0) {
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData:self.xmlData];
        parser.delegate = self;
        [parser parse];
    }
    
}

#pragma mark - tableview datasoure && delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XMLCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"XMLCell"];
    }
    cell.textLabel.text = self.dataArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.choosedIndex = indexPath.row;
    [self downloadXmlDataInNewThreadWithUrl:[NSURL URLWithString:@"http://images.apple.com/main/rss/hotnews/hotnews.rss"]];
}

#pragma mark - NSurlconnection delegate
- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse {
    return nil;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    self.isDone = YES;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [self.xmlData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    [self parseXMLData];
    self.isDone = YES;
}

#pragma mark - nsxmlparserdelegate
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict{
    if ([elementName isEqualToString:ITEM]) {
        self.currentItem = [[Item alloc] init];
    }else if ([elementName isEqualToString:TITLE] || [elementName isEqualToString:LINK] || [elementName isEqualToString:DESCRIPTION] || [elementName isEqualToString:PUBDATE]) {
        self.isStore = YES;
        self.storeString = [NSMutableString string];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    if (self.isStore) {
        [self.storeString appendString:string];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    if ([elementName isEqualToString:ITEM]) {
        [self.items addObject:self.currentItem];
    } else if ([elementName isEqualToString:TITLE]){
        self.currentItem.title = self.storeString;
    } else if ([elementName isEqualToString:LINK]){
        self.currentItem.link = self.storeString;
    } else if ([elementName isEqualToString:DESCRIPTION]){
        self.currentItem.desc = self.storeString;
    } else if ([elementName isEqualToString:PUBDATE]){
        self.currentItem.pubDate = self.storeString;
    }
    self.isStore = NO;
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError{
    
}

@end
