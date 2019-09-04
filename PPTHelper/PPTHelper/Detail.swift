//
//  Detail.swift
//  PPTHelper
//
//  Created by apple on 16/5/15.
//  Copyright © 2016年 Wang. All rights reserved.
//

import UIKit

class Detail: UIViewController
{
    var currentPage:Int!
    var view1,view2,view3:UIView!
    var bar:UIImageView!
    var backButton:UIButton!
    var width,height:CGFloat!
    var rect1,rect2,rect3,rect_2,rect_3:CGRect!
    var image1,image2,penIcon,colorIcon:UIImageView!
    var center:CGPoint!
    var radius:CGFloat!
    var penRect,colorRect:[CGRect]!
    var currentPen,currentColor:Int!
    var shield:[UISwitch]!
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        let parameter=NSArray(contentsOfFile: (Introduction().documentPath as NSString).stringByAppendingPathComponent("parameter.txt")) as! [Int]
        currentPage=parameter[0]
        width=view.frame.width
        height=view.frame.height
        bar=UIImageView(frame: view.frame)
        view.addSubview(bar)
        backButton=UIButton(frame: CGRectMake(width*0.06, height*0.03, width*0.2, height*0.06))
        backButton.setTitle("返回", forState: .Normal)
        backButton.titleLabel!.font=UIFont(name: "Helvetica", size: height*0.04)
        backButton.addTarget(self, action: #selector(Detail.back), forControlEvents: .TouchUpInside)
        view.addSubview(backButton)
        view1=UIView(frame: CGRectMake(0, height*0.125, width, height*0.75))
        image1=UIImageView(frame: CGRectMake(0, 0, width, height*0.75))
        image1.image=UIImage(named: "翻页.png")
        view1.addSubview(image1)
        view2=UIView(frame: CGRectMake(0, height*0.125, width, height*0.75))
        image2=UIImageView(frame: CGRectMake(0, 0, width, height*0.75))
        image2.image=UIImage(named: "IMG_3811.PNG")
        view2.addSubview(image2)
        penRect=[]
        colorRect=[]
        penRect.append(CGRectMake(width*0.1, height*0.19, width*0.234, height*0.123))
        penRect.append(CGRectMake(width*0.375, height*0.19, width*0.25, height*0.123))
        penRect.append(CGRectMake(width*0.669, height*0.19, width*0.244, height*0.123))
        for i in 0..<5
        {
            for j in 0..<2
            {
                colorRect.append(CGRectMake(width*0.203+width*0.123*CGFloat(i), height*0.423+height*0.061*CGFloat(j), width*0.094, height*0.048))
            }
        }
        penIcon=UIImageView(image: UIImage(named: "IMG_3795.PNG"))
        colorIcon=UIImageView(image: UIImage(named: "IMG_3795.PNG"))
        currentPen = -1
        currentColor = -1
        rect_2=CGRectMake(width*0.27, height*0.75, width*0.46, height*0.069)
        view3=UIView(frame: CGRectMake(0, height*0.125, width, height*0.75))
        let image=UIImageView(frame: CGRectMake(0, 0, width, height*0.75))
        image.image=UIImage(named: "IMG_3812.PNG")
        view3.addSubview(image)
        let tap=UITapGestureRecognizer(target: self, action: #selector(Detail.tapped(_:)))
        tap.numberOfTapsRequired=1
        view.addGestureRecognizer(tap)
        var sw:UISwitch!
        shield=[]
        for i in 0..<4
        {
            sw=UISwitch()
            sw.center=CGPoint(x: width*0.758, y: height*0.233+height*0.089*CGFloat(i))
            shield.append(sw)
            view3.addSubview(sw)
        }
        rect_3=CGRectMake(width*0.308, height*0.756, width*0.373, height*0.067)
        let hold=UILongPressGestureRecognizer(target: self, action: #selector(Detail.holding(_:)))
        hold.minimumPressDuration=0.2
        hold.allowableMovement=20
        view.addGestureRecognizer(hold)
        refreshView()
        rect1=CGRectMake(0, height*0.875, width/3, height/8)
        rect2=CGRectMake(width/3, height*0.875, width/3, height/8)
        rect3=CGRectMake(width*2/3, height*0.875, width/3, height/8)
        center=CGPoint(x: width/2, y: height*0.61)
        radius=width*0.12
    }
    func back()
    {
        performSegueWithIdentifier("backward", sender: self)
    }
    func refreshView()
    {
        if currentPage==1
        {
            bar.image=UIImage(named: "navibar1.png")
            view.addSubview(view1)
            view2.removeFromSuperview()
            view3.removeFromSuperview()
        }
        if currentPage==2
        {
            bar.image=UIImage(named: "navibar2.png")
            view.addSubview(view2)
            view1.removeFromSuperview()
            view3.removeFromSuperview()
        }
        if currentPage==3
        {
            bar.image=UIImage(named: "navibar3.png")
            view.addSubview(view3)
            view1.removeFromSuperview()
            view2.removeFromSuperview()
        }
    }
    func tapped(sender: UITapGestureRecognizer)
    {
        var loc=sender.locationInView(view)
        if CGRectContainsPoint(rect1, loc)
        {
            currentPage=1
            refreshView()
        }
        if CGRectContainsPoint(rect2, loc)
        {
            currentPage=2
            refreshView()
        }
        if CGRectContainsPoint(rect3, loc)
        {
            currentPage=3
            refreshView()
        }
        if currentPage==3 && CGRectContainsPoint(rect_3, loc)
        {
            for i in shield
            {
                i.on=true
            }
        }
        loc=sender.locationInView(view2)
        if currentPage==2
        {
            for i in 0..<penRect.count
            {
                if CGRectContainsPoint(penRect[i], loc)
                {
                    if currentPen==i
                    {
                        currentPen = -1
                        penIcon.removeFromSuperview()
                    }
                    else
                    {
                        penIcon.removeFromSuperview()
                        penIcon.frame=CGRectMake(penRect[i].midX-25, penRect[i].midY-25, 50, 50)
                        view2.addSubview(penIcon)
                        currentPen=i
                        if i==2
                        {
                            colorIcon.removeFromSuperview()
                        }
                    }
                }
            }
            if currentPen==2 || currentPen == -1
            {
                return
            }
            for i in 0..<colorRect.count
            {
                if CGRectContainsPoint(colorRect[i], loc)
                {
                    if currentColor==i
                    {
                        currentColor = -1
                        colorIcon.removeFromSuperview()
                    }
                    else
                    {
                        colorIcon.removeFromSuperview()
                        colorIcon.frame=CGRectMake(colorRect[i].midX-25, colorRect[i].midY-25, 50, 50)
                        view2.addSubview(colorIcon)
                        currentColor=i
                    }
                }
            }
        }
    }
    func holding(sender: UILongPressGestureRecognizer)
    {
        if currentPage == 1
        {
            let loc=sender.locationInView(view)
            if distanceBetweenPoints(loc, second: center)<radius
            {
                if sender.state == .Began
                {
                    image1.image=UIImage(named: "翻页按下后.png")
                }
                else
                {
                    image1.image=UIImage(named: "翻页.png")
                }
            }
        }
        if currentPage == 2
        {
            let loc=sender.locationInView(view)
            if CGRectContainsPoint(rect_2, loc)
            {
                if sender.state == .Began
                {
                    image2.image=UIImage(named: "IMG_3813.PNG")
                }
                else
                {
                    image2.image=UIImage(named: "IMG_3811.PNG")
                }
            }
        }
    }
    func distanceBetweenPoints(first: CGPoint, second: CGPoint)->CGFloat
    {
        let deltaX = second.x - first.x
        let deltaY = second.y - first.y
        return sqrt(deltaX*deltaX + deltaY*deltaY)
    }
}
