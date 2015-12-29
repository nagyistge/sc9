

//
//  ThemeMapperViewController
//  sc9
//
//  Created by bill donner on 12/19/15.
//  Copyright © 2015 shovelreadyapps. All rights reserved.
//

import UIKit

final class ThemeArrangerViewController: UIViewController , SegueHelpers,FontSizeAware,ModelData {
    var colorIdx: Int = 0 // property

    private var colorIndex : Int = 0
  var newColors: [UIColor] = [] // allow child to get right here
  private      var av  = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
    @IBOutlet weak var livePreview: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
      
//            if  let destv = segue.destinationViewController as? ArrangeThemeCollectionViewController {
////                destv.colorIdx = colorIndex
////                      print("starting child view controller with index \(colorIndex)")
//            }
    }
    
    func unwinder() {
        self.performSegueWithIdentifier("unwindToThemePickerID", sender: self)
    }
    @IBAction func cancel(sender: AnyObject) {
        unwinder()
    }
    
    @IBAction func use(sender: AnyObject) {
        
        publishColors(  self.colorIndex)
        self.unwindFromHere(self)// try to go back to main meu
        //self.dismissViewControllerAnimated(true, completion: nil)
        //blow out the whole infrastructure
    }
    
    func publishColors(idx:Int, sg:Int = 0) {
        
        let basecolor = Colors.allColors[idx]
        let theme = Colors.allColorNames[idx]
        
        newColors  = ColorSchemeOf(ColorScheme.Complementary, color: basecolor, isFlatScheme: true)
        
        
        // announce what we have done
        print("New colors \(newColors)")
        Globals.shared.colorTheme = theme 
        Globals.shared.mainColors = newColors
        Persistence.colorScheme = Colors.allColorNames[idx]
        NSNotificationCenter.defaultCenter().postNotificationName(kSurfaceUpdatedSignal,object:nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
 

        self.setupFontSizeAware(self)
        self.colorIndex = colorIdx
        self.av.frame = self.livePreview.frame
        self.navigationItem.title = "Mapping \(Colors.allColorNames[self.colorIndex])"
        newColors = ColorSchemeOf(ColorScheme.Complementary, color: Colors.allColors[colorIdx], isFlatScheme: true)
        
        // Do any additional setup after loading the view.
        self.view.addSubview(self.av)
        self.av.startAnimating()
      
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let preview = makePreview(self.livePreview.frame)
        self.view.addSubview(preview)
        self.av.removeFromSuperview()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //ArrangeThemeCollectionViewControllerID
    func makePreview( frame:CGRect) -> UIView {
        
        let h = frame.height
        let hh = h/10
        let tileh = 3*h/10
        
        let delta:CGFloat = 10
        
        
        let outer = UIView(frame:frame)
        outer.backgroundColor = Colors.white
        let v = UILabel(frame:CGRect(x:delta,y:delta,width:frame.width-2*delta,height:h-delta))
        v.backgroundColor = newColors[0]//
        v.textAlignment = .Right
        v.text = "background text"
        v.textColor = Colors.mainTextColor()
        
        
        var hpos :CGFloat = 0
        var ypos: CGFloat =  10
        let headerbody = UILabel(frame:CGRect(x:hpos,y:ypos,width:v.frame.width,height:hh))
        headerbody.backgroundColor = newColors[1]//Colors.headerColor()
        headerbody.text = "Header Text Goes Here"
        headerbody.textColor = UIColor(contrastingBlackOrWhiteColorOn:headerbody.backgroundColor, isFlat:true)
        v.addSubview(headerbody)
        ypos += headerbody.frame.height
        
        
        let tileA = UILabel(frame:CGRect(x:hpos,y:ypos,width:tileh,height:tileh))
        tileA.backgroundColor = newColors[2]
        tileA.textAlignment = .Center
        tileA.text = "Tune Title"
        tileA.numberOfLines = 0
        tileA.textColor = UIColor(contrastingBlackOrWhiteColorOn:tileA.backgroundColor, isFlat:true)
        v.addSubview(tileA)
        hpos += tileh+delta
        
        let tileAP = UILabel(frame:CGRect(x:hpos,y:ypos,width:tileh,height:tileh))
        tileAP.backgroundColor = newColors[2]
        tileAP.textAlignment = .Center
        tileAP.text = "Tune Fail"
        tileAP.numberOfLines = 0
        tileAP.textColor = Colors.gray //UIColor(contrastingBlackOrWhiteColorOn:tileA.backgroundColor, isFlat:true)
        v.addSubview(tileAP)
        hpos += tileh+delta
        
        let tileB = UILabel(frame:CGRect(x:hpos,y:ypos,width:tileh,height:tileh))
        tileB.backgroundColor = newColors[3]
        tileB.textAlignment = .Center
        tileB.text = "Alt Tune"
        tileB.numberOfLines = 0
        tileB.textColor = UIColor(contrastingBlackOrWhiteColorOn:tileB.backgroundColor, isFlat:true)
        v.addSubview(tileB)
        hpos += tileh+delta
        
        let tileBP = UILabel(frame:CGRect(x:hpos,y:ypos,width:tileh,height:tileh))
        tileBP.backgroundColor = newColors[3]
        tileBP.textAlignment = .Center
        tileBP.text = "Alt Fail"
        tileBP.numberOfLines = 0
        tileBP.textColor = Colors.gray //UIColor(contrastingBlackOrWhiteColorOn:tileA.backgroundColor, isFlat:true)
        v.addSubview(tileBP)
        hpos += tileh+delta
        
        let tileC = UILabel(frame:CGRect(x:hpos,y:ypos,width:tileh,height:tileh))
        tileC.backgroundColor = newColors[4]
        tileC.textAlignment = .Center
        tileC.text = "Spacer"
        tileC.numberOfLines = 0
        tileC.textColor = UIColor(contrastingBlackOrWhiteColorOn:tileC.backgroundColor, isFlat:true)
        v.addSubview(tileC)
        hpos += tileh+delta
        
        ypos += tileA.frame.height
        
        outer.addSubview(v)
        return outer
    }
}