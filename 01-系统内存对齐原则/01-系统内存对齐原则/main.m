//
//  main.m
//  01-系统内存对齐原则
//
//  Created by han xiao on 2020/9/8.
//  Copyright © 2020 han xiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <objc/runtime.h>
#import <malloc/malloc.h>

struct HXStruct1 {
    double a;   // 8 (0-7)
    char b;     // 1 [8 1] (8)
    // 4 [9 4] 9 10 11 12
    //因为9不是4的整数倍，所以要从12开始算起，也就是12，13，14，15
    int c;
    short d;    // 2 [16 2] (16 17)
}struct1;

// 内部需要的大小为: 17
// 最大属性 : 8
// 结构体整数倍: 24

struct HXStruct2 {
    double a;   //8 (0-7)
    int b;      //4 (8 9 10 11)
    char c;     //1 (12)
    short d;    //2 13 (14 15) - 16
}struct2;
// 15 -> 16

struct HXStruct3{
    double a; //8 (0-7)
    int b;  //4 (8 9 10 11)
    char c;  //1 (12)
    short d; //2 13 (14 15) - 16
    NSString* (*getName)(void); //8 (16,23)-24
    struct HXStruct1 hxSc; 
}struct3;

struct HXStruct4{
    //函数占8个字节
   void (*initWithOptions)(NSDictionary *);//8(0-7)
    NSString *(*getDeviceInfo)(void); //8(8-15)
    NSString *(*getInitStatus)(void); //8(16-23)
     NSDictionary *(*getConfigInfo)(void); //8(24,31)
    
}struct4;


@interface  HXPerson: NSObject
 //对象占了8字节（0-7）
@property (nonatomic, copy) NSString *name; // 8 (8,15)

@property (nonatomic, copy) NSString *nickName; //8 (16,23)
@property (nonatomic, assign) int age; //4 (24,27)
@property (nonatomic, assign) long height; //8 因为28不是8的整数倍，所以从32开始算起
//（32，39）因为实际使用的内存要是8的整数倍，所以实际使用的就是40字节，系统分配的要是16的整数倍，所以是48，为什么是16的整数倍呢，具体可以看最新的oc源码

//@property (nonatomic) char c1;
//@property (nonatomic) char c2;

@end

@implementation HXPerson


@end

int main(int argc, char * argv[]) {
    NSString * appDelegateClassName;
    @autoreleasepool {
          // 内存对齐
          // 对象的内存对齐 - 来自于结构体
        HXPerson* person = [HXPerson alloc];
        person.name      = @"hanxiao";
        person.nickName  = @"hh";
        person.age       = 18;
        
        NSLog(@"%lu-%lu",class_getInstanceSize([HXPerson class]),malloc_size((__bridge const void *)(person)));
          NSLog(@"%lu-%lu",sizeof(struct1),sizeof(struct3));
        
        appDelegateClassName = NSStringFromClass([AppDelegate class]);
    }
    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}
