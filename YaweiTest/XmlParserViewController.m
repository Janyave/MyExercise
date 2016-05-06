//
//  XmlParserViewController.m
//  YaweiTest
//
//  Created by hzzhanyawei on 16/4/25.
//  Copyright © 2016年 hzzhanyawei. All rights reserved.
//

#import "XmlParserViewController.h"
#import "Item.h"

#import <libxml2/libxml/parser.h>
#import <libxml2/libxml/tree.h>
#import <libxml2/libxml/xpath.h>

#import "TBXML.h"


#define CHANNEL @"channel"

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
    } else if (self.choosedIndex == 1){
        [self parseXMLDataByLibXml2];
    } else if (self.choosedIndex ==2){
        [self parseXMLByTBXml];
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
    //libxml2有SAX和DOM两种方式解析，其中SAX可以边下边解析，demo中给出的是DOM方式(加入libxml2需要设置header search path)
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

#pragma mark - libxml2 parser function
xmlNode* findElement(xmlNode *child, xmlChar *elementName) {
    
    while (child != NULL) {
        if (child->type == XML_ELEMENT_NODE) {
            if (strncmp(child->name, elementName, strlen(elementName)) == 0) {
                return child;
            }
        }
        child = child->next;
    }
    return NULL;
    
}

xmlChar* findTextForFirstChild(xmlNode *parent, xmlChar *elementName){
    xmlNode *child = findElement(parent->children, elementName);
    if (child) {
        xmlNode *text = child->children;
        if (text && text->type == XML_TEXT_NODE) {
            return text->content;
        }
    }
    return NULL;
}

- (void)parseXMLDataByLibXml2{
    xmlDoc *doc = xmlParseMemory(self.xmlData.bytes, (int)self.xmlData.length);
    if (doc) {
        xmlXPathContext *xPathCtx = xmlXPathNewContext(doc);
        if (xPathCtx) {
            xmlXPathObject *xPathObj = xmlXPathEvalExpression("///item", xPathCtx);//为什么要加斜杠？
            if (xPathObj) {
                xmlNodeSet *nodeSet = xPathObj->nodesetval;
                for (int i = 0; i < nodeSet->nodeNr; i++) {
                    xmlNode *node = nodeSet->nodeTab[i];
                    
                    Item *item = [[Item alloc] init];
                    xmlChar *title = findTextForFirstChild(node, "title");
                    if (title != NULL) {
                        item.title = [NSString stringWithUTF8String:title];
                    }
                    xmlChar *link = findTextForFirstChild(node, "link");
                    if (link != NULL) {
                        item.link = [NSString stringWithUTF8String:link];
                    }
                    xmlChar *desc = findTextForFirstChild(node, "description");
                    if (desc != NULL) {
                        item.desc = [NSString stringWithUTF8String:desc];
                    }
                    xmlChar *pubDate = findTextForFirstChild(node, "pubDate");
                    if (pubDate != NULL) {
                        item.pubDate = [NSString stringWithUTF8String:pubDate];
                    }
                    
                    [self.items addObject:item];
                }
                xmlXPathFreeObject(xPathObj);
            }
            xmlXPathFreeContext(xPathCtx);
        }
        xmlFreeDoc(doc);
    }
    self.isDone = YES;
}

#pragma mark - TBXML parser function
- (void)parseXMLByTBXml{
    TBXML *tbXml = [[TBXML alloc] initWithXMLData:self.xmlData];
    TBXMLElement *root = tbXml.rootXMLElement;
    if (root) {
        TBXMLElement *channel = [TBXML childElementNamed:CHANNEL parentElement:root];
        if (channel) {
            TBXMLElement *node = [TBXML childElementNamed:ITEM parentElement:channel];
            while (node != nil) {
                Item *item = [[Item alloc] init];
                TBXMLElement *title = [TBXML childElementNamed:TITLE parentElement:node];
                if (title != nil) {
                    item.title = [TBXML textForElement:title];
                }
                TBXMLElement *link = [TBXML childElementNamed:LINK parentElement:node];
                if (link != nil) {
                    item.link = [TBXML textForElement:link];
                }
                TBXMLElement *desc = [TBXML childElementNamed:DESCRIPTION parentElement:node];
                if (desc != nil) {
                    item.desc = [TBXML textForElement:desc];
                }
                TBXMLElement *pubDate = [TBXML childElementNamed:PUBDATE parentElement:node];
                if (pubDate != nil) {
                    item.pubDate = [TBXML textForElement:pubDate];
                }
                [self.items addObject:item];
                node = [TBXML nextSiblingNamed:ITEM searchFromElement:node];
            }
        }
    }
    
    self.isDone = YES;
    
}

@end
