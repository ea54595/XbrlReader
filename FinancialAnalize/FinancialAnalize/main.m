//
//  main.m
//  FinancialAnalize
//
//  Created by 清水 裕紀 on 2013/09/05.
//  Copyright (c) 2013年 清水 裕紀. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import <MacRuby/MacRuby.h>

int main(int argc, char *argv[])
{
    return macruby_main("rb_main.rb", argc, argv);
}
