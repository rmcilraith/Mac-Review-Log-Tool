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
    property externalCommentsTextField : missing value
    property testTextField : missing value
	
	on applicationWillFinishLaunching_(aNotification)
       log aNotification's object()
        -- Insert code here to initialize your application before any files are opened
	end applicationWillFinishLaunching_
	
	on applicationShouldTerminate_(sender)
		-- Insert code here to do any housekeeping before your application quits 
		return current application's NSTerminateNow
	end applicationShouldTerminate_
    
    -- Change the icon associated to the status of the amend
    script SetIcon
        
        on changeIcon(optionIcon, popUpButtonOption)
            
            set cone to NSImage's imageNamed:"support"
            set exclamation to NSImage's imageNamed:"exclamationo"
            set hourglass to NSImage's imageNamed:"hourglass"
            set tickBlue to NSImage's imageNamed:"tick_light_blue"
            set tickGreen to NSImage's imageNamed:"accept_button"

            if popUpButtonOption is 0
                optionIcon's setImage:exclamation
            else if popUpButtonOption is 1
                optionIcon's setImage:cone
            else if popUpButtonOption is 2
                optionIcon's setImage:hourglass
            else if popUpButtonOption is 3
                optionIcon's setImage:tickBlue
            else if popUpButtonOption is 4
                optionIcon's setImage:tickGreen
            end if
        
        end changeIcon

    end script

    -- Create a row of items: Jump to button, icon, status drop down, edit comment
    script CreatePageInstance
        
        property message : "loaded"

        property optionIcon : class "NSImage"
        
        property iconList : {}
        property dropDownList : {}
        property checkboxList : {}
        
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
            
            -- Store drop downs in a list so can be referenced in QAd checkbox action
            copy dropDownButton to end of dropDownList

            tell dropDownButton to setTarget:me
            tell dropDownButton to setAction:"dropDownAction:"
            
            set editCommentButton to createButton's createButtonInContentView_frame_state_continuous_title_tag_(contentView, {{350, (position-3)}, {120, 25}}, 0, true, "Edit comment", powerpointSlide)
            
            tell editCommentButton to setTarget:me
            tell editCommentButton to setAction:"editCommentAction:"
            
            set QAdButton to createButton's createButtonInContentView_frame_state_continuous_title_tag_(contentView, {{470, (position-3)}, {80, 25}}, 0, true, "QA'd", tag)
            
            -- Set button type to 'switch' (enum case 3)
            QAdButton's setButtonType:3
            
            copy QAdButton to end of checkboxList
            
            if statusNumber < 4
                QAdButton's setEnabled:false
            end if
            
            tell QAdButton to setTarget:me
            tell QAdButton to setAction:"QAdAction:"
            
            set timeTextField to createButton's createTextFieldInContentView_frame_del_(contentView, {{525, (position-3)}, {40, 25}}, me)
            
            tell timeTextField to setTarget:me
            tell timeTextField to setAction:"timeTextFieldAction:"

        end create

    end script

    on controlTextDidEndEditing_(aNotification)

        log "Hola"
        log aNotification's object

    end controlTextDidEndEditing_

    on timeTextFieldAction_(sender)
        
        log "bueno"
        
    end timeTextFieldAction_

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
        set listofCheckboxes to CreatePageInstance's checkboxList
        set popUpButtonNumber to sender's tag
        set slideNumber to sender's accessibilityIndex

        set currentImageIcon to item popUpButtonNumber of iconImageList
        set currentCheckbox to item popUpButtonNumber of listofCheckboxes
        
        log selectedOption
        
        if selectedOption < 3
            currentCheckbox's setEnabled:false
        else if selectedOption <= 3
            currentCheckbox's setEnabled:true
        end if

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
                        set currentInternalComment to content of text range of text frame of shape shapeNumber
                    else if name of shape shapeNumber is "externalComments"
                        set currentExternalComment to content of text range of text frame of shape shapeNumber
                    end if
                end repeat
            end tell
        end tell

        tell me to activate
        commentsWindow's makeKeyAndOrderFront_(me)

        -- Set the text field content to what is currently in the powerpoint
        internalCommentsTextField's setString:currentInternalComment
        externalCommentsTextField's setString:currentExternalComment

        -- 'button' is a property of the script used by most buttons - including the save button in the comments window, this is set here to be referenced in the save button's action handler
        button's setTag:slideNumber

    end editCommentAction_

    on QAdAction_(sender)
        
        set listofDropDowns to CreatePageInstance's dropDownList
        set chosenCheckBox to sender's tag as integer
        set itemChosen to item chosenCheckBox of listofDropDowns
        set buttonState to sender's state as integer
        
        set iconImageList to CreatePageInstance's iconList
        set currentImageIcon to item chosenCheckBox of iconImageList
        
        if (buttonState = 0)
            itemChosen's setEnabled:true
            SetIcon's changeIcon(currentImageIcon, 3)
        else if (buttonState = 1)
            itemChosen's setEnabled:false
            SetIcon's changeIcon(currentImageIcon, 4)
        end if

    end QAdAction_

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
        
        set internalCommentsTextStorage to internalCommentsTextField's textStorage()
        set internalCommentText to internalCommentsTextStorage's |string|()
        
        set currentInternalCommentText to internalCommentText as string
        
        set externalCommentsTextStorage to externalCommentsTextField's textStorage()
        set externalCommentText to externalCommentsTextStorage's |string|()
        
        set currentExternalCommentText to externalCommentText as string
        
        tell application "Microsoft PowerPoint"
            tell active presentation
                tell slide slideNumber
                    repeat with shapeNumber from 1 to count of shapes
                        if name of shape shapeNumber is "internalComments"
                            set content of text range of text frame of shape shapeNumber to currentInternalCommentText
                        else if name of shape shapeNumber is "externalComments"
                            set content of text range of text frame of shape shapeNumber to currentExternalCommentText
                        end if
                    end repeat
                end tell
            end tell
        end tell
        
    end saveButtonClicked_

end script
