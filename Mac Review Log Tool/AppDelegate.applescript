--
--  AppDelegate.applescript
--  Mac Review Log Tool
--
--  Created by Rick McIlraith on 22/05/2019.
--  Copyright © 2019 Rick McIlraith. All rights reserved.
--

script AppDelegate
    
	property parent : class "NSObject"
    
    property button : missing value
    
    property NSColor : class "NSColor"
    
    property NSImage : class "NSImage"
    
    property createButton : class "CreateButton"

	-- IBOutlets
	property theWindow : class "NSWindow"
	
	on applicationWillFinishLaunching_(aNotification)
        -- Insert code here to initialize your application before any files are opened
	end applicationWillFinishLaunching_
	
	on applicationShouldTerminate_(sender)
		-- Insert code here to do any housekeeping before your application quits 
		return current application's NSTerminateNow
	end applicationShouldTerminate_
    
    script SetColor
        
        on changeColor(colorOption, popUpButtonOption)
            
            if popUpButtonOption is 0
                colorOption's setFillColor_(NSColor's redColor())
                colorOption's setBorderColor_(NSColor's redColor())
            else if popUpButtonOption is 1
                colorOption's setFillColor_(NSColor's orangeColor())
                colorOption's setBorderColor_(NSColor's orangeColor())
            else if popUpButtonOption is 2
                colorOption's setFillColor_(NSColor's greenColor())
                colorOption's setBorderColor_(NSColor's greenColor())
            end if
        
        end changeColor
    
    end script

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
    
    script CreatePageInstance
        
        property message : "loaded"
        
#        property colorOption : class "NSColor"
#
#        property colorList : {}

        property optionIcon : class "NSImage"
        
        property iconList : {}
        
        on create(contentView, position, tag, statusNumber, powerpointSlide)
        
            log message
            
            set statusNumber to statusNumber as integer

#            set colorOption to createButton's createColorBoxInContentView_frame_(contentView, {{96, (position - 4)}, {236, 30}})
#
#            SetColor's changeColor(colorOption, (statusNumber-1))
#
#            copy colorOption to the end of colorList

            set dropDownButton to createButton's createDropDownInContentView_frame_state_continuous_tag_slideNumber_(contentView, {{120, position}, {230, 20}}, 0, true, tag, powerpointSlide)
            
            dropDownButton's selectItemAtIndex_(statusNumber-1)

            tell dropDownButton to setTarget:me
            tell dropDownButton to setAction:"popAction:"
            
            set jumpToButton to createButton's createButtonInContentView_frame_state_continuous_title_tag_(contentView, {{10, (position-3)}, {80, 25}}, 0, true, "Slide " & powerpointSlide, powerpointSlide)
            
            tell jumpToButton to setTarget:me
            tell jumpToButton to setAction:"jumpToAction:"

            set img to NSImage's imageNamed:"blank"

            set iconImage to createButton's createIconInContentView_frame_image_(contentView, {{90, (position - 3)}, {30, 30}}, img)
            
            SetIcon's changeIcon(iconImage, statusNumber-1)
            
            copy iconImage to end of iconList

        end create

    end script
    
    on popAction_(sender)
        
        set selectedOption to sender's indexOfSelectedItem()
#        set colorOptionsList to CreatePageInstance's colorList
        set iconImageList to CreatePageInstance's iconList
        set popUpButtonNumber to sender's tag
        set slideNumber to sender's accessibilityIndex

#        set currentColorOption to item popUpButtonNumber of colorOptionsList
#
#        SetColor's changeColor(currentColorOption, selectedOption)

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

    end popAction_

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
    
    on buttonClicked_(sender)
#        tell application "Microsoft PowerPoint"
#            tell slide 1 of active presentation
#                repeat with shapeNumber from 1 to count of shapes
#                    if name of shape shapeNumber is "internalComments"
#                -- set myVariable to get name of text range of text frame of shape 1
#                        set myVariable to content of text range of text frame of shape shapeNumber
#                        display dialog myVariable
#                    end if
#                end repeat
#            end tell
#        end tell

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

end script
