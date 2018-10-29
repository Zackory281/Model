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
	private var _scene:SKScene
	
	init(scene:SKScene) {
		_pathNodes = Set<SKNode>()
		_scene = scene
		_scene.backgroundColor = NSColor.black
		super.init()
		addPathNodeAt(4, 4)
		addPathNodeAt(3, 3)
	}
	
	func addPathNodeAt(_ x:Int, _ y:Int) {
		let pathNode = getPathNodeAt(x, y)
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

func getPathNodeAt(_ x:Int, _ y:Int) -> SKShapeNode{
	let pathNode = SKShapeNode(rect: CGRect(x: 0 - PATH_HALF_WIDTH, y: 0 - PATH_HALF_WIDTH, width: PATH_WIDTH, height: PATH_WIDTH))
	pathNode.fillColor = NSColor.white
	pathNode.lineWidth = 0
	pathNode.position = CGPoint(x: x * PATH_WIDTH - PATH_HALF_WIDTH, y: y * PATH_WIDTH - PATH_HALF_WIDTH)
	return pathNode
}
