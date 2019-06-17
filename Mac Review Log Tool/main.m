//
//  main.m
//  Mac Review Log Tool
//
//  Created by Richard McIlraith on 22/05/2019.
//  Copyright © 2019 Rick McIlraith. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <AppleScriptObjC/AppleScriptObjC.h>
#import "createButton.h"

int main(int argc, const char * argv[]) {
    [[NSBundle mainBundle] loadAppleScriptObjectiveCScripts];
    return NSApplicationMain(argc, argv);
}
