//
//  Colors.swift
//

import UIKit

struct Colors {
    
    static func  mainColor() -> UIColor  {
        return Globals.shared.mainColors.count == 0 ? Colors.black : Globals.shared.mainColors[2] as! UIColor }
    static func  headerColor() -> UIColor  { return  Globals.shared.mainColors.count == 0 ? Colors.black : Globals.shared.mainColors[1] as! UIColor  }
    static func  tileColor ()-> UIColor  {  return  Globals.shared.mainColors.count == 0 ? Colors.black :  Globals.shared.mainColors[3] as! UIColor }
        static func  altTileColor ()-> UIColor  {  return  Globals.shared.mainColors.count == 0 ? Colors.black :  Globals.shared.mainColors[4] as! UIColor }
    
    static func  mainTextColor()-> UIColor  {
        return  UIColor(contrastingBlackOrWhiteColorOn:mainColor(), isFlat:true)
    }
    static func  tileTextColor()-> UIColor  {
        return  UIColor(contrastingBlackOrWhiteColorOn:tileColor(), isFlat:true)
    }
    static func headerTextColor ()-> UIColor  {
        return UIColor(contrastingBlackOrWhiteColorOn:headerColor(), isFlat:true)
    }
    
    static let drawingAlertColor = UIColor.redColor()
    static let white =  FlatWhite()
    static let black = FlatBlack()
    static let gray = UIColor.lightGrayColor().flatten()
    static let clear = UIColor.clearColor()
    
    static let allColors = [FlatBlack(), FlatBlackDark(), FlatBlue(), FlatBlueDark(), FlatBrown(), FlatBrownDark(), FlatCoffee(), FlatCoffeeDark(), FlatForestGreen(), FlatForestGreenDark(), FlatGray(), FlatGrayDark(), FlatGreen(), FlatGreenDark(), FlatLime(), FlatLimeDark(), FlatMagenta(), FlatMagentaDark(), FlatMaroon(), FlatMaroonDark(), FlatMint(), FlatMintDark(), FlatNavyBlue(), FlatNavyBlueDark(), FlatOrange(), FlatOrangeDark(), FlatPink(), FlatPinkDark(), FlatPlum(), FlatPlumDark(), FlatPowderBlue(), FlatPowderBlueDark(), FlatPurple(), FlatPurpleDark(), FlatRed(), FlatRedDark(), FlatSand(), FlatSandDark(), FlatSkyBlue(), FlatSkyBlueDark(), FlatTeal(), FlatTealDark(), FlatWatermelon(), FlatWatermelonDark(), FlatWhite(), FlatWhiteDark(), FlatYellow(), FlatYellowDark()]
    
    static let allColorNames  = ["Black", "Black Dark" , "Blue" , "Blue Dark" , "Brown" , "Brown Dark" , "Coffee" , "Coffee Dark" , "Forest Green" , "Forest Green Dark" , "Gray" , "Gray Dark" , "Green" , "Green Dark" , "Lime" , "Lime Dark" , "Magenta" , "Magenta Dark" , "Maroon" , "Maroon Dark" , "Mint" , "Mint Dark" , "Navy Blue" , "Navy Blue Dark" , "Orange" , "Orange Dark" , "Pink" , "Pink Dark" , "Plum" , "Plum Dark" , "Powder Blue" , "Powder Blue Dark" , "Purple" , "Purple Dark" , "Red" , "Red Dark" , "Sand" , "Sand Dark" , "Sky Blue" , "Sky Blue Dark" , "Teal" , "Teal Dark" , "Wmelon" , "Wmelon Dark" , "White" , "White Dark" , "Yellow" , "Yellow Dark"]
    
    static func findColorIndexByName(name:String) -> Int? {
            return allColorNames.indexOf(name)
       
    }
}