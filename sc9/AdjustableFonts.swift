//
//  AdjustableFonts.swift
//  sheetcheats
//
//  Created by william donner on 9/7/14.
//  Copyright (c) 2014 william donner. All rights reserved.
//

import UIKit

public class AdjustableFonts {
    private struct factors {
        static  let XScaleFactor : CGFloat = 70//45
        static  let TextScaleFactor : CGFloat = 50
        static  let RowHeightScaleFactor : CGFloat = 1.1//1.5
    }
    
    public class func fontForTextStyle (textStyle:String ) -> UIFont  {
        return UIFont.shcPreferredFontForTextStyle(textStyle, scaleFactor: scaleF(textStyle))
    }
    public class func rowHeightForTextStyle(style:String) -> CGFloat {
        let font = AdjustableFonts.fontForTextStyle (style )
        return font.pointSize * factors.RowHeightScaleFactor
    }
    public init (callback:Selector) {
    }
    
    
    public class  func scaleFactorForTextStyle(textStyle:String) -> CGFloat {
        var h:CGFloat = 0.0
        switch textStyle {
            
        case UIFontTextStyleFootnote: h = 40
            
        case UIFontTextStyleCaption1: h = 45
        case UIFontTextStyleCaption2: h = 45
            
        case UIFontTextStyleCallout: h = 45
            
        case UIFontTextStyleBody: h = 50
            
        case UIFontTextStyleSubheadline: h = 50
        case UIFontTextStyleHeadline: h = 60
            
        case UIFontTextStyleTitle1: h = 70
        case UIFontTextStyleTitle2: h = 70
        case UIFontTextStyleTitle3: h = 70
        default: h = 40
        }
        return h / factors.TextScaleFactor
    }
    public class func verticalScaleFactorForContentSizeFactory() -> CGFloat  {
        let contentSizeString = UIApplication.sharedApplication().preferredContentSizeCategory
        var h :CGFloat = 0.0
        /// these dont match like the documents say
        
        switch contentSizeString {
        case "UICTContentSizeCategoryXS": h = 40 // h = 40
        case "UICTContentSizeCategoryS" : h = 40 // h = 44
            
            
        case "UICTContentSizeCategoryM" :h =   55//  h = 50
        case "UICTContentSizeCategoryAccessibilityM" :h = 55 //  h = 70
            
            
        case "UICTContentSizeCategoryL" :h = 65//  h = 55
        case "UICTContentSizeCategoryAccessibilityL" :h = 65 //  h = 80
            
        case "UICTContentSizeCategoryXL" : h = 75 // h = 60
        case "UICTContentSizeCategoryAccessibilityXL" :h = 75 //  h = 90
        case "UICTContentSizeCategoryXXL" :h = 75 //  h = 65
        case "UICTContentSizeCategoryAccessibilityXXL" :h = 75 //  h = 100
        case "UICTContentSizeCategoryXXXL" :h = 75 //  h = 70
        case "UICTContentSizeCategoryAccessibilityXXXL": h = 75 // h = 110
            
        default: h = 40 // no match
        print("encountered unknown content size: \(contentSizeString)")
        }
        return h / factors.XScaleFactor // compute a scalefactor // a smidgin more
    }
    
    private class func scaleF(textStyle:String) -> CGFloat {
        return AdjustableFonts.verticalScaleFactorForContentSizeFactory()
            * AdjustableFonts.scaleFactorForTextStyle(textStyle)
    }
    
    
} // end of Adjustable Fonts

private extension UIFont  {
    private class func shcPreferredFontForTextStyle(textStyle:String,scaleFactor:CGFloat) -> UIFont {
        let descriptor = UIFontDescriptor.preferredFontDescriptorWithTextStyle(textStyle)
        let pointSize = descriptor.pointSize * scaleFactor
        let font = UIFont(descriptor: descriptor, size: pointSize)
        return font
    }
}

