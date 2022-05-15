//
//  Monster.swift
//  AnimatedBearSwift
//
//  Created by zencher on 2020/7/29.
//  Copyright © 2020 zencher. All rights reserved.
//

import SpriteKit
class Monster : SKSpriteNode{
    var hp = 2
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("我被點擊了！！！")
    }
    
}
