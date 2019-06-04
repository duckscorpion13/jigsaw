//
//  RNTBaseViewManager.m
//  RNProject
//
//  Created by DerekYang on 2018/11/6.
//  Modified by DerekYang on 2018/12/05.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import <WebKit/WebKit.h>

#import "jigsaw-Swift.h"
#import <React/RCTViewManager.h>

@interface RNTBaseManager: RCTViewManager
@end

@implementation RNTBaseManager

RCT_EXPORT_MODULE()


- (UIView *)view
{
  
  return  [RNTBase new];
  
}


RCT_EXPORT_VIEW_PROPERTY(srcUrl, NSString)


@end


