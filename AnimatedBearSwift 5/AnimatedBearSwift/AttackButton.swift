//
//  MoveButton.swift
//  AnimatedBearSwift
//
//  Created by zencher on 2020/7/31.
//  Copyright © 2020 zencher. All rights reserved.
//

import SpriteKit
class AttackButton: SKSpriteNode,SKSceneDelegate{
    
    var player:SKSpriteNode?
    var boyWalkingFrames:[SKTexture]?
    var attacking = false
    let time:TimeInterval = 0.3
    func buildKatana(){


       
       let katana = SKSpriteNode(color: UIColor.brown, size: CGSize(width:60, height: 80))
//        print("武器原本位置\(katana.position)")
//        print("武器位置\(katana.position)")
        katana.zPosition = 2
        katana.physicsBody = SKPhysicsBody(rectangleOf: katana.size)
        katana.name = "katana"
        katana.physicsBody?.isDynamic = true
        katana.physicsBody?.affectedByGravity = false
        katana.alpha = 0
        player!.addChild(katana)
        katana.position = CGPoint(x: katana.position.x-50, y: katana.position.y)
        let fadOut1 = SKAction.fadeOut(withDuration: 1.5)
        let removeAll = SKAction.removeFromParent()
        let list = SKAction.sequence([fadOut1,removeAll])
        katana.run(list)
        katana.physicsBody?.categoryBitMask = Category.weapon
        katana.physicsBody?.collisionBitMask = 0
        katana.physicsBody?.contactTestBitMask = Category.monster
    }
    func bulidAttackBoy(){
        
        boyWalkingFrames?.removeAll()
        let boy1AnimatedAtlas = SKTextureAtlas(named: "boyImage2")


          let numImages = boy1AnimatedAtlas.textureNames.count
        
          for i in 1...numImages {
            let boyTextureName = "boyattack\(i)"
            boyWalkingFrames?.append(boy1AnimatedAtlas.textureNamed(boyTextureName))
//             print(boyWalkingFrames)
          }
    }
    func animateBoy() {
       

            let animate = SKAction.animate(with: boyWalkingFrames!,
                                           timePerFrame: 0.13,
                                           resize: false,
                                           restore: true)
        let wait = SKAction.wait(forDuration: 0.15)
        let list = SKAction.sequence([animate,wait])
            player!.run(list)
                
       
       
        
       
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        print("攻")
       

        
        let mytouches = touches as NSSet
        let touch: AnyObject? = mytouches.anyObject() as AnyObject
        print("主角\(touch?.tapCount)")
        if((touch?.tapCount)! <= 1){
            attacking = true
            bulidAttackBoy()
            animateBoy()
            
            buildKatana()
            
            player?.zPosition = 5
            DispatchQueue.main.asyncAfter(deadline:DispatchTime.now() + time) {
                
                
                self.touchesEnded(touches, with: .none)
            }


        }
        if((touch?.tapCount)! >= 2) {
            // 多拍
           removeAllActions()


        }
        
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("攻擊中")
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        attacking = false
       removeAllActions()
                
    }
}

