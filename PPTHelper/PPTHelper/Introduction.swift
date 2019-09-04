//
//  Introduction.swift
//  PPTHelper
//
//  Created by apple on 16/5/15.
//  Copyright © 2016年 Wang. All rights reserved.
//

import UIKit

class Introduction: UIViewController
{
    var currentPage=1
    var width,height:CGFloat!
    var intro1,intro2,intro3,bottom1,bottom2,bottom3:UIView!
    var rect:CGRect!
    var timer:NSTimer!
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        var isDir:ObjCBool=false
        let path=(documentPath as NSString).stringByAppendingPathComponent("used.txt")
        if NSFileManager.defaultManager().fileExistsAtPath(path, isDirectory: &isDir)
        {
            timer=NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: #selector(Introduction.go), userInfo: nil, repeats: true)
            timer.fire()
            b=true
            return
        }
        width=view.frame.width
        height=view.frame.height
        var image:UIImageView!
        intro1=UIView(frame: CGRectMake(0, 0, width, height*0.656))
        image=UIImageView(frame: CGRectMake(0, 0, width, height*0.656))
        image.image=UIImage(named: "介绍界面1.png")
        intro1.addSubview(image)
        bottom1=UIView(frame: CGRectMake(0, height*0.656, width, height*0.344))
        image=UIImageView(frame: CGRectMake(0, 0, width, height*0.344))
        image.image=UIImage(named: "下半部分1.png")
        bottom1.addSubview(image)
        intro2=UIView(frame: CGRectMake(0, 0, width, height*0.656))
        image=UIImageView(frame: CGRectMake(0, 0, width, height*0.656))
        image.image=UIImage(named: "介绍界面2.png")
        intro2.addSubview(image)
        bottom2=UIView(frame: CGRectMake(0, height*0.656, width, height*0.344))
        image=UIImageView(frame: CGRectMake(0, 0, width, height*0.344))
        image.image=UIImage(named: "下半部分2.png")
        bottom2.addSubview(image)
        intro3=UIView(frame: CGRectMake(0, 0, width, height*0.656))
        image=UIImageView(frame: CGRectMake(0, 0, width, height*0.656))
        image.image=UIImage(named: "介绍界面3.png")
        intro3.addSubview(image)
        bottom3=UIView(frame: CGRectMake(0, height*0.656, width, height*0.344))
        image=UIImageView(frame: CGRectMake(0, 0, width, height*0.344))
        image.image=UIImage(named: "下半部分3.png")
        bottom3.addSubview(image)
        view.addSubview(intro1)
        view.addSubview(bottom1)
        let swipeLeft=UISwipeGestureRecognizer(target: self, action: #selector(Introduction.left))
        swipeLeft.direction = .Left
        view.addGestureRecognizer(swipeLeft)
        let swipeRight=UISwipeGestureRecognizer(target: self, action: #selector(Introduction.right))
        swipeRight.direction = .Right
        view.addGestureRecognizer(swipeRight)
        let tap=UITapGestureRecognizer(target: self, action: #selector(Introduction.tapped(_:)))
        tap.numberOfTapsRequired=1
        view.addGestureRecognizer(tap)
        rect=CGRectMake(width*0.28, height*0.843, width*0.44, height*0.08)
    }
    func left()
    {
        if currentPage==3
        {
            return
        }
        if currentPage==1
        {
            intro2.frame=CGRectMake(width, 0, width, height*0.656)
            view.addSubview(intro2)
            UIView.animateWithDuration(0.5, animations:
                {
                    self.intro2.frame=CGRectMake(0, 0, self.width, self.height*0.656)
                }, completion:
                { finished in
                    self.intro1.removeFromSuperview()
            })
            view.addSubview(bottom2)
            bottom1.removeFromSuperview()
            currentPage=2
            return
        }
        if currentPage==2
        {
            intro3.frame=CGRectMake(width, 0, width, height*0.656)
            view.addSubview(intro3)
            UIView.animateWithDuration(0.5, animations:
                {
                    self.intro3.frame=CGRectMake(0, 0, self.width, self.height*0.656)
                }, completion:
                { finished in
                    self.intro2.removeFromSuperview()
            })
            view.addSubview(bottom3)
            bottom2.removeFromSuperview()
            currentPage=3
        }
    }
    func right()
    {
        if currentPage==1
        {
            return
        }
        if currentPage==2
        {
            intro1.frame=CGRectMake(-width, 0, width, height*0.656)
            view.addSubview(intro1)
            UIView.animateWithDuration(0.5, animations:
                {
                    self.intro1.frame=CGRectMake(0, 0, self.width, self.height*0.656)
                }, completion:
                { finished in
                    self.intro2.removeFromSuperview()
            })
            view.addSubview(bottom1)
            bottom2.removeFromSuperview()
            currentPage=1
        }
        if currentPage==3
        {
            intro2.frame=CGRectMake(-width, 0, width, height*0.656)
            view.addSubview(intro2)
            UIView.animateWithDuration(0.5, animations:
                {
                    self.intro2.frame=CGRectMake(0, 0, self.width, self.height*0.656)
                }, completion:
                { finished in
                    self.intro3.removeFromSuperview()
            })
            view.addSubview(bottom2)
            bottom3.removeFromSuperview()
            currentPage=2
        }
    }
    var documentPath:String
    {
        get
        {
            let application=NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
            return application[0]
        }
    }
    func tapped(sender: UITapGestureRecognizer)
    {
        let loc=sender.locationInView(view)
        if currentPage==3 && CGRectContainsPoint(rect, loc)
        {
            let path=(documentPath as NSString).stringByAppendingPathComponent("used.txt")
            NSFileManager.defaultManager().createFileAtPath(path, contents: nil, attributes: nil)
            performSegueWithIdentifier("go", sender: self)
        }
    }
    var b=false
    func go()
    {
        if b
        {
            b=false
            performSegueWithIdentifier("go", sender: self)
        }
    }
}
