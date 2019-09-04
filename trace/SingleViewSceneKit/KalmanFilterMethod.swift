//
//  KalmanFilterMethod.swift
//  SingleViewSceneKit
//
//  Created by Yuhao Zhang on 15/7/19.
//  Copyright (c) 2015年 Kawhi Lu. All rights reserved.

/*
    zk: 我们每次的实际测量值
    xk: 根据加速度的实际测量值得到的加速度的估计值
    函数kilmanFilter的返回值xk为经过滤波后的数据估计值，Pk为滤波后的数据协方差矩阵
*/

func kilmanFilter(inout xk: [Double], inout Pk: Matrix, zk:[Double]){
    let A = Matrix(rows: 3, columns: 3, diag: 1.0)
//    可调
    let Q = Matrix(rows: 3, columns: 3, diag: 0.001)
//    可调
    let R = Matrix(rows: 3, columns: 3, diag: 0.01)
    let H = Matrix(rows: 3, columns: 3, diag: 1.0)
    let I3 = Matrix(rows: 3, columns: 3, diag: 1.0)
    var Kg = Matrix()
    
    Pk = (A * Pk * T(A) + Q)
    Kg = (Pk * T(H) * inv(H * Pk * T(H) + R))
    xk = (A * xk + Kg * (zk - H * (A * xk)))
    Pk = ((I3 - Kg * H) * Pk)
}