//
//  dataRequest.h
//  QuantumNews
//
//  Created by wangxinyan on 15/12/4.
//  Copyright (c) 2015年 longjiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface dataRequest : NSObject
@property(assign,nonatomic)int fid;
@property(strong,nonatomic)NSString *titles;
@property(strong,nonatomic)NSString *descriptions;
@property(strong,nonatomic)NSString *TopImage;
@property(strong,nonatomic)NSString *url;
@end
