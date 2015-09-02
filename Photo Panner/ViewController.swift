//
//  ViewController.swift
//  Photo Panner
//
//  Created by Justin Vallely on 8/6/15.
//  Copyright (c) 2015 Justin Vallely. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController, UIScrollViewDelegate {

    let motionManager: CMMotionManager = CMMotionManager()

    var panningScrollView: UIScrollView!
    var imageView: UIImageView!

    func maximumZoomScaleForImage(image: UIImage) -> CGFloat {
        return (panningScrollView.bounds.height / panningScrollView.bounds.width) * (image.size.width / image.size.height)
    }

    func clampedContentOffsetForHorizontalOffset(horizontalOffset: CGFloat) -> CGPoint {
        var maximumXOffset: CGFloat = panningScrollView.contentSize.width - panningScrollView.bounds.width
        var minimumXOffset: CGFloat = 0.0
        var clampedXOffset: CGFloat = fmax(minimumXOffset, fmin(abs(horizontalOffset), abs(-maximumXOffset)))
        var centeredY: CGFloat = 0.0 //(panningScrollView.contentSize.height / 2.0) - (panningScrollView.bounds.height / 2.0 )
        return CGPointMake(clampedXOffset, centeredY)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
       
        let image: UIImage = UIImage(named: "mountain.jpg")!
        imageView = UIImageView(image: image)
        panningScrollView = UIScrollView(frame: view.bounds)
        
        var zoomScale: CGFloat = maximumZoomScaleForImage(image)
        
        panningScrollView.maximumZoomScale = (panningScrollView.bounds.height / panningScrollView.bounds.width) * (image.size.width / image.size.height)
        panningScrollView.zoomScale = zoomScale
        
        view.addSubview(panningScrollView)
        panningScrollView.addSubview(imageView)
        
        motionManager.startDeviceMotionUpdatesToQueue(NSOperationQueue.mainQueue(), withHandler: { (motion, error) -> Void in
        
            var xRotationRate: CGFloat = CGFloat(motion.rotationRate.x)
            var yRotationRate: CGFloat = CGFloat(motion.rotationRate.y) // device tilt
            var zRotationRate: CGFloat = CGFloat(motion.rotationRate.z) // as! CGFloat
            
            //self.motionManager.deviceMotionUpdateInterval = 1
            
            if fabs(yRotationRate) > (fabs(xRotationRate) + fabs(zRotationRate)) {
                
                var kRotationMultiplier: CGFloat = 5
                var invertedYRotationRate: CGFloat = yRotationRate * -1
                var zoomScale: CGFloat = (self.panningScrollView.bounds.height / self.panningScrollView.bounds.width) * (image.size.width / image.size.height)
                var interpretedXOffset: CGFloat = self.panningScrollView.contentOffset.x + (invertedYRotationRate * zoomScale * kRotationMultiplier)
                var contentOffset: CGPoint = self.clampedContentOffsetForHorizontalOffset(interpretedXOffset)
                println("contentOffset: \(contentOffset)")
                
                self.panningScrollView.contentOffset = contentOffset
            }
        
        })
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

