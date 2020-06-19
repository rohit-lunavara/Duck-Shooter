//
//  Target.swift
//  Challenge6
//
//  Created by Rohit Lunavara on 6/14/20.
//  Copyright © 2020 Rohit Lunavara. All rights reserved.
//

import UIKit
import SpriteKit

class Target: SKNode {
    var possibleSticks = ["stick0", "stick1", "stick2"]
    var possibleTargets = ["target1", "target2", "target3"]
    
    func setup() {
        let stick = possibleSticks.randomElement()!
        let stickNode = SKSpriteNode(imageNamed: stick)
        stickNode.position = CGPoint(x: 0, y: 0)
        addChild(stickNode)
        
        let target = possibleTargets.randomElement()!
        let targetNode = SKSpriteNode(imageNamed: target)
        targetNode.position = CGPoint(x: 0, y: stickNode.size.height - 10)
        stickNode.addChild(targetNode)
    }
}
