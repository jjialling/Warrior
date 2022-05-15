//
//  GameScene.swift
//  AnimatedBearSwift
//
//  Created by zencher on 2020/7/18.
//  Copyright © 2020 zencher. All rights reserved.
//
//testddd
import SpriteKit



class GameScene: SKScene

,SKPhysicsContactDelegate,UIGestureRecognizerDelegate,SKSceneDelegate{
    enum GameStatus {
       case idle
       case running
       case over
     }
    


    let background = SKSpriteNode(imageNamed: "game background")
    var MovingPing:SKShapeNode?
    var PaddleBorder:SKShapeNode?
    var touching:Bool = false
    // boy
    var boy = SKSpriteNode()
    var boyWalkingFrames: [SKTexture] = []
    var moving = false
    // monster
    var monsterWalkingFrames: [SKTexture] = []
    var monster = SKSpriteNode(imageNamed: "monster sprite1")
    var monsterDieCount: Int = 0
    var mCount: Int = 0
//    var monsterDieCount: Int = .random(in: 5...8)
//    var dieCount: Int = 1
    var dieCount: Int = .random(in: 4...6)
    // longNeckMonster
    let longNeck = SKSpriteNode(imageNamed: "long neck")
    var longNeckRemove:Bool = true

    var lnMonsterHP = 2



    let playableRect1: CGRect
    var lifeCount:Int = 0
    var lifeArray : [SKSpriteNode] = []
    var touch:Int = 0
    var attack:Int = 0

    var countM = 0
    var countP = 0
    var countL = 0
    
   

 
    var gameOver = false
    let endLabel = SKLabelNode(text: "Game Over")
    let endLabel2 = SKLabelNode(text: "Tap to restart!")
    let touchToBeginLabel = SKLabelNode(text: "Touch to begin!")
    let points = SKLabelNode(text: "0")
    var numPoints = 0
    // update
    var a :TimeInterval = .random(in: 5...7)
    var lastTime: TimeInterval = 0
    var dt: TimeInterval = 0
    var seconds: TimeInterval = 0
    var countMonster = 0
    // potion

    let potion = SKSpriteNode(imageNamed: "bottle")
    

    var randomPotion: Int = 0
    var pCount = 0

    var jumping = false




      // MARK: - Setup
  override func didMove(to view: SKView) {

    let swipeUp = UISwipeGestureRecognizer()
    swipeUp.addTarget(self, action:#selector(GameScene.swipedUp) )
    swipeUp.direction = .up
    
    self.view!.addGestureRecognizer(swipeUp)
    let pressed:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPress(sender:)))
    pressed.delegate = self
    pressed.minimumPressDuration = 0.15
    view.addGestureRecognizer(pressed)
    //手勢
    physicsWorld.contactDelegate = self
    
    background.position = CGPoint(x: size.width/2, y: size.height/2)
    background.zPosition = -1
    background.size.width = self.frame.width
    background.size.height = self.frame.height
    addChild(background)
    for _ in 1 ... 3{
        buildLife()
    }
    buildBoy()
    boy.physicsBody?.isDynamic = false
    buildGround()
    attackButton(player:boy,boyWalkingFrames: boyWalkingFrames)
    jumpButton(player:boy,moving: moving)
    moveButton()
    let collisionFrame = frame.insetBy(dx: 0, dy:-self.frame.height )
    physicsBody = SKPhysicsBody(edgeLoopFrom: collisionFrame)
    setupLabels()
   
    
    
  }
         // MARK: - 動作 SKPhysicsContactDelegate
    func didBegin(_ contact: SKPhysicsContact) {
        guard let bodyA = contact.bodyA.node,let bodyB = contact.bodyB.node else {
            return
        }
        if bodyA.physicsBody?.categoryBitMask == Category.boy && bodyB.physicsBody?.categoryBitMask == Category.monster || bodyB.physicsBody?.categoryBitMask == Category.boy && bodyA.physicsBody?.categoryBitMask == Category.monster{

            print("掉命")

            for child in self.children{
                
                if child.name == "life\(lifeCount)" {
                    child.removeFromParent()
                     lifeCount -= 1
                    print(lifeCount)
                }
            }
            if lifeCount == 0{
                boy.removeFromParent()
            }
            
        } else if bodyA.physicsBody?.categoryBitMask == Category.weapon && bodyB.physicsBody?.categoryBitMask == Category.monster || bodyB.physicsBody?.categoryBitMask == Category.weapon && bodyA.physicsBody?.categoryBitMask == Category.monster{

            if let monster = bodyA as? Monster{
               if monster.hp > 0 {
                monster.hp -= 1
                    if monster.hp <= 0{
                        monster.removeFromParent()
                        countMonster -= 1
                        numPoints+=1
                        monsterDieCount += 1
                        points.text = "\(numPoints)"
                        
                        }
                    }
//                if  lnMonsterHP > 0 {
//                    lnMonsterHP -= 1
//                    if lnMonsterHP <= 0 {
//                        longNeck.removeFromParent()
////                        settingPotion()
//                    }
//                }
//                if longNeckRemove == true{
//
//                    if monsterDieCount == dieCount {
//                        buildLongNeckMonster()
//                        longNeckMonsterMove(player: longNeck)
//                        monsterDieCount = 0
//                        dieCount = .random(in: 1...2)
//                        longNeckRemove = false
//                    }
//                }
                


                

            } else if let monster = bodyB as? Monster{
                if monster.hp > 0{
                    monster.hp -= 1
                    if monster.hp <= 0{
                        monster.removeFromParent()
                        countMonster -= 1
                        numPoints+=1
                        points.text = "\(numPoints)"
                        print(monsterDieCount)
                        monsterDieCount += 1
                        }
                 }

//                if longNeckRemove == true{
//                    if monsterDieCount == dieCount {
//                        buildLongNeckMonster()
//                        longNeckMonsterMove(player: longNeck)
//                        monsterDieCount = 0
//                        dieCount = .random(in: 1...2)
//                        longNeckRemove = false
//                    }
//
//
//
//                }
               

                
            }
           
        } else if bodyA.physicsBody?.categoryBitMask == Category.boy && bodyB.physicsBody?.categoryBitMask == Category.potion || bodyB.physicsBody?.categoryBitMask == Category.boy && bodyA.physicsBody?.categoryBitMask == Category.potion {

            print("撿起藥水")
            potion.removeFromParent()
            buildLife()



            
        } else if bodyA.physicsBody?.categoryBitMask == Category.weapon && bodyB.physicsBody?.categoryBitMask == Category.lnMonster || bodyB.physicsBody?.categoryBitMask == Category.weapon && bodyA.physicsBody?.categoryBitMask == Category.lnMonster{


            lnMonsterHP -= 1
            let alpha1 = SKAction.fadeAlpha(to: 0.7, duration: 0.3)
            longNeck.run(alpha1)

            if longNeckRemove == false{
                
                if lnMonsterHP == 0{

                    longNeck.removeFromParent()
                    let alpha2 = SKAction.fadeAlpha(to: 1, duration: 0.3)
                    longNeck.run(alpha2)
                    settingPotion()
                    lnMonsterHP = 2
                    longNeckRemove = true

                }


            }
//
            
//



        }else if bodyA.physicsBody?.categoryBitMask == Category.boy && bodyB.physicsBody?.categoryBitMask == Category.lnMonster || bodyB.physicsBody?.categoryBitMask == Category.boy && bodyA.physicsBody?.categoryBitMask == Category.lnMonster{
            print("碰到LongNeck")
        }
    }


    
   // MARK: - UIGestureRecognizerDelegate
   
    @objc func longPress(sender: UILongPressGestureRecognizer) {
        


    }
    @objc func swipedUp(sender: UISwipeGestureRecognizer) {

       
    }
  // MARK: - BuildObject
    func setupLabels() {
      // 1
      touchToBeginLabel.position = CGPoint(x: frame.size.width/2, y: frame.size.height/2)
      touchToBeginLabel.fontColor = UIColor.white
      touchToBeginLabel.fontSize = 50
      addChild(touchToBeginLabel)

      // 2
      points.position = CGPoint(x: frame.size.width-100, y: frame.size.height-100)
      points.fontColor = UIColor.white
      points.fontSize = 100
      addChild(points)
    }
    func endGame() {
    
      gameOver = true
   
      removeAllActions()
      
      endLabel.position = CGPoint(x: frame.size.width/2, y: frame.size.height/2)
      endLabel.fontColor = UIColor.white
      endLabel.fontSize = 50
      endLabel2.position = CGPoint(x: frame.size.width/2, y: frame.size.height/2 + endLabel.fontSize)
      endLabel2.fontColor = UIColor.white
      endLabel2.fontSize = 20
      points.fontColor = UIColor.white
      addChild(endLabel)
      addChild(endLabel2)
    }
    
