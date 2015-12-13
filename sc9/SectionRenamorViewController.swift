//
//  SectionRenamorViewController.swift
//  sc9
//
//  Created by bill donner on 12/10/15.
//  Copyright © 2015 shovelreadyapps. All rights reserved.
//

import UIKit

class SectionRenamorViewController: UIViewController, ModelData {
    var sectionNum: Int? // property
    @IBOutlet weak var currentSectionLabel: UILabel!

    @IBOutlet weak var newSectionHeaderField: UITextField!
    
    
    @IBAction func inputEnded(sender: AnyObject) {
        print("Input did end with \(newSectionHeaderField.text)")
        self.renameSectHeader(self.sectionNum!,headerTitle:newSectionHeaderField.text!)
        Globals.saveDataModel()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let sn = self.sectionNum  else {
            fatalError("needs property for sectionNum")
        }
        let sh = self.sectHeader(sn)
        currentSectionLabel.text = sh[SectionProperties.NameKey]
    }

}
