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

let PATH_HALF_WIDTH_CGF:CGFloat = CGFloat(PATH_HALF_WIDTH)

class NodeScene : SKScene {
	
	var _inputDelegate:SceneInputDelegate?
	private var _tickLabel: SKLabelNode = SKLabelNode(text: "0")
	
	func changeTick(_ t: Int, _ success: Bool) {
		_tickLabel.text = String(t)
		_tickLabel.run(SKAction.customAction(withDuration: 0.2) { (node, time) in
			(node as! SKLabelNode).fontColor = COLOR_FOR_MODE[success ? .SUCCESS : .FAIL]! * (time / 0.2)
		})
	}
	
	func keyIsDown(_ code:UInt16) -> Bool {
		return _downKeys.contains(code)
	}
	
	override func sceneDidLoad() {
		_tickLabel.fontSize = 40
		_tickLabel.color = .white
		_tickLabel.fontName = "SF Mono"
		_tickLabel.position = CGPoint(x: size.width - _tickLabel.frame.width, y: size.height - _tickLabel.frame.height - 10)
		addChild(_tickLabel)
	}
	
	private var _downKeys: Set<UInt16> = Set<UInt16>()

	override func keyDown(with event: NSEvent) {
		guard !_downKeys.contains(event.keyCode) else { return }
	    _downKeys.insert(event.keyCode)
		_inputDelegate?.keyClicked(event.characters!)
	}
	
	override func keyUp(with event: NSEvent) {
		_downKeys.remove(event.keyCode)
	}
	
	override func mouseDragged(with event: NSEvent) {
		guard let inputDelegate = _inputDelegate else { return }
		let location = event.location(in: self)
		inputDelegate.mouseDragged(Int(location.x), Int(location.y))
	}
	
	override func mouseDown(with event: NSEvent) {
		guard let inputDelegate = _inputDelegate else { return }
		let location = event.location(in: self)
		inputDelegate.mouseDown(Int(location.x), Int(location.y))
	}
	
	override func mouseUp(with event: NSEvent) {
		guard let inputDelegate = _inputDelegate else { return }
		let location = event.location(in: self)
		inputDelegate.mouseUp(Int(location.x), Int(location.y))
	}
}

enum PATH_NODE_ORIENTATION {
	case DOWN_RIGHT
	case DOWN_UP
	case DOWN_LEFT
	case LEFT_RIGHT
}

enum COLOR_MODE {
	case SUCCESS
	case FAIL
}

let COLOR_FOR_MODE: [COLOR_MODE: NSColor] = [
	.SUCCESS: NSColor(red:0.30, green:0.85, blue:0.39, alpha:1.0),
	.FAIL: NSColor(red:1.00, green:0.23, blue:0.19, alpha:1.0)
]

protocol SceneInputDelegate {
	func mouseDown(_ x : Int, _ y : Int)
	func mouseUp(_ x : Int, _ y : Int)
	func mouseDragged(_ x : Int, _ y : Int)
	func keyClicked(_ c:String)
}

//func getPathNodeAt(_ x:Int, _ y:Int) -> SKShapeNode {
//	print("inser node at \(x), \(y)")
//	let pathNode = SKShapeNode(rect: CGRect(x: 0 - PATH_HALF_WIDTH, y: 0 - PATH_HALF_WIDTH, width: PATH_WIDTH, height: PATH_WIDTH))
//	pathNode.fillColor = NSColor.white
//	pathNode.lineWidth = 0
//	pathNode.position = CGPoint(x: x * PATH_WIDTH - PATH_HALF_WIDTH, y: y * PATH_WIDTH - PATH_HALF_WIDTH)
//	return pathNode
//}