// MARK: - BuildObject
    
    func buildLongNeckMonster(){
        longNeck.position = CGPoint(x: self.frame.maxX+200, y: 250)
        longNeck.size.width = self.frame.width/5.5
        longNeck.size.height = longNeck.size.width
        longNeck.physicsBody = SKPhysicsBody(rectangleOf: longNeck.size)
        longNeck.physicsBody?.isDynamic = false
        countL += 1
        longNeck.name = "LONGNECK \(countL)"
        longNeck.physicsBody?.categoryBitMask = Category.lnMonster
        longNeck.physicsBody?.collisionBitMask = Category.lnMonster
        longNeck.physicsBody?.contactTestBitMask = Category.weapon
        print(longNeck.position)
        addChild(longNeck)
        
    }
    
    func longNeckMonsterMove(player:SKNode){
//           let a: CGFloat = longNeck.position.x / self.frame.width * 9.0
           longNeck.run(SKAction.sequence([
//               SKAction.moveTo(y: 250, duration: 0.8),
               SKAction.scaleX(to: 1, duration: 0.1),
               SKAction.move(to: CGPoint(x: -200, y: 250), duration: 7),
               SKAction.repeatForever(SKAction.sequence([
                   SKAction.scaleX(to: -1, duration: 0.1),
                   SKAction.move(to: CGPoint(x: 1000, y: 250), duration: 7),
                   SKAction.scaleX(to: 1, duration: 0.1),
                   SKAction.move(to: CGPoint(x:-200, y: 250), duration: 7)]))]),withKey: "longNeck")
       }
    
    func buildLife() {
        lifeCount += 1
        let life = SKSpriteNode(imageNamed:"head")
        life.position = CGPoint(x: lifeCount*60-10, y: Int(self.frame.height)-50)
        lifeArray.append(life)
        life.name = "life\(lifeCount)"
        addChild(life)
        

        
    }
    func moveButton(){
        let paddleSize:CGSize = CGSize(width: size.height * 0.7 , height: size.height * 0.7)
        MovingPing = SKShapeNode(circleOfRadius: paddleSize.width * 0.18/1)
        MovingPing!.fillColor = UIColor.gray  //內圓黑色實心
        MovingPing!.zPosition = 7
        MovingPing!.alpha = 0.8
        PaddleBorder = SKShapeNode(circleOfRadius: paddleSize.width * 0.5/1.5)
       
        PaddleBorder!.fillColor = UIColor.clear //外圓中間空心
        PaddleBorder!.strokeColor = UIColor.gray
        MovingPing!.position = CGPoint(x: self.frame.maxX/9, y: self.frame.maxY/5)
        PaddleBorder!.position = CGPoint(x: self.frame.maxX/9, y: self.frame.maxY/5)
        addChild(MovingPing!)
        addChild(PaddleBorder!)
    }
    

    func buildGround(){
        let ground = SKSpriteNode(color: UIColor.blue, size: CGSize.init(width:900, height: 70))
            ground.alpha = 0
            ground.position = CGPoint(x: self.frame.midX, y: 0)
            ground.physicsBody = SKPhysicsBody(rectangleOf: ground.size)
            ground.physicsBody?.isDynamic = false
       
            addChild(ground)
       
    }
    
    func jumpButton(player:SKSpriteNode,moving:Bool) {
       
        let button = JumpButton(color: .blue, size: CGSize.init(width: frame.maxX/16*2, height: frame.maxY/8*2))
        button.position = CGPoint(x: frame.maxX-100, y:self.frame.midY )
        button.physicsBody = SKPhysicsBody(rectangleOf: button.size)
        button.physicsBody?.isDynamic = false
        button.alpha = 0.2
        button.isUserInteractionEnabled = true
        jumping = false
        button.player = player
        button.moving = moving
        button.physicsBody?.categoryBitMask = Category.jump
        button.physicsBody?.collisionBitMask = 0
        button.physicsBody?.contactTestBitMask = Category.monster
        addChild(button)
        
    }
    func attackButton(player:SKSpriteNode,boyWalkingFrames:[SKTexture]) {
       
        
        let button = AttackButton(color:.brown, size: CGSize.init(width: view!.frame.maxX/16*2, height: view!.frame.maxY/8*2))
        
        button.position = CGPoint(x: frame.maxX-100, y:frame.midY-100 )
        button.physicsBody = SKPhysicsBody(rectangleOf: button.size)
        button.physicsBody?.isDynamic = false
        button.alpha = 0.6
        button.isUserInteractionEnabled = true
        button.player = player
        button.boyWalkingFrames = boyWalkingFrames
        button.physicsBody?.categoryBitMask = Category.jump
        button.physicsBody?.collisionBitMask = 0
        button.physicsBody?.contactTestBitMask = Category.monster
        addChild(button)
       
    }
    
    
    func buildBoy() {
      let boyAnimatedAtlas = SKTextureAtlas(named: "boyImage")
      var walkFrames: [SKTexture] = []

      let numImages = boyAnimatedAtlas.textureNames.count

      for i in 1...numImages {
        let boyTextureName = "boy\(i)"
        walkFrames.append(boyAnimatedAtlas.textureNamed(boyTextureName))
      }
       
        
        boyWalkingFrames = walkFrames
        let firstFrameTexture = boyWalkingFrames[0]
        boy = SKSpriteNode(texture: firstFrameTexture)
       
        boy.isUserInteractionEnabled = true
        boy.size.width = self.frame.width * 1/6
        boy.size.height = boy.size.width
        boy.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        boy.position = CGPoint(x: 500, y:frame.height+100)
        
        boy.physicsBody = SKPhysicsBody(circleOfRadius: boy.size.height/3)
        boy.physicsBody?.allowsRotation = false
        boy.name = "BOY"
//        boy.physicsBody?.isDynamic = true
        
        boy.physicsBody?.categoryBitMask = Category.boy
        boy.physicsBody?.collisionBitMask = Category.boy
        boy.physicsBody?.contactTestBitMask = Category.monster
        
        addChild(boy)
        
    }
    
    // MARK: Potion
    
    func settingPotion() {

        potion.position = CGPoint(x: longNeck.position.x, y:longNeck.position.y+300 )


        potion.size.width = self.frame.width * 1/14
        potion.size.height = potion.size.width
        potion.physicsBody = SKPhysicsBody(rectangleOf: potion.size)

        countP += 1
        potion.name = "POTION \(countP)"

        potion.physicsBody?.categoryBitMask = Category.potion
        potion.physicsBody?.collisionBitMask = Category.potion
        potion.physicsBody?.contactTestBitMask = Category.boy
        addChild(potion)
    }
    
    func buildMonster(){
        let monsterAnimatedAtlas = SKTextureAtlas(named: "monster")
        var walkFrames: [SKTexture] = []

        let numImages = monsterAnimatedAtlas.textureNames.count
        
        for i in 1...numImages {
            let monsterTextureName = "monster\(i)"
            walkFrames.append(monsterAnimatedAtlas.textureNamed(monsterTextureName))
        }
        monsterWalkingFrames = walkFrames
        let firstFrameTexture = monsterWalkingFrames[0]
        monster = Monster(texture: firstFrameTexture)
        
        monster.isUserInteractionEnabled = true
//        monster = SKSpriteNode(texture: firstFrameTexture)
        var actualX = CGFloat.random(in: self.frame.minX ... self.frame.maxX)
        if  actualX >= boy.position.x-150 && actualX <= boy.position.x+150{
            actualX = 700
//            monster.removeFromParent() 還是會掉到男孩身上
        }else if actualX <= boy.position.x && actualX >= boy.position.x-150{
            actualX = 100
        }
        monster.position = CGPoint(x: actualX, y: self.frame.height)
        print("怪物位置\(monster.position)")
        monster.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        monster.size.width = self.frame.width * 1 / 8
        monster.size.height = self.frame.width * 1 / 10
        monster.zPosition = 0
        monster.physicsBody = SKPhysicsBody(rectangleOf:CGSize(width: 80, height: 90))
        monster.physicsBody?.allowsRotation = false
        monster.physicsBody?.isDynamic = false
        monster.physicsBody?.affectedByGravity = false

        countM += 1
        monster.name = "MONSTER \(countM)"

        monster.physicsBody?.categoryBitMask = Category.monster
        monster.physicsBody?.collisionBitMask = Category.monster
        monster.physicsBody?.contactTestBitMask = Category.boy
        addChild(monster)
        monsterMove(player:monster )
        animateMonster()
    }
    
    func animateMonster() {
      monster.run(SKAction.repeatForever(
              SKAction.animate(with: monsterWalkingFrames,
                         timePerFrame: 0.1,
                         resize: false,
                         restore: true)),
              withKey:"walkingInPlaceMonster")
    }
    
    func monsterMove(player:SKNode){
        let a: CGFloat = monster.position.x / self.frame.width * 9.0
        monster.run(SKAction.sequence([
            SKAction.moveTo(y: 50, duration: 0.8),
            SKAction.scaleX(to: -1, duration: 0.1),
            SKAction.move(to: CGPoint(x: 0 + monster.size.width/2, y: 50), duration: TimeInterval(a)),
            SKAction.repeatForever(SKAction.sequence([
                SKAction.scaleX(to: 1, duration: 0.1),
                SKAction.move(to: CGPoint(x: self.frame.width - monster.size.width/2, y: 50), duration: 7),
                SKAction.scaleX(to: -1, duration: 0.1),
                SKAction.move(to: CGPoint(x: 0 + monster.size.width/2, y: 50), duration: 7)]))]),withKey: "moveMonster")
    }
    
    func animateBoy() {
        
      boy.run(SKAction.repeatForever(
              SKAction.animate(with: boyWalkingFrames,
                         timePerFrame: 0.1,
                         resize: false,
                         restore: true)),
              withKey:"walkingInPlaceBoy")
        
        
    }
    
    func boyMoveEnded() {
      boy.removeAllActions()
    }
    
    func moveBoy(location: CGPoint) {
      // 1
      var multiplierForDirection: CGFloat
      
      // 2
      let bearSpeed = frame.size.width / 3.0
      
      // 3
      let moveDifference = CGPoint(x: location.x - boy.position.x, y: location.y - boy.position.y)
      let distanceToMove = sqrt(moveDifference.x * moveDifference.x + moveDifference.y * moveDifference.y)
      
      // 4
      let moveDuration = distanceToMove / bearSpeed
      
      // 5
      if moveDifference.x < 0 {
        multiplierForDirection = 1.0
      } else {
        multiplierForDirection = -1.0
      }
      boy.xScale = abs(boy.xScale) * multiplierForDirection
        // 1
      if boy.action(forKey: "walkingInPlaceBoy") == nil {
          // if legs are not moving, start them
          animateBoy()

      }

        
      let moveAction = SKAction.move(to: location, duration:(TimeInterval(moveDuration)))

        // 3
      let doneAction = SKAction.run({ [weak self] in
          self?.boyMoveEnded()
      })
        
        // 4
      let moveActionWithDone = SKAction.sequence([moveAction, doneAction])
        
        boy.run(moveActionWithDone, withKey:"boyMoving")
        
                
    }
    
    func boyFollowthebutton(){
        let a = Float(MovingPing!.position.x)
        let b = Float(PaddleBorder!.position.x)
    
        if a > b {
            moveBoy(location: CGPoint(x:self.frame.width,y: 80.0))
        }else if a < b {
            moveBoy(location: CGPoint(x: 0, y: 80.0))
        }


        
    }
   
    

    // MARK: Events
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
          print(jumping)
        if (!gameOver) {
            if boy.physicsBody?.isDynamic == false {
                boy.physicsBody?.isDynamic = true
                touchToBeginLabel.isHidden = true
               
          }
            if boy.zPosition <= CGFloat(4){
                 boy.zPosition = 5
            }
            
        } else if (gameOver) {
          let newScene = GameScene(size: size)
          newScene.scaleMode = scaleMode
            let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
         
          view?.presentScene(newScene, transition: reveal)
            
        }

        for touch in (touches ){
            let location = touch.location(in: self)
            if Float((boy.position.y)) <= 81{
                moving = true
                boyFollowthebutton()
                
                
            }
            if Float((boy.position.y)) > 81{
                moving = false
            }
            if((MovingPing!.contains(location))){
                touching = true
                  

            }else{
                touching = false
                
            }
        }
        
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
            
        if touching == true{
            
            if Float((boy.position.y)) <= 81{
                moving = true
                boyFollowthebutton()
                
            }
            if Float((boy.position.y)) > 81{
                moving = false
            }
            for touch in (touches ){
                let location = touch.location(in: self)
                let v = CGVector(dx: location.x-PaddleBorder!.position.x, dy: location.y-PaddleBorder!.position.y)
                let angle = atan2(v.dy, v.dx)
                let deg = angle*CGFloat(180 / Double.pi)
                //                  print(deg + 180)
                let length:CGFloat = PaddleBorder!.frame.size.width/2
//                let length:CGFloat = 60
                let xDist:CGFloat = sin(angle - 1.57079633 ) * length
                let yDist:CGFloat = cos(angle - 1.57079633) * length
                
                if((PaddleBorder!.frame.contains(location)))
                {
                    MovingPing!.position = location
                    
                }else{
                    MovingPing?.position = CGPoint(x: PaddleBorder!.position.x-xDist, y: PaddleBorder!.position.y+yDist)
                }
            }
        }
