//
//  CircularProgressView.swift
//  AMP
//
//  Created by apple on 24/08/21.
//

import Foundation
import UIKit

@IBDesignable public class CircularProgressView: UIView {
    fileprivate var progressLayer = CAShapeLayer()
    fileprivate var trackLayer = CAShapeLayer()
    fileprivate let filled:Bool = false
    fileprivate let rounded:Bool = false
    
    @IBInspectable var lineWidth:CGFloat = 0
    @IBInspectable var progress:CGFloat = 0.5
    @IBInspectable var trackColor:UIColor = .red
    @IBInspectable var progressColor:UIColor = .blue
    

    
    override public func draw(_ rect: CGRect) {
        self.createProgressView(frame: rect)
    }
    
    fileprivate func circularFillCgPath(){
        guard let context = UIGraphicsGetCurrentContext() else{return}
        let rectangle = bounds.insetBy(dx: lineWidth / 2, dy: lineWidth / 2)
        context.setLineWidth(lineWidth)
        context.setFillColor(trackColor.cgColor)
        context.setStrokeColor(progressColor.cgColor)
        context.addEllipse(in: rectangle)
        context.drawPath(using: .fillStroke)
    }
    
    fileprivate func createProgressView(frame:CGRect){
        self.backgroundColor = .clear
        self.layer.cornerRadius = frame.size.width / 2
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: frame.midX, y: frame.midY), radius: frame.width / 2, startAngle: CGFloat(-0.5 * .pi), endAngle: CGFloat(1.5 * .pi), clockwise: true)
        trackLayer.path = circularPath.cgPath
        trackLayer.fillColor = .none
        trackLayer.strokeColor = trackColor.cgColor
        if filled {
            trackLayer.lineCap = .butt
            trackLayer.lineWidth = frame.width
        }else{
            trackLayer.lineWidth = lineWidth
        }
        trackLayer.strokeEnd = 1
        layer.addSublayer(trackLayer)
        
        progressLayer.path = circularPath.cgPath
        progressLayer.fillColor = .none
        progressLayer.strokeColor = progressColor.cgColor
        if filled {
            progressLayer.lineCap = .butt
            progressLayer.lineWidth = frame.width
        }else{
            progressLayer.lineWidth = lineWidth
        }
        progressLayer.strokeEnd = progress
        if rounded{
            progressLayer.lineCap = .round
        }
        layer.addSublayer(progressLayer)
    }
}

