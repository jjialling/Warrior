//
//  GameViewController.swift
//  AnimatedBearSwift
//
//  Created by zencher on 2020/7/18.
//  Copyright © 2020 zencher. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    if let view = view as? SKView {
      // Create the scene programmatically
      let scene = GameScene(size: view.bounds.size)
      scene.scaleMode = .resizeFill
      view.ignoresSiblingOrder = true
      view.showsFPS = true
      view.showsNodeCount = true
//      view.showsPhysics = true
      view.presentScene(scene)
    }
  }
  
  override var prefersStatusBarHidden: Bool {
    return true
  }
}
