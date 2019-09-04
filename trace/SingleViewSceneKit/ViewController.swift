//
//  ViewController.swift
//  SingleViewSceneKit
//
//  Created by Kawhi Lu on 15/5/6.
//  Copyright (c) 2015年 Kawhi Lu. All rights reserved.
//

import UIKit
import SceneKit
import CoreMotion

class ViewController: UIViewController {
    
    @IBOutlet weak var ax: UILabel!
    @IBOutlet weak var ay: UILabel!
    @IBOutlet weak var az: UILabel!
    
    let manager = CMMotionManager()
    let sceneView = SCNView(frame: CGRect(x: 10, y: 10, width: 300, height: 250))
    var scene = SCNScene()
    var CMdata = NSMutableData()
    
    //创建一个加速度仪的对象
    var accel = Accelerometer()
    //创建一个陀螺仪的对象
    var gyro = Gyroscope()
    //变量numOfUpdate用来记录数据更新的次数
    
    @IBAction func startCollectData() {
        if manager.deviceMotionAvailable {
            manager.deviceMotionUpdateInterval = 0.01
            var numOfUpdate = 0
            var MFCount = 0
            var rawAccel = [0.0, 0.0, 0.0]
            manager.startDeviceMotionUpdatesToQueue(NSOperationQueue.mainQueue(), withHandler: {(data: CMDeviceMotion!, error: NSError!) -> Void in
                
                if( MFCount < 10)
                {
                    MFCount++
                    rawAccel = rawAccel + [data.userAcceleration.x, data.userAcceleration.y, data.userAcceleration.z]
                }
                else
                {
                    MFCount = 0
                    // 取10个数据的平均，进行一次均值滤波
                    rawAccel = 0.1 * rawAccel
                    
                    // 对采样得到的点进行一次高通滤波，阈值为0.1
                    for i in 0...2
                    {
                        if(rawAccel[i] < 0.02 && rawAccel[i] > -0.02)
                        {
                            rawAccel[i] = 0.0
                        }
                    }

                    numOfUpdate++
                    
                    //对加速度仪的加速度和陀螺仪的角速度设定初始估计值
                    if numOfUpdate == 1 {
                        self.accel.filteredAccel = rawAccel
                    }
                    
                    //对加速度和角速度的值经行kilman滤波
                    kilmanFilter(&self.accel.filteredAccel, &self.accel.Pk, rawAccel)
                    
                 //   self.accel.filteredAccel = rawAccel
                    var aNewToEarth = self.accel.filteredAccel
                    
                    
                    
                    for i in 0...2
                    {
                        if(aNewToEarth[i] < 0.02 && aNewToEarth[i] > -0.02)
                        {
                            aNewToEarth[i] = 0.0
                        }
                    }
                    
                    //显示当前时刻加速度仪的对地速度
                    self.ax.text = String(format: "%.2f", aNewToEarth[0])
                    self.ay.text = String(format: "%.2f", aNewToEarth[1])
                    self.az.text = String(format: "%.2f", aNewToEarth[2])
                    
                    //存入数据
                    let str : NSString = "\(aNewToEarth) \n"
                    self.CMdata.appendData(str.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!)
                    
                    
                    
                    //通过当前时刻的对地加速度和上一时刻的加速度，速度，位置获得当前时刻速度和位置
                    var oldPostion = self.accel.position
                    self.accel.renewPosition(aNewToEarth: aNewToEarth)
                    
                    //画出加速度仪运动的空间轨迹
                    self.drawLine(Float(oldPostion[0]), y0: Float(oldPostion[1]), z0: Float(oldPostion[2]), x1: Float(self.accel.position[0]), y1: Float(self.accel.position[1]), z1: Float(self.accel.position[2]))
                    
                    // MovementEndCheck

                    
                    
                    self.accel.movementEndCheck()
                    
                }
                

            })
        }
    }
    
    @IBAction func stopCollectData() {
        
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory = paths[0] as! String
        let fileName = "\(documentsDirectory)/textFile.txt"
        
        if manager.deviceMotionAvailable {
            manager.stopDeviceMotionUpdates()
            CMdata.writeToFile(fileName, atomically: true)
            accel.initParameter()
//            gyro.initParameter()
        }
    }
    
    @IBAction func clearView() {
        scene = SCNScene()
        sceneView.scene = scene
        drawLine(0, y0: 0, z0: 0, x1: 5, y1: 0, z1: 0)
        drawLine(0, y0: 0, z0: 0, x1: 0, y1: 5, z1: 0)
        drawLine(0, y0: 0, z0: 0, x1: 0, y1: 0, z1: 5)
    }
    
    func drawLine(x0 : Float, y0 : Float, z0 : Float, x1 : Float, y1 : Float, z1 : Float){
        let point0 = SCNVector3Make(x0, y0, z0)
        let point1 = SCNVector3Make(x1, y1, z1)
        let vertices : [SCNVector3] = [point0,point1]
        let geoSrc = SCNGeometrySource(vertices: UnsafePointer(vertices), count: vertices.count)
        let idx : [Int32] = [0,1]
        let data = NSData(bytes: idx, length:(sizeof(Int32) * idx.count))
        let geoElements = SCNGeometryElement(data: data, primitiveType: SCNGeometryPrimitiveType.Line, primitiveCount: idx.count, bytesPerIndex: sizeof(Int32))
        let geo = SCNGeometry(sources: [geoSrc], elements: [geoElements])
        let line = SCNNode(geometry: geo)
        scene.rootNode.addChildNode(line)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        sceneView.scene = scene
        sceneView.autoenablesDefaultLighting = true
        sceneView.allowsCameraControl = true
        self.view.addSubview(sceneView)
        sceneView.showsStatistics = true
        
        drawLine(0, y0: 0, z0: 0, x1: 0, y1: 0, z1: 10)
        drawLine(0, y0: 0, z0: 0, x1: 10, y1: 0, z1: 0)
        drawLine(0, y0: 0, z0: 0, x1: 0, y1: 10, z1: 0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

