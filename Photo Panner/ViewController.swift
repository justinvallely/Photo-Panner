//
//  ViewController.swift
//  Photo Panner
//
//  Created by Justin Vallely on 8/6/15.
//  Copyright (c) 2015 Justin Vallely. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {

    let motionManager: CMMotionManager = CMMotionManager()

    @IBOutlet weak var x: UILabel!
    @IBOutlet weak var y: UILabel!
    @IBOutlet weak var z: UILabel!

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var panningScrollView: UIScrollView!

    func maximumZoomScaleForImage(image: UIImage) -> CGFloat {
        return (CGRectGetHeight(self.panningScrollView.bounds) / CGRectGetWidth(self.panningScrollView.bounds)) * (image.size.width / image.size.height)
    }

    func clampedContentOffsetForHorizontalOffset(horizontalOffset: CGFloat) -> CGPoint {
        var maximumXOffset: CGFloat = self.panningScrollView.contentSize.width - CGRectGetWidth(self.panningScrollView.bounds)
        var minimumXOffset: Float = 0.0
        var foo = Float(fmin(horizontalOffset, maximumXOffset))
        var clampedXOffset: CGFloat = CGFloat(fmaxf(minimumXOffset, foo))
        var centeredY: CGFloat = (self.panningScrollView.contentSize.height / 2.0) - (CGRectGetHeight(self.panningScrollView.bounds)) / 2.0
        return CGPointMake(clampedXOffset, centeredY)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        let image = UIImage(named: "mountain.jpg")
        //imageView = UIImageView(image: image)
        //panningScrollView.addSubview(imageView)

        var zoomScale: CGFloat = self.maximumZoomScaleForImage(image!)
        self.panningScrollView.maximumZoomScale = (CGRectGetHeight(self.panningScrollView.bounds) / CGRectGetWidth(self.panningScrollView.bounds)) * (image!.size.width / image!.size.height)
        self.panningScrollView.zoomScale = zoomScale

        self.motionManager.startDeviceMotionUpdatesToQueue(NSOperationQueue.mainQueue(), withHandler: { (motion, error) -> Void in
            var xRotationRate: CGFloat = CGFloat(motion.rotationRate.x)
            var yRotationRate: CGFloat = CGFloat(motion.rotationRate.y) // device tilt
            var zRotationRate: CGFloat = CGFloat(motion.rotationRate.z) // as! CGFloat

            //self.motionManager.deviceMotionUpdateInterval = 1

            self.x.text = "\(xRotationRate)"
            self.y.text = "\(yRotationRate)"
            self.z.text = "\(zRotationRate)"

            if fabs(yRotationRate) > (fabs(xRotationRate) + fabs(zRotationRate)) {
                // Do our movement
                var kRotationMultiplier: CGFloat = 5
                var invertedYRotationRate: CGFloat = yRotationRate * -1
                var zoomScale: CGFloat = (CGRectGetHeight(self.panningScrollView.bounds) / CGRectGetWidth(self.panningScrollView.bounds)) * (image!.size.width / image!.size.height)
                var interpretedXOffset: CGFloat = self.panningScrollView.contentOffset.x + (invertedYRotationRate * zoomScale * kRotationMultiplier)
                var contentOffset: CGPoint = self.clampedContentOffsetForHorizontalOffset(interpretedXOffset)
            }

            
        })




    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

