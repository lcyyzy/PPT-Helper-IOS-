//
//  FuncofGyro.swift
//  SingleViewSceneKit
//
//  Created by Yuhao Zhang on 15/7/18.
//  Copyright (c) 2015年 Kawhi Lu. All rights reserved.
/*  这里定义了一个陀螺仪类， 
    它的属性包括：
        当前时刻kilman滤波后的角速度；filteredOmega: [Double]
        静止时刻时的角速度；staticOmega: [Double]
        当前时刻对应的四元数；q: [Double]
        更新周期；period: Double
        kilman滤波对应的协方差矩阵；Pk: Matrix
    它的方法包括：
        初始化所有参数值；initParameter()
        根据当前时刻的角速度值更新四元数的值；renewQuater()
        更具当前时刻的四元数计算出旋转矩阵的值; calculateRM() -> Matrix
*/

class Gyroscope {
    var filteredOmega: [Double] = [0.0, 0.0, 0.0]
    let staticOmega: [Double] = [0.0, 0.0, 0.0]
    var q: [Double] = [0.0, 0.0, 0.0, 1.0]
    var period: Double = 0.01
    lazy var Pk = Matrix(rows:3,columns:3,diag:10.0)
    
    func initParameter(){
        filteredOmega = [0.0, 0.0, 0.0]
        q = [0.0, 0.0, 0.0, 1.0]
        period = 0.01
        Pk = Matrix(rows:3,columns:3,diag:10.0)
    }
    
    func renewQuater(){
        var omega = [0.0, filteredOmega[0], filteredOmega[1],filteredOmega[2]]
        var k1 = [Double](count: 4, repeatedValue: 0.0)
        var k2 = [Double](count: 4, repeatedValue: 0.0)
        var k3 = [Double](count: 4, repeatedValue: 0.0)
        var k4 = [Double](count: 4, repeatedValue: 0.0)

        k1 = period/2.0 * omega * q
        k2 = period/2.0 * omega * (q + 0.5 * k1)
        k3 = period/2.0 * omega * (q + 0.5 * k2)
        k4 = period/2.0 * omega * (q + k3)
        k1 = k1 + 2.0 * k2 + 2.0 * k3 + k4
        q = q + 1.0/6.0 * k1
    }
    
    func calculateRM() -> Matrix{
        var C = Matrix()
        C[0,0] = q[0] * q[0] + q[1] * q[1] - q[2] * q[2] - q[3] * q[3]
        C[0,1] = 2 * (q[1] * q[2] - q[0] * q[3])
        C[0,2] = 2 * (q[1] * q[3] + q[0] * q[2])
        C[1,0] = 2 * (q[1] * q[2] + q[0] * q[3])
        C[1,1] = q[0] * q[0] - q[1] * q[1] + q[2] * q[2] - q[3] * q[3]
        C[1,2] = 2 * (q[2] * q[3] - q[0] * q[3])
        C[2,0] = 2 * (q[1] * q[3] - q[0] * q[2])
        C[2,1] = 2 * (q[2] * q[3] + q[0] * q[1])
        C[2,2] = q[0] * q[0] - q[1] * q[1] - q[2] * q[2] + q[3] * q[3]
        return C
    }
}

