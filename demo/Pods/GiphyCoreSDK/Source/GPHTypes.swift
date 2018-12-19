//
//  GPHTypes.swift
//  GiphyCoreSDK
//
//  Created by Cem Kozinoglu, Gene Goykhman, Giorgia Marenda on 4/24/17.
//  Copyright © 2017 Giphy. All rights reserved.
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.
//

import Foundation


/// Represents a Giphy Object Type (GIF/Sticker/...)
///
@objc public enum GPHMediaType: Int, RawRepresentable {
    /// We use Int, RawRepresentable to be able to bridge btw ObjC<>Swift without losing String values.
    
    /// Gif Media Type
    case gif
    
    /// Sticker Media Type
    case sticker
    
    public typealias RawValue = String
    
    public var rawValue: RawValue {
        switch self {
        case .gif:
            return "gif"
        case .sticker:
            return "sticker"
        }
    }
    
    public init?(rawValue: RawValue) {
        switch rawValue.lowercased() {
        case "gif":
            self = .gif
        case "sticker":
            self = .sticker
        default:
            self = .gif
        }
    }
    
}

/// Represents a Giphy Rendition Type (Original/Preview/...)
///
@objc public enum GPHRenditionType: Int, RawRepresentable {
    /// We use Int, RawRepresentable to be able to bridge btw ObjC<>Swift without losing String values.
    
    /// Original file size and file dimensions. Good for desktop use.
    case original
    
    /// Preview image for original.
    case originalStill
    
    /// File size under 50kb. Duration may be truncated to meet file size requirements. Good for thumbnails and previews.
    case preview
    
    /// Duration set to loop for 15 seconds. Only recommended for this exact use case.
    case looping
    
    /// Height set to 200px. Good for mobile use.
    case fixedHeight
    
    /// Static preview image for fixed_height
    case fixedHeightStill
    
    /// Height set to 200px. Reduced to 6 frames to minimize file size to the lowest.
    /// Works well for unlimited scroll on mobile and as animated previews. See Giphy.com on mobile web as an example.
    case fixedHeightDownsampled
    
    /// Height set to 100px. Good for mobile keyboards.
    case fixedHeightSmall
    
    /// Static preview image for fixed_height_small
    case fixedHeightSmallStill
    
    /// Width set to 200px. Good for mobile use.
    case fixedWidth
    
    /// Static preview image for fixed_width
    case fixedWidthStill
    
    /// Width set to 200px. Reduced to 6 frames. Works well for unlimited scroll on mobile and as animated previews.
    case fixedWidthDownsampled
    
    /// Width set to 100px. Good for mobile keyboards.
    case fixedWidthSmall
    
    /// Static preview image for fixed_width_small
    case fixedWidthSmallStill
    
    /// File size under 2mb.
    case downsized
    
    /// File size under 200kb.
    case downsizedSmall
    
    /// File size under 5mb.
    case downsizedMedium
    
    /// File size under 8mb.
    case downsizedLarge
    
    /// Static preview image for downsized.
    case downsizedStill
    
    
    public typealias RawValue = String
    
    public var rawValue: RawValue {
        switch self {
        case .original:
            return "original"
        case .originalStill:
            return "original_still"
        case .preview:
            return "preview"
        case .looping:
            return "looping"
        case .fixedHeight:
            return "fixed_height"
        case .fixedHeightStill:
            return "fixed_height_still"
        case .fixedHeightDownsampled:
            return "fixed_height_downsampled"
        case .fixedHeightSmall:
            return "fixed_height_small"
        case .fixedHeightSmallStill:
            return "fixed_height_small_still"
        case .fixedWidth:
            return "fixed_width"
        case .fixedWidthStill:
            return "fixed_width_still"
        case .fixedWidthDownsampled:
            return "fixed_width_downsampled"
        case .fixedWidthSmall:
            return "fixed_width_small"
        case .fixedWidthSmallStill:
            return "fixed_width_small_still"
        case .downsized:
            return "downsized"
        case .downsizedSmall:
            return "downsized_small"
        case .downsizedMedium:
            return "downsized_medium"
        case .downsizedLarge:
            return "downsized_large"
        case .downsizedStill:
            return "downsized_still"
        }
    }
    
    public init?(rawValue: RawValue) {
        switch rawValue.lowercased() {
            
        case "original":
            self = .original
        case "original_still":
            self = .originalStill
        case "preview":
            self = .preview
        case "looping":
            self = .looping
        case "fixed_height":
            self = .fixedHeight
        case "fixed_height_still":
            self = .fixedHeightStill
        case "fixed_height_downsampled":
            self = .fixedHeightDownsampled
        case "fixed_height_small":
            self = .fixedHeightSmall
        case "fixed_height_small_still":
            self = .fixedHeightSmallStill
        case "fixed_width":
            self = .fixedWidth
        case "fixed_width_still":
            self = .fixedWidthStill
        case "fixed_width_downsampled":
            self = .fixedWidthDownsampled
        case "fixed_width_small":
            self = .fixedWidthSmall
        case "fixed_width_small_still":
            self = .fixedWidthSmallStill
        case "downsized":
            self = .downsized
        case "downsized_small":
            self = .downsizedSmall
        case "downsized_medium":
            self = .downsizedMedium
        case "downsized_large":
            self = .downsizedLarge
        case "downsized_still":
            self = .downsizedStill
            
        default:
            self = .original
        }
    }
}


/// Represents Giphy APIs Supported Languages
///
@objc public enum GPHLanguageType: Int, RawRepresentable {
    /// We use Int, RawRepresentable to be able to bridge btw ObjC<>Swift without loosing String values.
    
