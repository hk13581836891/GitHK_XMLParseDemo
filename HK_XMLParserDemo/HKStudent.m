//
//  HKStudent.m
//  HK_XMLParserDemo
//
//  Created by houke on 2018/1/12.
//  Copyright © 2018年 houke. All rights reserved.
//

#import "HKStudent.h"

@implementation HKStudent

-(NSString *)description
{
    NSString *str = [NSString stringWithFormat:@"name = %@, age = %@, gender = %@",self.name, self.age, self.gender];
    return str;
}
@end
