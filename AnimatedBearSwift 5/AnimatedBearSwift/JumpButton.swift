//
//  JumpBotton.swift
//  AnimatedBearSwift
//
//  Created by zencher on 2020/7/30.
//  Copyright © 2020 zencher. All rights reserved.
//

import SpriteKit
class JumpButton: SKSpriteNode {
   
    var player:SKSpriteNode?
    var touching = false
    var moving:Bool?
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
       
        
        //       let location = touch?.location(in: JumpBotton.init())
        if Float((player?.position.y)!) <= 100{
            touching = true
            moving = false
             player!.removeAllActions()
           if player!.xScale == CGFloat(1){
              
               player!.physicsBody?.applyImpulse(CGVector(dx: -40, dy:200 ))
            
           }else if player!.xScale == CGFloat(-1){
              
               player!.physicsBody?.applyImpulse(CGVector(dx: 40, dy:200 ))
            
           }
                 

        }
        if Float((player?.position.y)!) > 100{
            touching = false
        }
            
            
       

        
       
    }
    
   
    
    
        
}