    /// English (en)
    case english
    
    /// Spanish (es)
    case spanish
    
    /// Portuguese (pt)
    case portuguese
    
    /// Indonesian (id)
    case indonesian
    
    /// French (fr)
    case french
    
    /// Arabic (ar)
    case arabic
    
    /// Turkish (tr)
    case turkish
    
    /// Thai (th)
    case thai
    
    /// Vietnamese (vi)
    case vietnamese
    
    /// German (de)
    case german
    
    /// Italian (it)
    case italian
    
    /// Japanese (ja)
    case japanese
    
    /// Chinese Simplified (zh-cn)
    case chineseSimplified
    
    /// Chinese Traditional (zh-tw)
    case chineseTraditional
    
    /// Russian (ru)
    case russian
    
    /// Korean (ko)
    case korean
    
    /// Polish (pl)
    case polish
    
    /// Dutch (nl)
    case dutch
    
    /// Romanian (ro)
    case romanian
    
    /// Hungarian (hu)
    case hungarian
    
    /// Swedish (sv)
    case swedish
    
    /// Czech (cs)
    case czech
    
    /// Hindi (hi)
    case hindi
    
    /// Bengali (bn)
    case bengali
    
    /// Danish (da)
    case danish
    
    /// Farsi (fa)
    case farsi
    
    /// Filipino (tl)
    case filipino
    
    /// Finnish (fi)
    case finnish
    
    /// Hebrew (iw)
    case hebrew
    
    /// Malay (ms)
    case malay
    
    /// Norwegian (no)
    case norwegian
    
    /// Ukrainian (uk)
    case ukrainian
    
    public typealias RawValue = String
    
    public var rawValue: RawValue {
        switch self {
        case .english:
            return "en"
        case .spanish:
            return "es"
        case .portuguese:
            return "pt"
        case .indonesian:
            return "id"
        case .french:
            return "fr"
        case .arabic:
            return "ar"
        case .turkish:
            return "tr"
        case .thai:
            return "th"
        case .vietnamese:
            return "vi"
        case .german:
            return "de"
        case .italian:
            return "it"
        case .japanese:
            return "ja"
        case .chineseSimplified:
            return "zh-cn"
        case .chineseTraditional:
            return "zh-tw"
        case .russian:
            return "ru"
        case .korean:
            return "ko"
        case .polish:
            return "pl"
        case .dutch:
            return "nl"
        case .romanian:
            return "ro"
        case .hungarian:
            return "hu"
        case .swedish:
            return "sv"
        case .czech:
            return "cs"
        case .hindi:
            return "hi"
        case .bengali:
            return "bn"
        case .danish:
            return "da"
        case .farsi:
            return "fa"
        case .filipino:
            return "tl"
        case .finnish:
            return "fi"
        case .hebrew:
            return "iw"
        case .malay:
            return "ms"
        case .norwegian:
            return "no"
        case .ukrainian:
            return "uk"
        }
    }
    
    public init?(rawValue: RawValue) {
        switch rawValue.lowercased() {
            
        case "en":
            self = .english
        case "es":
            self = .spanish
        case "pt":
            self = .portuguese
        case "id":
            self = .indonesian
        case "fr":
            self = .french
        case "ar":
            self = .arabic
        case "tr":
            self = .turkish
        case "th":
            self = .thai
        case "vi":
            self = .vietnamese
        case "de":
            self = .german
        case "it":
            self = .italian
        case "ja":
            self = .japanese
        case "zh-cn":
            self = .chineseSimplified
        case "zh-tw":
            self = .chineseTraditional
        case "ru":
            self = .russian
        case "ko":
            self = .korean
        case "pl":
            self = .polish
        case "nl":
            self = .dutch
        case "ro":
            self = .romanian
        case "hu":
            self = .hungarian
        case "sv":
            self = .swedish
        case "cs":
            self = .czech
        case "hi":
            self = .hindi
        case "bn":
            self = .bengali
        case "da":
            self = .danish
        case "fa":
            self = .farsi
        case "tl":
            self = .filipino
        case "fi":
            self = .finnish
        case "iw":
            self = .hebrew
        case "ms":
            self = .malay
        case "no":
            self = .norwegian
        case "uk":
            self = .ukrainian
        default:
            self = .english
        }
    }
}


/// Represents content rating (y,g, pg, pg-13 or r)
///
@objc public enum GPHRatingType: Int, RawRepresentable {
    /// We use Int, RawRepresentable to be able to bridge btw ObjC<>Swift without loosing String values.
    
    /// Rated Y
    case ratedY
    
    /// Rated G
    case ratedG
    
    /// Rated PG
    case ratedPG
    
    /// Rated PG-13
    case ratedPG13
    
    /// Rated R
    case ratedR
    
    /// Not Safe for Work
    case nsfw
    
    /// Unrated
    case unrated
    
    public typealias RawValue = String
    
    public var rawValue: RawValue {
        switch self {
        case .ratedY:
            return "y"
        case .ratedG:
            return "g"
        case .ratedPG:
            return "pg"
        case .ratedPG13:
            return "pg-13"
        case .ratedR:
            return "r"
        case .nsfw:
            return "nsfw"
        case .unrated:
            return "unrated"
        }
    }
    
    public init?(rawValue: RawValue) {
        switch rawValue.lowercased() {
        case "y":
            self = .ratedY
        case "g":
            self = .ratedG
        case "pg":
            self = .ratedPG
        case "pg-13":
            self = .ratedPG13
        case "r":
            self = .ratedR
        case "nsfw":
            self = .nsfw
        case "unrated":
            self = .unrated
        default:
            self = .ratedR
        }
    }
    
}
