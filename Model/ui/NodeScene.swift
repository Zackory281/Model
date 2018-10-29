//
//  NodeScene.swift
//  Model
//
//  Created by Zackory Cramer on 10/27/18.
//  Copyright © 2018 Zackori Cui. All rights reserved.
//

import Foundation
import SpriteKit

let PATH_WIDTH:Int = 30
let PATH_HALF_WIDTH:Int = PATH_WIDTH / 2

class NodeScene : SKScene {
	
	var inputDelegate:SceneInputDelegate?
	
	override func mouseDragged(with event: NSEvent) {
		guard let inputDelegate = inputDelegate else { return }
		let location = event.location(in: self)
		inputDelegate.mouseDragged(Int(location.x), Int(location.y))
	}
	
	override func mouseDown(with event: NSEvent) {
		guard let inputDelegate = inputDelegate else { return }
		let location = event.location(in: self)
		inputDelegate.mouseDown(Int(location.x), Int(location.y))
	}
	
	override func mouseUp(with event: NSEvent) {
		guard let inputDelegate = inputDelegate else { return }
		let location = event.location(in: self)
		inputDelegate.mouseUp(Int(location.x), Int(location.y))
	}
}

protocol SceneInputDelegate {
	func mouseDown(_ x : Int, _ y : Int)
	func mouseUp(_ x : Int, _ y : Int)
	func mouseDragged(_ x : Int, _ y : Int)
}

func getPathNodeAt(_ x:Int, _ y:Int) -> SKShapeNode{
	let pathNode = SKShapeNode(rect: CGRect(x: 0 - PATH_HALF_WIDTH, y: 0 - PATH_HALF_WIDTH, width: PATH_WIDTH, height: PATH_WIDTH))
	pathNode.fillColor = NSColor.white
	pathNode.lineWidth = 0
	pathNode.position = CGPoint(x: x * PATH_WIDTH - PATH_HALF_WIDTH, y: y * PATH_WIDTH - PATH_HALF_WIDTH)
	return pathNode
}
