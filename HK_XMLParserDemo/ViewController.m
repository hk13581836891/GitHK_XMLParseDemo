//
//  ViewController.m
//  HK_XMLParserDemo
//
//  Created by houke on 2018/1/12.
//  Copyright © 2018年 houke. All rights reserved.
//

#import "ViewController.h"
#import "HKStudent.h"
#import "GDataXMLNode.h"

/*
 XML(Extensible Markup Language) -- 可扩展标记语言,主流数据格式之一,可以用来存储和传输数据
 
 解析：从事先规定好的格式中提取数据,(把 xml文件的数据提取出来的过程)
 
 解析方式：SAX解析 -- 逐行解析
         DOM解析 -- 整体读取，然后将 xml结构化成树状,使用时通过树状结构读取数据
 
 */
@interface ViewController ()<NSXMLParserDelegate>//遵守协议
{
    HKStudent *_student;
    NSString *_string;
}

@property (nonatomic, strong) NSMutableArray *array;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _array = [NSMutableArray array];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)parserWithSAX:(UIButton *)sender {
    //找到 xml文件-资源路径
    NSString *xmlFilePath = [[NSBundle mainBundle] pathForResource:@"Student" ofType:@"xml"];
    //创建 url
    NSURL *xmlFilePathUrl = [NSURL fileURLWithPath:xmlFilePath];
    //系统 xml解析类
    NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:xmlFilePathUrl];
    //设置代理
    parser.delegate = self;
    //开始解析
    [parser parse];
    
}

- (IBAction)parserWithDom:(UIButton *)sender {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Student" ofType:@"xml"];
    
    //获取该文件路径里的内容
    NSError *error = nil;
    NSString *content = [[NSString alloc] initWithContentsOfURL:[NSURL fileURLWithPath:filePath] encoding:NSUTF8StringEncoding error:&error];
    if (error == nil) {
        NSLog(@"content:%@",content);
    }else{
        NSLog(@"error%@",error);
        return;
    }
    
    //使用 DOM 方式对 content进行解析
    //GDataXMLDocument 用于文件内容的读取,并形成树状结构
    GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithXMLString:content options:0 error:nil];
    
    //对树状结构进行分析
    //取到根节点
    GDataXMLElement *rootElement = [document rootElement];
    
    //查找子节点
    NSArray *studentElements = [rootElement elementsForName:@"student"];
    NSLog(@"studentElements%@",studentElements);
    
    for (GDataXMLElement *element in studentElements) {
        NSLog(@"-----------------");
        NSLog(@"element:%@",element);
        
        NSLog(@"name:%@", [[element elementsForName:@"name"][0] stringValue]);
        NSLog(@"age:%@", [[element elementsForName:@"age"][0] stringValue]);
        NSLog(@"gender:%@", [[element elementsForName:@"gender"][0] stringValue]);
        
        HKStudent *student = [[HKStudent alloc] init];
        student.name = [[element elementsForName:@"name"][0] stringValue];
        student.age =  [[element elementsForName:@"age"][0] stringValue];
        student.gender = [[element elementsForName:@"gender"][0] stringValue];
        [_array addObject:student];
    }
    NSLog(@"array：%@",_array);
    
}

#pragma mark xmlParserDelegate
//开始解析
-(void)parserDidStartDocument:(NSXMLParser *)parser
{
    NSLog(@"开始解析");
}
//结束解析
-(void)parserDidEndDocument:(NSXMLParser *)parser
{
    NSLog(@"结束解析");
    for (HKStudent *student in _array) {
        NSLog(@"%@",student);
    }
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict
{
    NSLog(@"遇到开始标签%@",elementName);
    if ([elementName isEqual:@"student"]) {
        _student = [[HKStudent alloc] init];
    }
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    NSLog(@"遇到结束标签%@",elementName);
    if ([elementName isEqual:@"name"]) {
        _student.name = _string;
    }else if ([elementName isEqual:@"age"]){
        _student.age = _string;
    }else if ([elementName isEqual:@"gender"]){
        _student.gender = _string;
    }else if ([elementName isEqual:@"student"]){
        [_array addObject:_student];
    }
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    NSLog(@"遇到内容%@",string);
    _string = string;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
