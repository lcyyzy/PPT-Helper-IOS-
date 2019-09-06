//
//  Detail.swift
//  PPTHelper
//
//  Created by apple on 16/5/15.
//  Copyright © 2016年 Chaoying. All rights reserved.
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
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        let parameter=NSArray(contentsOfFile: (Introduction().documentPath as NSString).appendingPathComponent("parameter.txt")) as! [Int]
        currentPage=parameter[0]
        width=view.frame.width
        height=view.frame.height
        bar=UIImageView(frame: view.frame)
        view.addSubview(bar)
        backButton=UIButton(frame: CGRect(x: width*0.06, y: height*0.03, width: width*0.2, height: height*0.06))
        backButton.setTitle("返回", for: .normal)
        backButton.titleLabel!.font=UIFont(name: "Helvetica", size: height*0.04)
        backButton.addTarget(self, action: #selector(Detail.back), for: .touchUpInside)
        view.addSubview(backButton)
        view1=UIView(frame: CGRect(x: 0, y: height*0.125, width: width, height: height*0.75))
        image1=UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height*0.75))
        image1.image=UIImage(named: "翻页.png")
        view1.addSubview(image1)
        view2=UIView(frame: CGRect(x: 0, y: height*0.125, width: width, height: height*0.75))
        image2=UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height*0.75))
        image2.image=UIImage(named: "IMG_3811.PNG")
        view2.addSubview(image2)
        penRect=[]
        colorRect=[]
        penRect.append(CGRect(x: width*0.1, y: height*0.19, width: width*0.234, height: height*0.123))
        penRect.append(CGRect(x: width*0.375, y: height*0.19, width: width*0.25, height: height*0.123))
        penRect.append(CGRect(x: width*0.669, y: height*0.19, width: width*0.244, height: height*0.123))
        for i in 0..<5
        {
            for j in 0..<2
            {
                colorRect.append(CGRect(x: width*0.203+width*0.123*CGFloat(i), y: height*0.423+height*0.061*CGFloat(j), width: width*0.094, height: height*0.048))
            }
        }
        penIcon=UIImageView(image: UIImage(named: "IMG_3795.PNG"))
        colorIcon=UIImageView(image: UIImage(named: "IMG_3795.PNG"))
        currentPen = -1
        currentColor = -1
        rect_2=CGRect(x: width*0.27, y: height*0.75, width: width*0.46, height: height*0.069)
        view3=UIView(frame: CGRect(x: 0, y: height*0.125, width: width, height: height*0.75))
        let image=UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height*0.75))
        image.image=UIImage(named: "IMG_3812.PNG")
        view3.addSubview(image)
        let tap=UITapGestureRecognizer(target: self, action: #selector(handleTap))
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
        rect_3=CGRect(x: width*0.308, y: height*0.756, width: width*0.373, height: height*0.067)
        let hold=UILongPressGestureRecognizer(target: self, action: #selector(holding))
        hold.minimumPressDuration=0.2
        hold.allowableMovement=20
        view.addGestureRecognizer(hold)
        refreshView()
        rect1=CGRect(x: 0, y: height*0.875, width: width/3, height: height/8)
        rect2=CGRect(x: width/3, y: height*0.875, width: width/3, height: height/8)
        rect3=CGRect(x: width*2/3, y: height*0.875, width: width/3, height: height/8)
        center=CGPoint(x: width/2, y: height*0.61)
        radius=width*0.12
    }
    @objc func back()
    {
        performSegue(withIdentifier: "backward", sender: self)
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
    @objc func handleTap(_ sender: UITapGestureRecognizer)
    {
        var loc=sender.location(in: view)
        if rect1.contains(loc)
        {
            currentPage=1
            refreshView()
        }
        if rect2.contains(loc)
        {
            currentPage=2
            refreshView()
        }
        if rect3.contains(loc)
        {
            currentPage=3
            refreshView()
        }
        if currentPage==3 && rect_3.contains(loc)
        {
            for i in shield
            {
                i.isOn=true
            }
        }
        loc=sender.location(in: view2)
        if currentPage==2
        {
            for i in 0..<penRect.count
            {
                if penRect[i].contains(loc)
                {
                    if currentPen==i
                    {
                        currentPen = -1
                        penIcon.removeFromSuperview()
                    }
                    else
                    {
                        penIcon.removeFromSuperview()
                        penIcon.frame=CGRect(x: penRect[i].midX-25, y: penRect[i].midY-25, width: 50, height: 50)
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
                if colorRect[i].contains(loc)
                {
                    if currentColor==i
                    {
                        currentColor = -1
                        colorIcon.removeFromSuperview()
                    }
                    else
                    {
                        colorIcon.removeFromSuperview()
                        colorIcon.frame=CGRect(x: colorRect[i].midX-25, y: colorRect[i].midY-25, width: 50, height: 50)
                        view2.addSubview(colorIcon)
                        currentColor=i
                    }
                }
            }
        }
    }
    @objc func holding(_ sender: UILongPressGestureRecognizer)
    {
        if currentPage == 1
        {
            let loc=sender.location(in: view)
            if distanceBetweenPoints(first: loc, second: center)<radius
            {
                if sender.state == .began
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
            let loc=sender.location(in: view)
            if rect_2.contains(loc)
            {
                if sender.state == .began
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
