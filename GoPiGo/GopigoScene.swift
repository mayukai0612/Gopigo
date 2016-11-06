//
//  GopigoScene.swift
//  GoPiGo
//
//  Created by Yukai Ma on 29/10/2016.
//  Copyright © 2016 Monash. All rights reserved.
//


//MitrophD/Swift-SpriteKit-Analog-Stick
//
//  GameScene.swift
//
//  Created by Dmitriy Mitrophanskiy on 28.09.14.
//  Copyright (c) 2014 Dmitriy Mitrophanskiy. All rights reserved.
//

import SpriteKit

class GopigoScene: SKScene{
    
    let url = "http://118.138.94.188:8083/"
    let moveAnalogStick =  🕹(diameter: 110)
    let rotateAnalogStick = AnalogJoystick(diameter: 200)
   
  //  let webview = UIWebView(frame: CGRect(x:0, y:0, width:UIScreen.main.bounds.width, height:UIScreen.main.bounds.height))
    
    var direction: String?
    var backgroundQueue: DispatchQueue?
    
    override func didMove(to view: SKView) {
     
        /* Setup your scene here */
        backgroundColor = UIColor.clear
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
    
        //Analog stick
        moveAnalogStick.position = CGPoint(x: moveAnalogStick.radius + 15, y: moveAnalogStick.radius + 50)
      //  addChild(moveAnalogStick)
        
        rotateAnalogStick.position = CGPoint(x: self.frame.maxX - rotateAnalogStick.radius - 15, y:rotateAnalogStick.radius + 50)
        addChild(rotateAnalogStick)
        
        
        
        //MARK: Handlers begin
        
        moveAnalogStick.startHandler = {
        }
        
        moveAnalogStick.trackingHandler = { jData in
            
          //  print(jData.angular)
            let angular =  Double(jData.angular)
            let angle = (angular/Double.pi) * 180
           // print(angle)
            
        }
        
        moveAnalogStick.stopHandler = {
        }
        
        rotateAnalogStick.startHandler = {
            
            
            //start listening to analog stick
            if(self.backgroundQueue == nil)
            {
                self.sendRequest()
            }
            
        }
        rotateAnalogStick.trackingHandler = {  jData in
            //  print(jData.angular)
            let angular =  Double(jData.angular)
            let angle = (angular/Double.pi) * 180
           // print(jData.velocity)
            if (angle < 20 && angle > -20)
            {
                //up
                self.direction = "forward"
              //  print(self.direction!)

            }
            
            if (angle > 160 && angle <= 180 ||  angle < -160 && angle >= -180)
            {
                //down
                self.direction = "backward"
              //  print(self.direction!)

            }
            if (angle > 70 && angle < 110)
            {
                //left
                self.direction = "left"
                //print(self.direction!)

            }
            if (angle < -70 && angle > -110)
            {
                //right
                self.direction = "right"
               // print(self.direction!)
            }


        }
        
        rotateAnalogStick.stopHandler =  { jData in
            self.direction = "stop"
            print(self.direction)
        }
        
        //MARK: Handlers end
        
        let stickImage = UIImage(named: "jStick")
        let substrateImage =  UIImage(named: "jSubstrate")
        
        
        //set stick image
        
        moveAnalogStick.stick.image = stickImage
        rotateAnalogStick.stick.image = stickImage
        moveAnalogStick.substrate.image = substrateImage
        rotateAnalogStick.substrate.image = substrateImage
        
        
        
        
        view.isMultipleTouchEnabled = true
    }
    
    
      
    //Send request to control directions of the car
    func sendRequest()
    {
        
        
        
         self.backgroundQueue = DispatchQueue(label: "com.app.queue",
                                            qos: .background,
                                            target: nil)
        self.backgroundQueue?.async {
            
            let moveControl = MoveControl()
            while true{
            if(self.direction != nil){
                    sleep(1)
                moveControl.controlWheels(direction:self.direction!, url: self.url)
                    print("request thread")
                }
            }
        }
        
        }
    
        

       
    
    }
    
    
    


