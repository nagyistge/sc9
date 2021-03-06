//
//  StartupAnimationView.swift
//  SBLoader
//
//  Created by Satraj Bambra on 2015-03-17.
//  Copyright (c) 2015 Satraj Bambra. All rights reserved.
//

import UIKit

protocol StartupAnimationViewDelegate:  class {
    func animateLabel(completion:RestoralCompletion)
}

extension UIViewController: StartupAnimationViewDelegate {
    func animateLabel(completion:RestoralCompletion) {
        // 1
        //holderView.removeFromSuperview()
        view.backgroundColor = Colors.mainColor()
        
        // 2
        //print ("\(self.view.frame)")
        
        let label: UILabel = UILabel(frame: view.frame)
        label.textColor = Colors.white
        label.font = UIFont(name: "HelveticaNeue-Thin", size: 70.0)
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = NSTextAlignment.Center
        label.text = "SheetCheats"
        label.transform = CGAffineTransformScale(label.transform, 0.25, 0.25)
        view.addSubview(label)
        
        // 3
        UIView.animateWithDuration(2.4, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.1, options: UIViewAnimationOptions.CurveEaseInOut,
            animations: ({
                label.transform = CGAffineTransformScale(label.transform, 4.0, 4.0)
            }), completion: { finished in
                print("spring animation finished \(finished)")
                if finished { completion() }

        })
    }
}
class StartupAnimationView: UIView {
    
  var finalSignal: RestoralCompletion?
let animationBlue = Colors.mainColor()
  let ovalLayer = OvalLayer()
  let triangleLayer = TriangleLayer()
  let redRectangleLayer = RectangleLayer()
  let blueRectangleLayer = RectangleLayer()
  let arcLayer = ArcLayer()

  var parentFrame :CGRect = CGRectZero
  weak var delegate:StartupAnimationViewDelegate?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = Colors.clear
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }

  func addOval() {
    layer.addSublayer(ovalLayer)
    ovalLayer.expand()
    NSTimer.scheduledTimerWithTimeInterval(0.3, target: self, selector: "wobbleOval",
      userInfo: nil, repeats: false)
  }

  func wobbleOval() {
    ovalLayer.wobble()
    // 1
    layer.addSublayer(triangleLayer) // Add this line
    ovalLayer.wobble()

    // 2
    // Add the code below
    NSTimer.scheduledTimerWithTimeInterval(0.4, target: self,
      selector: "drawAnimatedTriangle", userInfo: nil,
      repeats: false)
  }

  func drawAnimatedTriangle() {
    triangleLayer.animate()
    NSTimer.scheduledTimerWithTimeInterval(0.4, target: self, selector: "spinAndTransform",
      userInfo: nil, repeats: false)
  }

  func spinAndTransform() {
    // 1
    layer.anchorPoint = CGPointMake(0.5, 0.6)

    // 2
    let rotationAnimation: CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
    rotationAnimation.toValue = CGFloat(M_PI * 2.0)
    rotationAnimation.duration = 0.25
    rotationAnimation.removedOnCompletion = true
    layer.addAnimation(rotationAnimation, forKey: nil)

    // 3

    ovalLayer.contract()

    NSTimer.scheduledTimerWithTimeInterval(0.15, target: self,
      selector: "drawRedAnimatedRectangle",
      userInfo: nil, repeats: false)
    NSTimer.scheduledTimerWithTimeInterval(0.35, target: self,
      selector: "drawBlueAnimatedRectangle",
      userInfo: nil, repeats: false)
  }

  func drawRedAnimatedRectangle() {
    layer.addSublayer(redRectangleLayer)
    redRectangleLayer.animateStrokeWithColor(Colors.drawingAlertColor)
  }

  func drawBlueAnimatedRectangle() {
    layer.addSublayer(blueRectangleLayer)
    blueRectangleLayer.animateStrokeWithColor(Colors.mainColor())
    NSTimer.scheduledTimerWithTimeInterval(0.40, target: self, selector: "drawArc",
      userInfo: nil, repeats: false)
  }

  func drawArc() {
    layer.addSublayer(arcLayer)
    arcLayer.animate()
    NSTimer.scheduledTimerWithTimeInterval(0.60, target: self, selector: "expandView",
      userInfo: nil, repeats: false)
  }

  func expandView() {
    backgroundColor = Colors.mainColor()
    frame = CGRectMake(frame.origin.x - blueRectangleLayer.lineWidth,
      frame.origin.y - blueRectangleLayer.lineWidth,
      frame.size.width + blueRectangleLayer.lineWidth * 2,
      frame.size.height + blueRectangleLayer.lineWidth * 2)
    layer.sublayers = nil

    UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
      self.frame = self.parentFrame
      }, completion: { finished in
        self.addLabel()
    })
  }

  func addLabel() {
/// COMES HERE WHEN INITIAL ANIMATION DANCE IS DONE, NOW ANIMATE THE LABEL
    delegate?.animateLabel(){
        // WHEN THE LABEL IS FINALLY DONE SEND ANOTHER SIGNAL
   if self.finalSignal != nil
               {
                self.finalSignal!()
        }

    }
    
  }

}
