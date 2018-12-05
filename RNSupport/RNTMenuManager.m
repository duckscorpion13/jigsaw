//
//  GameViewManager.m
//  fngame
//
//  Created by DerekYang on 2018/2/27.
//  Modified by DerekYang on 2018/12/05.
//  Copyright © 2018年 Facebook. All rights reserved.
//
#import <WebKit/WebKit.h>

#import "example-Swift.h"
#import <React/RCTViewManager.h>

@interface RNTMenuManager : RCTViewManager
@end

@implementation RNTMenuManager

RCT_EXPORT_MODULE()


- (UIView *)view
{
  
  return  [RNTMenu new];

}

@end

