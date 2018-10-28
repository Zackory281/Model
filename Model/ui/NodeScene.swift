//
//  NodeScene.swift
//  Model
//
//  Created by Zackory Cramer on 10/27/18.
//  Copyright © 2018 Zackori Cui. All rights reserved.
//

import Foundation
import SpriteKit

class NodesModel : NSObject, SKSceneDelegate {
	
	private var _pathNodes:Set<SKNode>
	private var _scene:NodeScene
	
	init(scene:NodeScene) {
		_pathNodes = Set<SKNode>()
		_scene = scene
		super.init()
		addPathNodeAt(4, 5)
	}
	
	func addPathNodeAt(_ x:Int, _ y:Int) {
		let pathNode = SKShapeNode(circleOfRadius: 10)//SKShapeNode(rect: CGRect(x: 0 - PATH_HALF_WIDTH, y: 0 - PATH_HALF_WIDTH, width: PATH_WIDTH, height: PATH_WIDTH))
		pathNode.fillColor = NSColor.blue
		_scene.addChild(pathNode)
		_pathNodes.insert(pathNode)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

let PATH_WIDTH:Int = 30
let PATH_HALF_WIDTH:Int = PATH_WIDTH / 2

class NodeScene : SKScene {
	
}
