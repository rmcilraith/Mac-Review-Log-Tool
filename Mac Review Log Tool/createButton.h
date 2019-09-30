//
//  createButton.h
//  Mac Review Log Tool
//
//  Created by Richard McIlraith on 24/05/2019.
//  Copyright © 2019 Rick McIlraith. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef createButton_h
#define createButton_h

@interface CreateButton : NSObject {}
    
    + (NSButton *)createButtonInContentView:(NSView*)contentView frame:(NSRect)inFrame state:(int)inState continuous:(BOOL)inCont title:(NSString*)title tag:(int)tag;
    
    + (NSPopUpButton *)createDropDownInContentView:(NSView*)contentView frame:(NSRect)inFrame state:(int)inState continuous:(BOOL)inCont tag:(int)tag slideNumber:(int)slideNumber;
    
    + (NSBox *)createColorBoxInContentView:(NSView*)contentView frame:(NSRect)inFrame;

    + (NSImageView *)createIconInContentView:(NSView*)contentView frame:(NSRect)inFrame;

    + (NSTextField *)createTextFieldInContentView:(NSView*)contentView frame:(NSRect)inFrame del:(id<NSTextFieldDelegate>)myDelegate;
@end


#endif /* createButton_h */
