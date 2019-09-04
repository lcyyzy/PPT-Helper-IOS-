//
//  ViewController.swift
//  VShapeRecog
//
//  Created by alicexia on 16/4/26.
//  Copyright © 2016年 novinsomnia. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {

    @IBOutlet weak var push: UIButton!
    @IBOutlet weak var text: UITextField!
    
    @IBOutlet weak var axs: UITextField!
    @IBOutlet weak var ays: UITextField!
    @IBOutlet weak var azs: UITextField!
    
    let manager = CMMotionManager()
    
    var axsign = Array(count:5, repeatedValue: 0)
    var aysign = Array(count:5, repeatedValue: 0)
    var azsign = Array(count:5, repeatedValue: 0)
    
    var ax:[Double] = []
    var ay:[Double] = []
    var az:[Double] = []
    
    func reset() {
        ax.removeAll()
        ay.removeAll()
        az.removeAll()
        
        axsign = [0,0,0,0,0]
        aysign = [0,0,0,0,0]
        azsign = [0,0,0,0,0]
    }
    
    func movingFilter(a: [Double]) -> [Double] {
        
        let moving_filter = 5
        let len = a.count
        var a_f = Array(count:a.count, repeatedValue: 0.0)
        
        for i in 0...(len-moving_filter) {
            for j in 0...(moving_filter-1) {
                a_f[i] = a_f[i]+a[i+j]
            }
            a_f[i] = a_f[i] / Double(moving_filter)
        }
        
        for i in (len-moving_filter)...len-1 {
            a_f[i] = a[i]
        }

        return a_f
    }
    
    func normalize() {
        var maxa = 0.0
        
        for i in 0...(ax.count-1) {
            if (ax[i] > maxa)  { maxa = ax[i] }
            if (ay[i] > maxa)  { maxa = ay[i] }
            if (az[i] > maxa)  { maxa = az[i] }
        }
        
        for i in 0...ax.count-1 {
            ax[i] = ax[i]/maxa
            ay[i] = ay[i]/maxa
            az[i] = az[i]/maxa
            
            if (abs(ax[i]) < 0.3) {ax[i] = 0}
            if (abs(ay[i]) < 0.3) {ay[i] = 0}
            if (abs(az[i]) < 0.3) {az[i] = 0}
        }
    }
    
    func dataProcessing() {
        
        ax = movingFilter(ax)
        ay = movingFilter(ay)
        az = movingFilter(az)
        
        normalize()
        
        var i = 0
        for j in 0...ax.count-1 {
            if (ax[j] > 0 && axsign[i] <= 0) {
                i++
                axsign[i] = 1
            }
            else if (ax[j] < 0 && axsign[i] >= 0) {
                i++
                axsign[i] = -1
            }
        }
        
        i = 0
        for j in 0...ay.count-1 {
            if (ay[j] > 0 && aysign[i] <= 0) {
                i++
                aysign[i] = 1
            }
            else if (ay[j] < 0 && aysign[i] >= 0) {
                i++
                aysign[i] = -1
            }
        }
        
        i = 0
        for j in 0...ay.count-1 {
            if (az[j] > 0 && azsign[i] <= 0) {
                i++
                azsign[i] = 1
            }
            else if (az[j] < 0 && azsign[i] >= 0) {
                i++
                azsign[i] = -1
            }
        }
        
        axsign.removeAtIndex(0)
        aysign.removeAtIndex(0)
        azsign.removeAtIndex(0)
        
        if (axsign == [-1,1,-1,1] && aysign == [1,-1,1,0] && azsign == [0,0,0,0]) {
            text.text = "This is a VShape"
        }
        else {
            text.text = "Can not recognize"
        }
        
        print("\(axsign)\n")
        print("\(aysign)\n")
        print("\(azsign)\n")
        
        axs.text = axsign.flatMap { String($0) }.joinWithSeparator(", ")
        ays.text = aysign.flatMap { String($0) }.joinWithSeparator(", ")
        azs.text = azsign.flatMap { String($0) }.joinWithSeparator(", ")
        
    }
    
    @IBAction func touchDown(sender: AnyObject) {
        //clear the data
        reset()
        
        if manager.deviceMotionAvailable {
            manager.deviceMotionUpdateInterval = 0.02
            manager.startDeviceMotionUpdatesToQueue(NSOperationQueue.mainQueue(), withHandler: {(data: CMDeviceMotion?, error: NSError?) -> Void in
                self.ax.append(data!.userAcceleration.x)
                self.ay.append(data!.userAcceleration.y)
                self.az.append(data!.userAcceleration.z)
                
            })
        }
    }
    
    @IBAction func touchUp(sender: AnyObject) {
        if manager.deviceMotionAvailable {
            manager.stopDeviceMotionUpdates()
        }
        dataProcessing()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

