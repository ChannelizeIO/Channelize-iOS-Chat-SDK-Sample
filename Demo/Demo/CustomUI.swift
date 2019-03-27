//
//  CustomUI.swift
//  Demo
//
//  Created by Ashish-BigStep on 2/20/19.
//  Copyright © 2019 bigstep. All rights reserved.
//


/*
1. Tab Bar Customization
2. Customizing Conversation Screen
3. Recent Screen Customization
4. Contact Screen Customization
5. Groups List Screen Customization

 */

import Foundation
import Channelize

class CustomUi {
    
    init() {
    }
    
    
    
    public static func setUpUIVariables() {
        
        //MARK:- Variables for Text Message Bubble
        
        /*
        - incomingMessageTextColor => for setting incoming Message Text Color
        - outgoingMessageTextColor => for setting outgoing Message Text Color
        - incomingMessageFont => For Setting incoming Message Text Font
        - outgoingMessageFont => For Setting outgoing Message Text Font
        - incomingMessageEdgeInsets => For setting Edge Insets (or padding) for incoming text Message
        - outgoingMessageEdgeInsets => For setting Edge Insets (or padding) for outgoing text Message
        - quotedIncomingMessageColor => For Setting Color of Incoming quoted Message
        - quotedOutgoingMessageColor => For Setting Color of Outgoing quoted Message
        */

        // CHCustomStyles.incomingMessageTextColor = .black
        // CHCustomStyles.outgoingMessageTextColor = .white
        // CHCustomStyles.incomingMessageFont = UIFont(name: "Courier", size: 15.0)!
        // CHCustomStyles.outgoingMessageFont = UIFont(name: "Menlo-Regular", size: 15.0)!
        // CHCustomStyles.incomingMessageEdgeInsets = UIEdgeInsets(top: 10, left: 19, bottom: 10, right: 15)
        // CHCustomStyles.outgoingMessageEdgeInsets = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 19)
        // CHCustomStyles.quotedIncomingMessageColor = UIColor.blue
        // CHCustomStyles.quotedOutgoingMessageColor = UIColor.black
        
        //MARK:- Variables For Photo and Video Message Bubble
        
        /*
        - photoBubbleSize => For setting Photo message Bubble Size
        - stickerMessageSize => For setting Sticker or GIF message Bubble Size
        - gifMessageSize => For setting Sticker or GIF message Bubble Size
        - locationMessageSize => For setting Location message Bubble Size
        - videoMessageSize => For setting Video message Bubble Size
        - incomingMessageVideoIconColor => For setting video icon color on Incoming Video Message
        - outgoingMessageVideoIconColor => For setting video icon color on Outgoing Video Message
        - incomingMessagePhotoloaderColor => For setting Photo loader color for Incoming Photo Message
        - outgoingMessagePhotoLoaderColor => For setting Photo loader color for Outgoing Photo Message

        */
        // CHCustomStyles.photoBubbleSize = CGSize(width: 210, height: 136)
        // CHCustomStyles.stickerMessageSize = CGSize(width: 100, height: 100)
        // CHCustomStyles.gifMessageSize = CGSize(width: 210, height: 136)
        // CHCustomStyles.locationMessageSize = CGSize(width: 210, height: 136)
        // CHCustomStyles.videoMessageSize = CGSize(width: 210, height: 136)
        // CHCustomStyles.squarePhotoSize = CGSize(width: 210, height: 210)
        // CHCustomStyles.incomingMessageVideoIconColor = UIColor.red
        // CHCustomStyles.outgoingMessageVideoIconColor = UIColor.green
        // CHCustomStyles.incomingMessagePhotoloaderColor = UIColor.red
        // CHCustomStyles.outgoingMessagePhotoLoaderColor = UIColor.green
        
        
        //MARK:- Varibles For Base Message Bubble
        
        /*
        - baseMessageIncomingBackgroundColor => For Setting background color of Incoming Message
        - baseMessageOutgoingBackgroundColor => For Setting background color of Outgoing Message
        - messageDateSeperatorColor => For setting color of Date Seperator Message
        - messadeDateSeparatorFont => For Setting Font for Date Seperator Message
        */

        //CHCustomStyles.baseMessageIncomingBackgroundColor = UIColor.lightGray
        //CHCustomStyles.baseMessageOutgoingBackgroundColor = appDefaultColor
        //CHCustomStyles.messageDateSeperatorColor = UIColor.darkGray
        //CHCustomStyles.messadeDateSeparatorFont = UIFont.systemFont(ofSize: 12)
        
        //MARK:- Variables for Recent Message Screen Customization
        
        /*
        VariableName => For setting ... On Recent Screen or Messages List Screen
        - recentScreenNameLabelFont => User Name or GroupName
        - recentScreenNameLabelColor => UserName or Group Name Color
        - recentScreenMessageLabelColor => Message Color
        - recentScreenTimeLabelFont => Message Font
        - recentScreenTimeLabelFont => Recent Message Time Font
        - recentScreenTimeLabelColor => Recent Message Time color
        - recentScreenMessageCountColor => Recent Unread Message count color
        - recentScreenMessageCountBgColor => Recent Unread Message count BG color
        - recentScreenTableBackgroundColor => Table Background Color
        - recentScreenTableCellBackgroundColor => Table Cell Background Color
        */

        // CHCustomStyles.recentScreenNameLabelFont = UIFont(name: "Courier-Bold", size: 15.0)!
        // CHCustomStyles.recentScreenNameLabelColor = UIColor.white
        // CHCustomStyles.recentScreenMessageLabelColor = UIColor.lightText
        // CHCustomStyles.recentScreenTimeLabelFont = UIFont(name: "PingFangSC-Regular", size: 12.0)!
        // CHCustomStyles.recentScreenTimeLabelColor = UIColor.lightText
        // CHCustomStyles.recentScreenMessageCountColor = UIColor.black
        // CHCustomStyles.recentScreenMessageCountBgColor = UIColor.white
        // CHCustomStyles.recentScreenTableBackgroundColor = UIColor.black
        // CHCustomStyles.recentScreenTableCellBackgroundColor = UIColor.black
        
        
        //MARK:- Variable for Groups List Screen Customization
        /*
        Variable Name => For Setting ... on Group List Scree
        - groupNameLabelColor => Group Name Color
        - groupNameLabelFont => Group Name Font
        - groupStatusLabelColor => Group Status Color
        - groupStatusLabelFont => Group Status Font
        - groupMemberCountLabelColor => Group Members Count Color
        - groupMemberCountLabelFont => Group Members Count Font
        - groupsTableBackgroundColor => Groups List Background Color
        - groupCellBackgroundColor => Groups List Cell Background Color
        - groupsTableCellShadowColor => Group Cell Shadow Color
        */

        // CHCustomStyles.groupNameLabelColor = UIColor.white
        // CHCustomStyles.groupNameLabelFont = UIFont.systemFont(ofSize: 15.0, weight: .heavy)
        // CHCustomStyles.groupStatusLabelColor = UIColor.white
        // CHCustomStyles.groupStatusLabelFont = UIFont.systemFont(ofSize: 12.0)
        // CHCustomStyles.groupMemberCountLabelColor = UIColor.white
        // CHCustomStyles.groupMemberCountLabelFont = UIFont.systemFont(ofSize: 14.0, weight: .bold)
        // CHCustomStyles.groupsTableBackgroundColor = .black
        // CHCustomStyles.groupCellBackgroundColor = .black
        // CHCustomStyles.groupsTableCellShadowColor = UIColor.white.cgColor
        
        
        
//MARK:- Variables for Contact Lists Screen Customization
/*
- contactNameLabelFont => Contact Name Font
- contactNameLabelColor => Contact Name Color
- contactTableBackgroundColor => Contacts Table BG Color
- contactsTableCellBackgroundColor => Contacts Table Cell BG Color
- contactTableSeperatorColor => Contact Table Cell seperator Color
*/
//CHCustomStyles.contactNameLabelFont = UIFont.systemFont(ofSize: 14.0, weight: .bold)//UIFont(name: "Courier-Bold", size: 15.0)!
// CHCustomStyles.contactNameLabelColor = .white
// CHCustomOptions.contactsTableCellBackgroundColor = .black
// CHCustomOptions.contactTableBackgroundColor = .black
// CHCustomOptions.contactTableSeperatorColor = .white
        
        
        
//MARK:- Variable for Setting Up Tabbar Controllers titles and images
/* Note ->
    - If you are setting Custom Tab bar image then you also have to set selectedTabBar Image or you can assign nil to selectedImage
*/
/*
- showTabNames => To show tabs Names with Image or Not
- recentScreenTabImage => Recent Messages Screen Tab Image
- recentScreenSelectedTabImage => Recent Message Screen Tab Image when it is Tapped or Selected
- contactScreenTabImage => Contact Screen Tab Image
- contactScreenSelectedTabImage => Contact Screen Tab Image When it is Tapped or Selected
- groupsScreenTabImage => Groups List Screen Tab Image
- groupsScreenSelectedTabImage => Groups Screen tab Image When it is Tapped or Selected
- settingsScreenTabImage => Settings Screen Tab Image
- settingsScreenSelectedTabImage => Settings Screen Tab Image When it is Selected or Tapped

- tabBarBgColor => Tab Bar Background Color
- tabBarTintColor => Tab Bar Tint Color i.e It is used to color text and image of Selected Tab item
- isTabBarSolid => Is Tab Bar Background Solid or translucent
- tabBarItemTextColor => Text Color for Tab Items Text
- tabBarItemImageColor => Image Color for unselected Tab items Images. Useful if your images are not originally in color in which you want


*/
// CHCustomStyles.showTabNames = true
// CHCustomStyles.recentScreenTabImage = UIImage(named: "recent22")//getImage("recent22")//
// CHCustomStyles.recentScreenSelectedTabImage = nil
// CHCustomStyles.contactScreenTabImage = UIImage(named: "contacts")
// CHCustomStyles.contactScreenSelectedTabImage = nil
// CHCustomStyles.groupsScreenTabImage = UIImage(named: "groups")
// CHCustomStyles.groupsScreenSelectedTabImage = nil
// CHCustomStyles.settingsScreenTabImage = UIImage(named: "settings")
// CHCustomStyles.settingsScreenSelectedTabImage = nil
// CHCustomStyles.tabBarBgColor = UIColor(hex: "#48c6ef")
// CHCustomStyles.tabBarTintColor = .white
// CHCustomStyles.isTabBarSolid = true
// CHCustomStyles.tabBarItemTextColor = .black
// CHCustomStyles.tabBarItemImageColor = .black
        
        //MARK:- Variable to change Contact Screen UI
        
        /*
        - enableAttachments => Allow or not allow attachments in Conversation Screen
        - enableAudioMessages => Allow or not Sending Audio Messages
        - enableImageMessages => Allow or not Sending Images
        - enableVideoMessages => Allow or not Sending Video Messages
        - enableLocationMessages => Allow or not Sending Location Messages
        - enableStickerAndGifMessages => Allow or not sending GIF and Sticker Messages
        */
        
        //MARK:- Variables for Chat Screens
         CHCustomOptions.enableAttachments = true
         CHCustomOptions.enableAudioMessages = true
         CHCustomOptions.enableImageMessages = true
         CHCustomOptions.enableVideoMessages = true
         CHCustomOptions.enableLocationMessages = true
         CHCustomOptions.enableStickerAndGifMessages = true
        
        /*
        - maximumVideoSize => Maximum Video Size in MB
        - maximumAudioSize => Maximum Audio Size in MB
        - maximumImageSize => Maximum Image Size in MB
        */

        //MARK:- Variables for Attachments Size In MB
         CHCustomOptions.maximumVideoSize = 25.0
         CHCustomOptions.maximumAudioSize = 25.0
         CHCustomOptions.maximumImageSize = 100.0
        
        
        /*
        - enableQuoteMessage => Allow Quoted Messages
        - enableUserLastSeen => Show User Last Seen Status
        - enableUserOnlineStatus => Show User Online Status on Conversation Screen
        - showMemberCountInHeader => Show Members Count In Group Header.
        */

        //MARK:- Variables for Conversation Screen
         //CHCustomOptions.enableQuoteMessage = false
         CHCustomOptions.enableUserLastSeen = true
         CHCustomOptions.enableUserOnlineStatus = false
         CHCustomOptions.showMemberCountInHeader = false
        
        //MARK:- Other Global Functionality
        // CHCustomOptions.allowSearching = false
    }
    
    static func getImage(_ name: String) -> UIImage? {
        let bundle = Bundle.init(identifier: "com.channelize.demo")
        return UIImage(named: name, in: bundle, compatibleWith: nil)
    }
    
}



