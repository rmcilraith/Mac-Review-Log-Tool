//
//  createButton.m
//  Mac Review Log Tool
//
//  Created by Richard McIlraith on 24/05/2019.
//  Copyright © 2019 Rick McIlraith. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <AppleScriptObjC/AppleScriptObjC.h>
#import "createButton.h"

@implementation CreateButton

+ (NSButton *)createButtonInContentView:(NSView*)contentView frame:(NSRect)inFrame state:(int)inState continuous:(BOOL)inCont title:(NSString*)title tag:(int)tag
{
    NSButton* button = [[NSButton alloc] initWithFrame:inFrame];
    [button setContinuous:inCont];
    [button setState:inState];
    [button setTitle:title];
    [button setTag:tag];
    [button setButtonType:NSButtonTypeToggle];
    [button setBezelStyle:NSBezelStyleRounded];
    
    [contentView addSubview:button];

    return button;
}
    
+ (NSPopUpButton *)createDropDownInContentView:(NSView*)contentView frame:(NSRect)inFrame state:(int)inState continuous:(BOOL)inCont tag:(int)tag slideNumber:(int)slideNumber
    {
        NSPopUpButton* popButton = [[NSPopUpButton alloc] initWithFrame:inFrame];
        [popButton setContinuous:inCont];
        [popButton addItemsWithTitles:@[@"Requires Attention",@"Amended", @"QA'd"]];
        [popButton setState:inState];
        [popButton setTag:tag];
        [popButton setAccessibilityIndex:slideNumber];
        [popButton setAutoenablesItems:NO];
        [popButton setButtonType:NSButtonTypeToggle];
        [popButton setBezelStyle:NSBezelStyleRounded];

        [contentView addSubview:popButton];
        
        return popButton;
    }
    
+ (NSBox *)createColorBoxInContentView:(NSView*)contentView frame:(NSRect)inFrame
    {
        NSBox* color = [[NSBox alloc] initWithFrame:inFrame];
        
        [contentView addSubview:color];
        [color setTitle:@""];
        [color setBoxType:NSBoxCustom];
        [color setBorderType:NSLineBorder];
        [color setBorderWidth:1];
        [color setCornerRadius:5.0];
        
        return color;
    }

+ (NSImageView *)createIconInContentView:(NSView*)contentView frame:(NSRect)inFrame image:(NSImage*)image
    {
        NSImageView* icon = [[NSImageView alloc] initWithFrame:inFrame];
        
        [contentView addSubview:icon];
        [icon setImage:image];
        
        return icon;
    }
    
@end
