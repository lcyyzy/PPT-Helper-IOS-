//
//  classMatrix.swift
//  SingleViewSceneKit
//
//  Created by Yuhao Zhang on 15/7/18.
//  Copyright (c) 2015年 Kawhi Lu. All rights reserved.

/*  这里定义了一个矩阵类，以及关于矩阵运算的一系列函数
这些函数包括：
求矩阵 m 的转置矩阵; T(m:Matrix) -> Matrix
求矩阵 m 在i,j位置的余子式; remainM(m:Matrix,row:Int,column:Int)->Matrix
求矩阵 m 的伴随矩阵; adjointM(m: Matrix)->Matrix
求矩阵 m 的逆矩阵; inv(m: Matrix) -> Matrix
求矩阵 m 的行列式; det(m:Matrix) -> Double
同时还重载了一系列关于矩阵和向量运算的操作符，目前包括：
+： 对矩阵和向量对应每一项相加
-： 对矩阵和向量对应每一项相减
*： 向量和向量，浮点数和向量，矩阵和向量，矩阵与矩阵的乘法
/： 矩阵与一个常数相除，即矩阵的每一项除以该常数
*/

import Foundation
struct Matrix {
    let rows: Int, columns: Int
    var grid: [Double]
    
    init(){
        rows = 3
        columns = 3
        grid = Array(count: rows*columns, repeatedValue: 0.0)
    }
    init(rows: Int, columns: Int){
        self.rows = rows
        self.columns = columns
        grid = Array(count: rows*columns, repeatedValue: 0.0)
    }
    init(rows: Int, columns: Int,diag: Double){
        self.rows = rows
        self.columns = columns
        grid = Array(count: rows*columns, repeatedValue: 0.0)
        for var i = 0 ; i < rows ; ++i{
            for var j = 0 ; j < columns ; ++j{
                if i == j {
                    grid[i * columns + j] = diag
                } else {
                    grid[i * columns + j] = 0.0
                }
            }
        }
    }
    
    func indexIsValid(row: Int,column: Int) -> Bool{
        return row >= 0 && row <= rows && column >= 0 && column <= columns
    }
    
    subscript(row: Int,column: Int) -> Double{
        get{
            assert(indexIsValid(row, column: column), "Index out of range")
            return grid[row * columns + column]
        }
        set{
            assert(indexIsValid(row, column: column), "Index out of range")
            grid[row * columns + column] = newValue
        }
    }
}

func *(matrix: Matrix,vector: [Double]) -> [Double]{
    assert(matrix.columns == vector.count,"This matrix doesn't match the vector" )
    var newVector = [Double](count: matrix.rows, repeatedValue: 0.0)
    for var i = 0 ; i < matrix.rows ; ++i{
        for var j = 0 ; j < matrix.columns ; ++j{
            newVector[i] += matrix[i,j] * vector[j]
        }
    }
    return newVector
}

func *(m1: Matrix,m2: Matrix) -> Matrix{
    assert(m1.columns == m2.rows,"matrixs don't match")
    var newM = Matrix(rows:m1.rows,columns:m2.columns)
    for var i = 0 ; i < newM.rows; ++i{
        for var j = 0;j < newM.columns; ++j{
            for var k = 0;k < m1.columns; ++k{
                newM[i,j] += m1[i,k] * m2[k,j]
            }
        }
    }
    return newM
}

func *(v1: [Double], v2: [Double]) -> [Double]{
    assert(v1.count == v2.count,"vectors don't match")
    var newV = [Double](count:v1.count, repeatedValue: 0.0)
    for var i = 0 ; i < newV.count; ++i{
        newV[i] = v1[i] * v2[i]
    }
    return newV
}

func *(num: Double, v2: [Double]) -> [Double]{
    var newV = [Double](count:v2.count, repeatedValue: 0.0)
    for var i = 0 ; i < newV.count; ++i{
        newV[i] = num * v2[i]
    }
    return newV
}

func +(m1: Matrix,m2: Matrix) -> Matrix{
    assert(m1.rows == m2.rows && m1.columns == m2.columns,"Matrix cann't be added")
    var newM = Matrix()
    for var i = 0 ; i < m1.rows ; ++i{
        for var j = 0 ; j < m1.columns ; ++j{
            newM[i,j] = m1[i,j] + m2[i,j]
        }
    }
    return newM
}

func +(v1: [Double],v2: [Double]) -> [Double]{
    assert(v1.count == v2.count,"Vectors cann't be added")
    var newV = [Double](count: v1.count,repeatedValue: 0.0)
    for var i = 0 ; i < v1.count ; ++i{
        newV[i] = v1[i] + v2[i]
    }
    return newV
}

func -(m1: Matrix,m2: Matrix) -> Matrix{
    assert(m1.rows == m2.rows && m1.columns == m2.columns,"Matrix cann't be added")
    var newM = Matrix()
    for var i = 0 ; i < m1.rows ; ++i{
        for var j = 0 ; j < m1.columns; ++j{
            newM[i,j] = m1[i,j] - m2[i,j]
        }
    }
    return newM
}

func -(v1:[Double],v2:[Double]) -> [Double]{
    assert(v1.count == v2.count,"Vectors cann't be added")
    var newV = [Double](count:v1.count,repeatedValue:0.0)
    for var i = 0 ; i < v1.count ; ++i{
        newV[i] = v1[i] - v2[i]
    }
    return newV
}

func /(m:Matrix,num:Double)->Matrix{
    var temp = Matrix(rows:m.rows,columns:m.columns)
    for var i = 0; i < m.rows; ++i{
        for var j = 0; j < m.columns ; ++j{
            temp[i,j] = m[i,j] / num
        }
    }
    return temp
}

func T(m:Matrix) -> Matrix{
    var temp = Matrix(rows:m.rows,columns:m.columns)
    for var i = 0 ; i < m.rows ; ++i{
        for var j = 0;j < m.columns ; ++j{
            temp[i,j] = m[j,i]
        }
    }
    return temp
}

func remainM(m:Matrix,row:Int,column:Int)->Matrix{
    var temp=Matrix(rows:m.rows-1,columns:m.columns-1)
    var k:Int=0
    var l:Int
    for var i = 0 ; i < m.rows ; ++i{
        l = 0
        for var j = 0 ; j < m.columns ; ++j{
            if i != row&&j != column{
                temp[k,l] = m[i,j]
            }
            if j != column {
                l++
            }
        }
        if i != row {
            k++
        }
    }
    return temp
}

func det(m:Matrix) -> Double{
    assert(m.rows == m.columns,"this Matrix has no determinant")
    if m.rows == 1{
        return m[0,0]
    } else {
        var deter = 0.0
        for var i = 0 ; i < m.columns ; ++i{
            deter += pow(-1.0,Double(i)) * m[0,i] * det(remainM(m,row: 0,column: i))
        }
        return deter
    }
}

func adjointM(m: Matrix)->Matrix{
    var temp = Matrix(rows:m.rows,columns:m.columns)
    for var i = 0; i < temp.rows; ++i{
        for var j = 0;j < temp.columns; ++j{
            temp[i,j] = pow(-1.0,Double(i+j)) * det(remainM(m,row: j,column: i))
        }
    }
    return temp
}

func inv(m: Matrix) -> Matrix{
    assert(det(m) != 0,"Inverse matrix doesn't exist")
    return adjointM(m) / det(m)
}