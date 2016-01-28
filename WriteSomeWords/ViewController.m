//
//  ViewController.m
//  WriteSomeWords
//
//  Created by admin on 16/1/28.
//  Copyright © 2016年 AlezJi. All rights reserved.
//

#import "ViewController.h"
#import "DrawSomeWords.h"
@interface ViewController ()
@property(strong,nonatomic)    DrawSomeWords *drawSomeWords;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _drawSomeWords = [[DrawSomeWords alloc]init];
    [_drawSomeWords showWordsOnView:self.view string:@"Happy New Year!"];
}

@end
