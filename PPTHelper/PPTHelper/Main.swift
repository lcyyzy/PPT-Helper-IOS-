//
//  Main.swift
//  PPTHelper
//
//  Created by apple on 16/5/15.
//  Copyright © 2016年 Chaoying. All rights reserved.
//

import UIKit

class Main: UIViewController
{
    var background:UIImageView!
    var width,height:CGFloat!
    var rect1,rect2,rect3,rect4:CGRect!
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        background=UIImageView(frame: view.frame)
        background.image=UIImage(named: "主界面.png")
        view.addSubview(background)
        let tap=UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tap.numberOfTapsRequired=1
        view.addGestureRecognizer(tap)
        width=view.frame.width
        height=view.frame.height
        rect1=CGRect(x: width*0.25, y: height*0.50, width: width*0.50, height: height*0.07)
        rect2=CGRect(x: width*0.25, y: height*0.62, width: width*0.50, height: height*0.07)
        rect3=CGRect(x: width*0.25, y: height*0.74, width: width*0.50, height: height*0.07)
        rect4=CGRect(x: width*0.31, y: height*0.86, width: width*0.38, height: height*0.06)
    }
    var label:UILabel!
    var image:UIImageView!
    var timer:Timer!
    var counter=0
    @objc func handleTap(_ sender: UITapGestureRecognizer)
    {
        let loc=sender.location(in: view)
        if rect1.contains(loc)
        {
            ([1] as NSArray).write(toFile: (Introduction().documentPath as NSString).appendingPathComponent("parameter.txt"), atomically: true)
            performSegue(withIdentifier: "forward", sender: self)
        }
        if rect2.contains(loc)
        {
            ([2] as NSArray).write(toFile: (Introduction().documentPath as NSString).appendingPathComponent("parameter.txt"), atomically: true)
            performSegue(withIdentifier: "forward", sender: self)
        }
        if rect3.contains(loc)
        {
            ([3] as NSArray).write(toFile: (Introduction().documentPath as NSString).appendingPathComponent("parameter.txt"), atomically: true)
            performSegue(withIdentifier: "forward", sender: self)
        }
        if rect4.contains(loc)
        {
            image=UIImageView(frame: view.frame)
            image.image=UIImage(named: "连接界面.png")
            view.addSubview(image)
            label=UILabel(frame: CGRect(x: 0, y: height*0.25, width: width, height: height*0.08))
            label.textAlignment = .center
            label.font=UIFont(name: "Helvetica", size: height*0.08)
            label.text="0%"
            image.addSubview(label)
            counter = -10
            timer=Timer.scheduledTimer(timeInterval: 0.04, target: self, selector: #selector(Main.update), userInfo: nil, repeats: true)
            timer.fire()
        }
    }
    @objc func update()
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
