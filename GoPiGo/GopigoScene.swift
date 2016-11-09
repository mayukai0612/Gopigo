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
    
    //MARK: - Change car direction control Url here
    let url = "http://118.139.79.44:8083/"
    let moveAnalogStick =  🕹(diameter: 110)
    let rotateAnalogStick = AnalogJoystick(diameter: 150)
    
    
    var realTimeDirection: String?
    var tempDirection:String?
    var backgroundQueue: dispatch_queue_t?
    var flag:String = "reset"
    
    override func didMoveToView(view: SKView){
        
        /* Setup your scene here */
        backgroundColor = UIColor.clearColor()
        physicsBody = SKPhysicsBody(edgeLoopFromRect: frame)
        
        //Analog stick
        rotateAnalogStick.position = CGPoint(x: self.frame.maxX - rotateAnalogStick.radius - 15, y:rotateAnalogStick.radius + 100)
        addChild(rotateAnalogStick)
        
        
        
        //MARK: Handlers begin
        
        rotateAnalogStick.startHandler = {
            
            //   start listening to analog stick
            if(self.backgroundQueue == nil)
            {
                self.sendRequest()
            }
            
            self.flag = "start"
        }
        
        rotateAnalogStick.trackingHandler = {  jData in
            //  print(jData.angular)
            let angular =  Double(jData.angular)
            let pi = M_PI
            let angle = (angular/pi) * 180
            // print(jData.velocity)
            
            //forward
            if (angle < 10 && angle > -10)
            {
                //up
                self.realTimeDirection = "forward"
                //  print(self.direction!)
                
            }
            
            //backward
            if (angle > 170 && angle <= 180 ||  angle < -170 && angle >= -180)
            {
                //down
                self.realTimeDirection = "backward"
                //  print(self.direction!)
                
            }
            
            //left
            if (angle > 80 && angle < 100)
            {
                //left
                self.realTimeDirection = "left"
                //print(self.direction!)
                
            }
            
            //left forward
            if (angle > 35 && angle < 55)
            {
                //left forward
                self.realTimeDirection = "74PieDirection"
                //print(self.direction!)
                
            }
            
            //left backward
            if (angle > 125 && angle < 145)
            {
                //left forward
                self.realTimeDirection = "54PieDirection"
                //print(self.direction!)
                
            }
            
            //right
            if (angle < -80 && angle > -100)
            {
                //right
                self.realTimeDirection = "right"
                // print(self.direction!)
            }
            
            //right forward
            if (angle < -35 && angle > -55)
            {
                self.realTimeDirection = "14PieDirection"
            }
            
            //right backward
            if (angle < -125 && angle > -145)
            {
                self.realTimeDirection = "34PieDirection"
            }
            
            
            
        }
        
        rotateAnalogStick.stopHandler =  { jData in
            self.realTimeDirection = "stop"
            self.flag = "reset"
            
            //stop the car
            let moveControl = CarControl()
            moveControl.controlWheels(self.realTimeDirection!, url: self.url)

            print("stop")
        }
        
        //MARK: Handlers end
        
        let stickImage = UIImage(named: "jStick")
        let substrateImage =  UIImage(named: "jSubstrate")
        
        
        //set stick image
        
        moveAnalogStick.stick.image = stickImage
        rotateAnalogStick.stick.image = stickImage
        moveAnalogStick.substrate.image = substrateImage
        rotateAnalogStick.substrate.image = substrateImage
        
        
        
        
        view.multipleTouchEnabled = true
    }
    
    
    
    //Send request to control directions of the car
    func sendRequest()
    {
        
        //create a new thread for direction detection
        self.backgroundQueue = dispatch_queue_create("com.app.queue", nil)
        dispatch_async(self.backgroundQueue!) {
            
            let moveControl = CarControl()
            
            while true{
               
                //if the direction of car is changed, send the request to the remote server
                if(self.flag == "start" || self.flag == "changed" && self.realTimeDirection != nil){
                    
                    if(self.flag != "start"){
                        //send a direction control request
                        moveControl.controlWheels(self.realTimeDirection!, url: self.url)
                        print("request" + self.realTimeDirection!)
                    }
                    
                    //save real time direction to temp direction
                    self.tempDirection = self.realTimeDirection
                    if(self.tempDirection != nil){
                    print("temp:  " + self.tempDirection!)
                    }
                }
                
                
                
                //check the direction every 1 second, if temp direction equals to realtim direction
                if(self.tempDirection == self.realTimeDirection && self.flag != "reset")
                {
                    if(self.flag == "start")
                    {
                        //sleep one second
                        sleep(1)
                        if(self.tempDirection != self.realTimeDirection)
                        {
                            self.flag = "changed"
                            print("changed")
                        }
                        
                    }else{
                        self.flag = "unchanged"
                    }
                    
                  //  print("unchanged")

                }else if(self.tempDirection != self.realTimeDirection && self.flag != "reset")
                {
                    //sleep one second
                    sleep(1)
                    
                    if(self.tempDirection != self.realTimeDirection && self.flag != "reset")
                    {
                        self.flag = "changed"
                        print("changed")
                    }

                }
                
               
                
            }
        }
        
    }
    
}





