//
//  ViewController.swift
//  CoreGraphicsDemo
//
//  Created by Raman choudhary on 09/11/22.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var sampleView: UIView!
    
    var person1:person?
    var person2:person?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.drawRectangle()
        let objPerson = person(name: "raman")
        person1 = objPerson
        person2 = objPerson
        objPerson.printName()
        person1 = nil
        person2 = nil
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        self.sampleView.addInnerShadow()
    }
    
    
    func drawRectangle(){
        let render = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
       let image = render.image { ctx in
//           let rectangle = CGRect(x: 0, y: 0, width: 512, height: 512)
//            ctx.cgContext.addRects([rectangle,rectangle2])
//            ctx.cgContext.setFillColor(UIColor.red.cgColor)
//           ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
//           ctx.cgContext.setLineWidth(10)
//           ctx.cgContext.drawPath(using: .fillStroke)
           
//           ctx.cgContext.setFillColor(UIColor.red.cgColor)
//           for row in 0..<8{
//               for col in 0..<8{
//                   if (row + col).isMultiple(of: 2){
//                       ctx.cgContext.fill(CGRect(x: col * 64, y: row * 64, width: 64, height: 64))
//                   }
//               }
//           }
           
//           ctx.cgContext.translateBy(x: 256, y: 256)
//           let rotation = 16
//           let amount = Double.pi / Double(rotation)
//           for _ in 0..<rotation{
//               ctx.cgContext.rotate(by: amount)
//               ctx.cgContext.addRect(CGRect(x: -128, y: -128, width: 256, height: 256))
//           }
//           ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
//           ctx.cgContext.strokePath()
           
           ctx.cgContext.translateBy(x: 256, y: 256)
           
           var first = true
           var length:CGFloat = 256
           for _ in 0..<256{
               ctx.cgContext.rotate(by: .pi/2)
               if first{
                   ctx.cgContext.move(to: CGPoint(x: length, y: 20))
                   first = false
               }else{
                   ctx.cgContext.addLine(to: CGPoint(x: length, y: 20))
               }
               length *= 0.99
           }
           ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
           ctx.cgContext.strokePath()
        }
        self.imageView.image = image
    }
}

extension UIView{
    func addInnerShadow(corner_radius:CGFloat,innerShadow:CALayer) {
        
      
        innerShadow.frame = bounds
               
        // Shadow path (1pt ring around bounds)
        let radius = corner_radius
        let path = UIBezierPath(roundedRect: innerShadow.bounds.insetBy(dx: -4, dy:-4), cornerRadius:radius)
        let cutout = UIBezierPath(roundedRect: innerShadow.bounds, cornerRadius:radius).reversing()

        path.append(cutout)
        innerShadow.shadowPath = path.cgPath
        innerShadow.masksToBounds = true
        // Shadow properties
        innerShadow.borderColor = UIColor.black.cgColor
        innerShadow.borderWidth = 1
        innerShadow.shadowColor = UIColor.black.cgColor
        innerShadow.shadowOffset = CGSize(width: 3, height: 3)
        innerShadow.shadowOpacity = 1
        innerShadow.shadowRadius = 4
        innerShadow.cornerRadius = corner_radius
        layer.addSublayer(innerShadow)
    }
    
    
}

class person{
    var name:String
    
    init(name: String) {
        print("init func of person called")
        self.name = name
    }
    
    deinit{
        print("deinit func of person called")
    }
    
    func printName(){
        print("name is \(name)")
    }
}


