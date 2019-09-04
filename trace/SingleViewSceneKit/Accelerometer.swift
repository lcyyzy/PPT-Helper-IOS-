//
//  Accelerometer.swift
//  SingleViewSceneKit
//
//  Created by Yuhao Zhang on 15/7/24.
//  Copyright (c) 2015年 Kawhi Lu. All rights reserved.
//

/*
    这里定义了一个加速度仪类;
    它的属性包括：
        kalman滤波后的加速度； filteredAccel: [Double]
        当前时刻加速度仪对地的加速度；accelToEarth: [Double]
        静止时加速度仪的零点漂移； staticAccel: [Double]
        当前时刻加速度仪的速度； velocity: [Double]
        当前时刻加速度以的位置； position: [Double]
        加速度仪的更新周期； position: [Double]
        加速度仪在kalman滤波时的协方差矩阵； Pk = Matrix(rows:3,columns:3,diag:10.0)
    它的方法包括：
        初始化所有参数值； initParameter()
        根据下一时刻的加速度值更新加速度仪的对地加速度，速度和位置

    同时这里还定义了一个用kalman滤波后的加速度，以及旋转矩阵，计算对地加速度的函数； 
        accelTrans(#accelToDevice: [Double], RM: Matrix) -> [Double]
        
*/


class Accelerometer {
    var filteredAccel: [Double] = [0.0, 0.0, 0.0]
    var accelToEarth: [Double] = [0.0, 0.0, 0.0]
    let staticAccel: [Double] = [0.0, 0.0, 0.0]
    var velocity: [Double] = [0.0, 0.0, 0.0]
    var position: [Double] = [0.0, 0.0, 0.0]
    var period: Double = 0.01
    
    var countOfZeroAccel: [Int] = [0, 0, 0]
    
    
    // Pk  可调
    lazy var Pk = Matrix(rows:3,columns:3,diag:10.0)
    
    func initParameter(){
        filteredAccel = [0.0, 0.0, 0.0]
        accelToEarth = [0.0, 0.0, 0.0]
        velocity = [0.0, 0.0, 0.0]
        position = [0.0, 0.0, 0.0]
        countOfZeroAccel = [0,0,0,]
        period = 0.01
        Pk = Matrix(rows:3,columns:3,diag:10.0)
    }
    
    func renewPosition(#aNewToEarth: [Double]){
        var vNew = velocity + 0.5 *  (accelToEarth + aNewToEarth)
        var pNew = position + 0.5 * (velocity + vNew)
        accelToEarth = aNewToEarth
        velocity = vNew
        position = pNew
    }
    
    func movementEndCheck()
    {
        for i in 0...2
        {
            if accelToEarth[i] == 0
            {
                countOfZeroAccel[i]++
            }
            else
            {
                countOfZeroAccel[i] = 0
            }
            if countOfZeroAccel[i] >= 3
            {
                velocity[i] = 0.0
            }
            
        }
    }
}

func accelTrans(#accelToDevice: [Double], RM: Matrix) -> [Double]{
    let G = [0.0, 0.0, -1.0]
    let g = 9.81
    var accelToEarth = [0.0, 0.0, 0.0]
    assert(RM.columns == accelToDevice.count, "Dimensions don't match")
    accelToEarth = T(RM) * accelToDevice - G
    accelToEarth = g * accelToEarth
    return accelToEarth
}
