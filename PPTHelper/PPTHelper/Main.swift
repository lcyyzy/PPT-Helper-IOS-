//
//  Main.swift
//  PPTHelper
//
//  Created by apple on 16/5/15.
//  Copyright © 2016年 Wang. All rights reserved.
//

import UIKit

class Main: UIViewController
{
    var background:UIImageView!
    var width,height:CGFloat!
    var rect1,rect2,rect3,rect4:CGRect!
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        background=UIImageView(frame: view.frame)
        background.image=UIImage(named: "主界面.png")
        view.addSubview(background)
        let tap=UITapGestureRecognizer(target: self, action: #selector(Main.tapped(_:)))
        tap.numberOfTapsRequired=1
        view.addGestureRecognizer(tap)
        width=view.frame.width
        height=view.frame.height
        rect1=CGRectMake(width*0.25, height*0.50, width*0.50, height*0.07)
        rect2=CGRectMake(width*0.25, height*0.62, width*0.50, height*0.07)
        rect3=CGRectMake(width*0.25, height*0.74, width*0.50, height*0.07)
        rect4=CGRectMake(width*0.31, height*0.86, width*0.38, height*0.06)
    }
    var label:UILabel!
    var image:UIImageView!
    var timer:NSTimer!
    var counter=0
    func tapped(sender: UITapGestureRecognizer)
    {
        let loc=sender.locationInView(view)
        if CGRectContainsPoint(rect1, loc)
        {
            ([1] as NSArray).writeToFile((Introduction().documentPath as NSString).stringByAppendingPathComponent("parameter.txt"), atomically: true)
            performSegueWithIdentifier("forward", sender: self)
        }
        if CGRectContainsPoint(rect2, loc)
        {
            ([2] as NSArray).writeToFile((Introduction().documentPath as NSString).stringByAppendingPathComponent("parameter.txt"), atomically: true)
            performSegueWithIdentifier("forward", sender: self)
        }
        if CGRectContainsPoint(rect3, loc)
        {
            ([3] as NSArray).writeToFile((Introduction().documentPath as NSString).stringByAppendingPathComponent("parameter.txt"), atomically: true)
            performSegueWithIdentifier("forward", sender: self)
        }
        if CGRectContainsPoint(rect4, loc)
        {
            image=UIImageView(frame: view.frame)
            image.image=UIImage(named: "连接界面.png")
            view.addSubview(image)
            label=UILabel(frame: CGRectMake(0, height*0.25, width, height*0.08))
            label.textAlignment = .Center
            label.font=UIFont(name: "Helvetica", size: height*0.08)
            label.text="0%"
            image.addSubview(label)
            counter = -10
            timer=NSTimer.scheduledTimerWithTimeInterval(0.04, target: self, selector: #selector(Main.update), userInfo: nil, repeats: true)
            timer.fire()
        }
    }
    func update()
    {
        if counter>=0 && counter<=100
        {
            label.text="\(counter)%"
        }
        if counter>110
        {
            timer.invalidate()
            image.removeFromSuperview()
        }
        counter+=1
    }
}
