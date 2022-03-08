//
//  MyClass.m
//  SwiftTest
//
//  Created by karos li on 2021/8/18.
//

#import "MyPerson.h"
#import "SwiftTest-Swift.h"

int sum(int a, int b) {
    return a + b;
}

@implementation MyPerson
- (instancetype)initWithAge:(NSInteger)age name:(NSString *)name {
    if (self = [super init]) {
        _age = age;
        _name = [name copy];
    }
    
    return self;
}
+ (instancetype)personWithAge:(NSInteger)age name:(NSString *)name {
    return [[self alloc] initWithAge:age name:name];
}
- (void)run {
    NSLog(@"%zd %@ -run", self.age, self.name);
}
+ (void)run {
    NSLog(@"MyClass +run");
}
- (void)eat:(NSString *)food other:(NSString *)other {
    NSLog(@"%zd %@ -eat %@ %@", self.age, self.name, food, other);
}
+ (void)eat:(NSString *)food other:(NSString *)other {
    NSLog(@"MyClass +eat %@ %@", food, other);
}
@end

void testOCInvokeSwift(void) {
    MyCar *car = [[MyCar alloc] initWithPrice:1100000 band:@"奔驰"];
    [car test];
    [car drive];
    [MyCar drive];
}
