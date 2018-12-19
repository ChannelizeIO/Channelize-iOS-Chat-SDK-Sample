//
//  PMStyle.swift
//  PMDemo
//
//  Created by Ashish on 08/06/18.
//  Copyright © 2018 bigstep. All rights reserved.
//
import UIKit


let defaultColor = UIColor(hex: "#1761b6")
let textColorPrimary = UIColor.white
let textColorSecondary = UIColor.gray
let textColorGray = UIColor.gray
let textColorlightGray = UIColor.lightGray
let textColorDarkGray = UIColor.darkGray

let lightestGray = #colorLiteral(red: 0.8370911593, green: 0.8370911593, blue: 0.8370911593, alpha: 1)
let lightWhite = #colorLiteral(red: 0.9617499528, green: 0.9644187176, blue: 0.9636579983, alpha: 1)
let dividerColor =  UIColor(white: 0.5, alpha: 0.5)

let onlineStatusColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
let offlineStatusColor = textColorlightGray
let awayStatusColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)

let smallFontSize:CGFloat = 11.0
let normalFontSize:CGFloat = 12.0
let mediumFontSize:CGFloat = 13.0
let largeFontSize:CGFloat = 15.0
let extraLargeFontSize:CGFloat = 17.0

let recentMessageCellHeight:CGFloat = 50.0


func getImage(_ name: String, aClass: AnyClass) -> UIImage? {
    let bundle = Bundle(for: aClass)
    return UIImage(named: name, in: bundle, compatibleWith: nil)
}

let SelectedThemeKey = "SelecteTheme"

enum Theme: Int {
    case normal, dark, graphical
    
    var mainColor: UIColor {
        switch self {
        case .normal:
            return defaultColor
        case .dark:
            return UIColor.white
        case .graphical:
            return UIColor(red: 10.0/255.0, green: 10.0/255.0, blue: 10.0/255.0, alpha: 1.0)
        }
        
    }
    
    var barStyle: UIBarStyle {
        switch self {
        case .normal, .graphical:
            return .default
        case .dark:
            return .black
        }
    }
    
    var barColor: UIColor {
        switch self {
        case .normal:
            return defaultColor
        case .dark:
            return UIColor.white
        case .graphical:
            return UIColor(red: 0, green: 134/255, blue: 249/255, alpha: 1)
            
        }
    }
    
    var navigationBackgroundImage: UIImage? {
        return self == .graphical ? getImage("navBackground", aClass: type(of: self) as! AnyClass) : nil
    }
    
    var tabBarBackgroundImage: UIImage? {
        return self == .graphical ? getImage("tabBarBackground", aClass: type(of: self) as! AnyClass): nil
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .normal, .graphical:
            return .white
        case .dark:
            return defaultColor
        }
    }
    
    var secondaryColor: UIColor {
        switch self {
        case .normal:
            return defaultColor
        case .dark:
            return UIColor.white
        case .graphical:
            return UIColor(red: 140.0/255.0, green: 50.0/255.0, blue: 48.0/255.0, alpha: 1.0)
        }
    }
}

struct ThemeManager {
    
    static func currentTheme() -> Theme {
        UserDefaults.standard.value(forKeyPath: SelectedThemeKey)
        if let storedTheme = (UserDefaults.standard.value(forKey: SelectedThemeKey) as AnyObject).integerValue {
            return Theme(rawValue: storedTheme)!
        } else {
            return .normal
        }
    }
    
    static func applyTheme(theme: Theme) {
        
        UserDefaults.standard.set(theme.rawValue, forKey: SelectedThemeKey)
        UserDefaults.standard.synchronize()
        
        let sharedApplication = UIApplication.shared
        sharedApplication.delegate?.window??.tintColor = theme.mainColor
        
        
        UINavigationBar.appearance().barStyle = theme.barStyle
        
        UINavigationBar.appearance().barTintColor = theme.backgroundColor
        UINavigationBar.appearance().tintColor = theme.barColor
        UITabBar.appearance().tintColor = theme.mainColor
        UITabBar.appearance().barTintColor = theme.backgroundColor
        //UISwitch.appearance().onTintColor = theme.mainColor.withAlphaComponent(0.3)
        //UISwitch.appearance().thumbTintColor = theme.mainColor
        
        
    }
    
}
