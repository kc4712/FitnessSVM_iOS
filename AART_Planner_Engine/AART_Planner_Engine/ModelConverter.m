//
//  ModelConverter.m
//  AART_Planner_Engine
//
//  Created by 심규창 on 2017. 6. 9..
//  Copyright © 2017년 심규창. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AART_Planner_Engine/AART_Planner_Engine-Swift.h"
#import "ModelConverter.h"

char* Load_model1() {
    NSString *ret = [Loadmodel Loadmodel1];
    return (char *) [ret UTF8String];
}
char* Load_model2() {
    NSString *ret = [Loadmodel Loadmodel2];
    return (char *) [ret UTF8String];
}
char* Load_model3() {
    NSString *ret = [Loadmodel Loadmodel3];
    return (char *) [ret UTF8String];
}
