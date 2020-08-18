//
//  Shifter.m
//  MiddleWare
//
//  Created by 심규창 on 2017. 10. 24..
//  Copyright © 2017년 심규창. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MiddleWare/MiddleWare-Swift.h"
#import "Shifter.h"

short Shifter(short data, int len){
    short tmp = data << len;
    return tmp;
}

int FourShifter(uint8_t data1, uint8_t data2, uint8_t data3, uint8_t data4){
    short tmpShort[4];
    int tmpIntVal = 0;
    tmpShort[0] = (short) (data1 & 0xff);
    tmpShort[1] = (short) (data2 & 0xff);
    tmpShort[2] = (short) (data3 & 0xff);
    tmpShort[3] = (short) (data4 & 0xff);
    
    tmpIntVal = (tmpShort[0]) | (tmpShort[1] << 8) | (tmpShort[2] << 16) | (tmpShort[3] << 24);
    return tmpIntVal;
}


int getTimeShifter1(uint8_t data) {
    int retCal = 0;
    retCal = (data & 0x000000ff);
    return retCal;
}
int getTimeShifter2(uint8_t data) {
    int retCal = 0;
    retCal = ((data << 8) & 0x0000ff00);
    return retCal;
}
int getTimeShifter3(uint8_t data) {
    int retCal = 0;
    retCal = ((data << 16) & 0x00ff0000);
    return retCal;
}
int getTimeShifter4(uint8_t data) {
    int retCal = 0;
    retCal = ((data << 24) & 0xff000000);
    return retCal;
}
