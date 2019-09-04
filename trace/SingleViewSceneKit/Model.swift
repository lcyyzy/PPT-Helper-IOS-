//
//  Model.swift
//  SingleViewSceneKit
//
//  Created by Yuhao Zhang on 15/7/19.
//  Copyright (c) 2015年 Kawhi Lu. All rights reserved.
//

func startCollectData() {
    if manager.accelerometerAvailable {
        manager.accelerometerUpdateInterval = 0.02// 50Hz
        manager.startAccelerometerUpdatesToQueue(NSOperationQueue.mainQueue()) {
            [weak self] (data: CMAccelerometerData!, error: NSError!) in
            
            var ax = data.acceleration.x
            var ay = data.acceleration.y
            var az = data.acceleration.z
            
            // 前2秒时间的点先用来矫正加速度 0.1 * 100 = 10 个点
            // 0.1s后的时间用来做图
            if self?.collectPoint < 10
            {
                self?.collectPoint += 1
                self?.accelerationXNew += ax
                self?.accelerationYNew += ay
                self?.accelerationZNew += az
            }
            else
            {
                self?.collectPoint = 0
                self?.accelerationXNew /= 10
                self?.accelerationYNew /= 10
                self?.accelerationZNew /= 10
                
                //calibrate
                self?.accelerationXNew -= self!.sstatex
                self?.accelerationYNew -= self!.sstatey
                self?.accelerationZNew -= self!.sstatez
                
                self?.ax.text = String(format: "%.2f", self!.accelerationXNew)
                self?.ay.text = String(format: "%.2f", self!.accelerationYNew)
                self?.az.text = String(format: "%.2f", self!.accelerationZNew)
                
                let ansX1 = self?.nextVelocity(self!.accelerationX, acc_new: self!.accelerationXNew, vel: self!.velocityX)
                self?.accelerationXNew = ansX1!.accNewRet
                self?.velocityXNew = ansX1!.velNewRet
                let ansX2 = self?.nextPosition(self!.velocityX, vel_new : self!.velocityXNew, pos : self!.positionX)
                self?.positionXNew = ansX2!
                
                let ansY1 = self?.nextVelocity(self!.accelerationY, acc_new: self!.accelerationYNew, vel: self!.velocityY)
                self?.accelerationYNew = ansY1!.accNewRet
                self?.velocityYNew = ansY1!.velNewRet
                let ansY2 = self?.nextPosition(self!.velocityY, vel_new : self!.velocityYNew, pos : self!.positionY)
                self?.positionYNew = ansY2!
                
                let ansZ1 = self?.nextVelocity(self!.accelerationZ, acc_new: self!.accelerationZNew, vel: self!.velocityZ)
                self?.accelerationZNew = ansZ1!.accNewRet
                self?.velocityZNew = ansZ1!.velNewRet
                let ansZ2 = self?.nextPosition(self!.velocityZ, vel_new : self!.velocityZNew, pos : self!.positionZ)
                self?.positionZNew = ansX2!
                
                self?.drawLine(Float(self!.positionX), y0: Float(self!.positionY), z0: Float(self!.positionZ), x1: Float(self!.positionXNew), y1: Float(self!.positionYNew), z1: Float(self!.positionZNew))
                self?.setAVP()
                
            }
        }
    }
    
}

func drawLine(x0 : Float, y0 : Float, z0 : Float, x1 : Float, y1 : Float, z1 : Float)
{
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



