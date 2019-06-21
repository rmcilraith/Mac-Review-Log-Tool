--
--  AppDelegate.applescript
--  Mac Review Log Tool
--
--  Created by Rick McIlraith on 22/05/2019.
--  Copyright © 2019 Rick McIlraith. All rights reserved.
--
--  Visual design specific version of the Review Log tool with just the design tab content from the main Review Log tool

-- Top level script that houses the entire application
script AppDelegate
    
	property parent : class "NSObject"
    property createButton : class "CreateButton"
    property NSImage : class "NSImage"
    property button : missing value
	property theWindow : missing value
    property commentsWindow : missing value
    property internalCommentsTextField : missing value
	
	on applicationWillFinishLaunching_(aNotification)
        -- Insert code here to initialize your application before any files are opened
	end applicationWillFinishLaunching_
	
	on applicationShouldTerminate_(sender)
		-- Insert code here to do any housekeeping before your application quits 
		return current application's NSTerminateNow
	end applicationShouldTerminate_
    
    -- Change the icon associated to the status of the amend
    script SetIcon
        
        on changeIcon(optionIcon, popUpButtonOption)
            
            set cross to NSImage's imageNamed:"cross"
            set exclamation to NSImage's imageNamed:"exclamation"
            set tick to NSImage's imageNamed:"tick"
            
            if popUpButtonOption is 0
                optionIcon's setImage:cross
            else if popUpButtonOption is 1
                optionIcon's setImage:exclamation
            else if popUpButtonOption is 2
                optionIcon's setImage:tick
            end if
        
        end changeIcon

    end script

    -- Create a row of items: Jump to button, icon, status drop down, edit comment
    script CreatePageInstance
        
        property message : "loaded"

        property optionIcon : class "NSImage"
        
        property iconList : {}
        
        on create(contentView, position, tag, statusNumber, powerpointSlide)
        
            log message
            
            set statusNumber to statusNumber as integer
            
            set jumpToButton to createButton's createButtonInContentView_frame_state_continuous_title_tag_(contentView, {{10, (position-3)}, {80, 25}}, 0, true, "Slide " & powerpointSlide, powerpointSlide)
            
            tell jumpToButton to setTarget:me
            tell jumpToButton to setAction:"jumpToAction:"
            
            set iconImage to createButton's createIconInContentView_frame_(contentView, {{90, (position - 3)}, {30, 30}})
            
            -- Set initial icon state
            SetIcon's changeIcon(iconImage, statusNumber-1)
            
            -- Store icons in a list so can be referenced in status drop down action
            copy iconImage to end of iconList
            
            set dropDownButton to createButton's createDropDownInContentView_frame_state_continuous_tag_slideNumber_(contentView, {{120, position}, {230, 20}}, 0, true, tag, powerpointSlide)
            
            -- Set status drop down initial selected item
            dropDownButton's selectItemAtIndex_(statusNumber-1)

            tell dropDownButton to setTarget:me
            tell dropDownButton to setAction:"dropDownAction:"
            
            set editCommentButton to createButton's createButtonInContentView_frame_state_continuous_title_tag_(contentView, {{350, (position-3)}, {120, 25}}, 0, true, "Edit comment", powerpointSlide)
            
            tell editCommentButton to setTarget:me
            tell editCommentButton to setAction:"editCommentAction:"

        end create

    end script

    on jumpToAction_(sender)
        
        set slideNumber to sender's tag
        set intSlideNumber to slideNumber as integer
        
        tell application "Microsoft PowerPoint"
            tell active presentation
                set theView to view of document window 1
                go to slide theView number intSlideNumber
            end tell
        end tell
        
    end jumpToAction_
    
    on dropDownAction_(sender)
        
        set selectedOption to sender's indexOfSelectedItem()
        set iconImageList to CreatePageInstance's iconList
        set popUpButtonNumber to sender's tag
        set slideNumber to sender's accessibilityIndex

        set currentImageIcon to item popUpButtonNumber of iconImageList

        SetIcon's changeIcon(currentImageIcon, selectedOption)

        set intSlideNumber to slideNumber as integer

        tell application "Microsoft PowerPoint"
            tell active presentation
                tell slide intSlideNumber
                    repeat with shapeNumber from 1 to count of shapes
                        if name of shape shapeNumber is "hiddenInfo"
                            set content of text range of text frame of shape shapeNumber to (selectedOption + 1)
                        end if
                    end repeat
                end tell
            end tell
        end tell

    end dropDownAction_

    on editCommentAction_(sender)
        
        set slideNumber to sender's tag as integer

        tell application "Microsoft PowerPoint"
            tell slide slideNumber of active presentation
                repeat with shapeNumber from 1 to count of shapes
                    if name of shape shapeNumber is "internalComments"
                        set currentComment to content of text range of text frame of shape shapeNumber
                    end if
                end repeat
            end tell
        end tell

        tell me to activate
        commentsWindow's makeKeyAndOrderFront_(me)

        -- Set the text field content to what is currently in the powerpoint
        internalCommentsTextField's setString:currentComment

        -- 'button' is a property of the script used by most buttons - including the save button in the comments window, this is set here to be referenced in the save button's action handler
        button's setTag:slideNumber

    end editCommentAction_

    on buttonClicked_(sender)
        
# Use this button for testing

    end buttonClicked_

    on newButtonClicked_(sender)
        
        set contentView to contentView of theWindow
        set aPosition to 500
        set aTag to 1
        
        tell application "Microsoft PowerPoint"
            tell active presentation
                set theSlideCount to (count of slides)
                repeat with slideNumber from 1 to theSlideCount
                    tell slide slideNumber
                        repeat with shapeNumber from 1 to count of shapes
                            if name of shape shapeNumber is "hiddenInfo"
                                set statusNumber to content of text range of text frame of shape shapeNumber
                                if statusNumber does not equal "0"
                                    CreatePageInstance's create(contentView, aPosition, aTag, statusNumber, slideNumber)
                                    set aPosition to (aPosition - 35)
                                    set aTag to (aTag + 1)
                                end if
                            end if
                        end repeat
                    end tell
                end repeat
            end tell
        end tell

-- Remove a button
#        button's removeFromSuperview()

    end newButtonClicked_

    on saveButtonClicked_(sender)
        
        set slideNumber to sender's tag as integer
        
        set textStorage to internalCommentsTextField's textStorage()
        set theText to textStorage's |string|()
        
        set currentText to theText as string
        
        tell application "Microsoft PowerPoint"
            tell active presentation
                tell slide slideNumber
                    repeat with shapeNumber from 1 to count of shapes
                        if name of shape shapeNumber is "internalComments"
                            set content of text range of text frame of shape shapeNumber to currentText
                        end if
                    end repeat
                end tell
            end tell
        end tell
        
    end saveButtonClicked_

end script
