//
//  Introduction.swift
//  PPTHelper
//
//  Created by apple on 16/5/15.
//  Copyright © 2016年 Chaoying. All rights reserved.
//

import UIKit

class Introduction: UIViewController
{
    var currentPage=1
    var width,height:CGFloat!
    var intro1,intro2,intro3,bottom1,bottom2,bottom3:UIView!
    var rect:CGRect!
    var timer:Timer!
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        var isDir:ObjCBool=false
        let path=(documentPath as NSString).appendingPathComponent("used.txt")
        if FileManager.default.fileExists(atPath: path, isDirectory: &isDir)
        {
            timer=Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(Introduction.go), userInfo: nil, repeats: true)
            timer.fire()
            b=true
            return
        }
        width=view.frame.width
        height=view.frame.height
        var image:UIImageView!
        intro1=UIView(frame: CGRect(x: 0, y: 0, width: width, height: height*0.656))
        image=UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height*0.656))
        image.image=UIImage(named: "介绍界面1.png")
        intro1.addSubview(image)
        bottom1=UIView(frame: CGRect(x: 0, y: height*0.656, width: width, height: height*0.344))
        image=UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height*0.344))
        image.image=UIImage(named: "下半部分1.png")
        bottom1.addSubview(image)
        intro2=UIView(frame: CGRect(x: 0, y: 0, width: width, height: height*0.656))
        image=UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height*0.656))
        image.image=UIImage(named: "介绍界面2.png")
        intro2.addSubview(image)
        bottom2=UIView(frame: CGRect(x: 0, y: height*0.656, width: width, height: height*0.344))
        image=UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height*0.344))
        image.image=UIImage(named: "下半部分2.png")
        bottom2.addSubview(image)
        intro3=UIView(frame: CGRect(x: 0, y: 0, width: width, height: height*0.656))
        image=UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height*0.656))
        image.image=UIImage(named: "介绍界面3.png")
        intro3.addSubview(image)
        bottom3=UIView(frame: CGRect(x: 0, y: height*0.656, width: width, height: height*0.344))
        image=UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height*0.344))
        image.image=UIImage(named: "下半部分3.png")
        bottom3.addSubview(image)
        view.addSubview(intro1)
        view.addSubview(bottom1)
        let swipeLeft=UISwipeGestureRecognizer(target: self, action: #selector(Introduction.left))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)
        let swipeRight=UISwipeGestureRecognizer(target: self, action: #selector(Introduction.right))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
        let tap=UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tap.numberOfTapsRequired=1
        view.addGestureRecognizer(tap)
        rect=CGRect(x: width*0.28, y: height*0.843, width: width*0.44, height: height*0.08)
    }
    @objc func left()
    {
        if currentPage==3
        {
            return
        }
        if currentPage==1
        {
            intro2.frame=CGRect(x: width, y: 0, width: width, height: height*0.656)
            view.addSubview(intro2)
            UIView.animate(withDuration: 0.5, animations:
                {
                    self.intro2.frame=CGRect(x: 0, y: 0, width: self.width, height: self.height*0.656)
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
            intro3.frame=CGRect(x: width, y: 0, width: width, height: height*0.656)
            view.addSubview(intro3)
            UIView.animate(withDuration: 0.5, animations:
                {
                    self.intro3.frame=CGRect(x: 0, y: 0, width: self.width, height: self.height*0.656)
                }, completion:
                { finished in
                    self.intro2.removeFromSuperview()
            })
            view.addSubview(bottom3)
            bottom2.removeFromSuperview()
            currentPage=3
        }
    }
    @objc func right()
    {
        if currentPage==1
        {
            return
        }
        if currentPage==2
        {
            intro1.frame=CGRect(x: -width, y: 0, width: width, height: height*0.656)
            view.addSubview(intro1)
            UIView.animate(withDuration: 0.5, animations:
                {
                    self.intro1.frame=CGRect(x: 0, y: 0, width: self.width, height: self.height*0.656)
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
            intro2.frame=CGRect(x: -width, y: 0, width: width, height: height*0.656)
            view.addSubview(intro2)
            UIView.animate(withDuration: 0.5, animations:
                {
                    self.intro2.frame=CGRect(x: 0, y: 0, width: self.width, height: self.height*0.656)
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
            let application=NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            return application[0]
        }
    }
    @objc func handleTap(_ sender: UITapGestureRecognizer)
    {
        let loc=sender.location(in: view)
        if currentPage==3 && rect.contains(loc)
        {
            let path=(documentPath as NSString).appendingPathComponent("used.txt")
            FileManager.default.createFile(atPath: path, contents: nil, attributes: nil)
            performSegue(withIdentifier: "go", sender: self)
        }
    }
    var b=false
    @objc func go()
    {
        if b
        {
            b=false
            performSegue(withIdentifier: "go", sender: self)
        }
    }
}