//        boyFollowthebutton()

        
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {

        
        if touching == true {
            let move = SKAction.move(to: PaddleBorder!.position, duration: 0.1)
            move.timingMode = .easeOut
            MovingPing?.run(move)
            boyMoveEnded()
        }
        
        

       }
    // MARK: update
    
    override func update(_ currentTime: TimeInterval) {
        if !gameOver {
            
            if lifeCount == 0{
               removeAllActions()
                endGame()
            }
            if boy.zPosition <= 4 {
                boy.zPosition = 5
            }
        }

        if lastTime > 0 {
            dt = currentTime - lastTime
            seconds += dt
        if seconds > a && countMonster < 5 && monster.position.x != boy.position.x + boy.size.width / 2 && monster.position.x != boy.position.x - boy.size.width / 2 {
            a = .random(in: 5...7)
            buildMonster()
            countMonster += 1
            seconds = 0
            }
        }
        lastTime = currentTime
       if longNeckRemove == true{
           
           if monsterDieCount == dieCount {
               buildLongNeckMonster()
               longNeckMonsterMove(player: longNeck)
               monsterDieCount = 0
               dieCount = .random(in: 4...6)
               longNeckRemove = false
           }
       }
       

    }
   
    override init(size: CGSize) {
        let maxAspectRatio:CGFloat = 16.0/9.0
        let playableHeight = size.width / maxAspectRatio
        let playableMargin = (size.height - playableHeight) / 2
        playableRect1 =  CGRect(x: 0, y: playableMargin, width: size.width, height: playableHeight)
        super.init(size:size)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
