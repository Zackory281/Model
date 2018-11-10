//
//  UIPathNode.swift
//  Model
//
//  Created by Zackory Cramer on 10/30/18.
//  Copyright © 2018 Zackori Cui. All rights reserved.
//

import Foundation
import SpriteKit

class UINode: SKShapeNode {
	
	func update(interface: NodeUpdateIterface) {}
	deinit {
		print("I am deinitiated!")
	}
}
class UIPathNode: UINode {
	
	init(_ x:CGFloat, _ y:CGFloat, orientations:[Direction], _ color:NSColor = .white) {
		super.init()
		self.path = getPathForOrentation(ori: orientations)
		//(path as! CGMutablePath).addPath(path!)
		position = CGPoint(x: x * PATH_WIDTH_CGF - PATH_HALF_WIDTH_CGF, y: y * PATH_WIDTH_CGF - PATH_HALF_WIDTH_CGF)
		print(position)
		fillColor = color
		lineWidth = 1
		zPosition = PATHNODE_Z
		(alpha) = (0)
		run(SKAction.fadeAlpha(to: 0.5, duration: 0.05))
		//run(SKAction.scale(to: 1, duration: 0.05))
	}
	
	override func update(interface: NodeUpdateIterface) {
		if let color = interface.color {
			fillColor = color
		}
		if let orientations = interface.orientation {
			self.path = getPathForOrentation(ori: orientations)
		}
		if let taken = interface.taken {
			self.strokeColor = taken ? .red : .green
		}
//		(xScale, yScale) = (1.3, 1.3)
//		run(SKAction.fadeAlpha(to: 1, duration: 0.05))
//		run(SKAction.scale(to: 1, duration: 0.05))
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

class UIShapeNode: UINode {
	
	init(_ x:CGFloat, _ y:CGFloat, orientations:[Direction], _ color:NSColor = .white) {
		super.init()
		self.path = shapeNodePath
		position = CGPoint(x: x * PATH_WIDTH_CGF - PATH_HALF_WIDTH_CGF, y: y * PATH_WIDTH_CGF - PATH_HALF_WIDTH_CGF)
		print(color)
		fillColor = color
		strokeColor = NSColor.gray
		lineWidth = 1
		zPosition = SHAPENODE_Z
	}
	
	override func update(interface: NodeUpdateIterface) {
		let x = CGFloat(interface.point!.0 + 1)
		let y = CGFloat(interface.point!.1 + 1)
		//position.y = y
		//position = CGPoint(x: x * PATH_WIDTH_CGF - PATH_HALF_WIDTH_CGF, y: y * PATH_WIDTH_CGF - PATH_HALF_WIDTH_CGF)
		let time = Double(MOVING_TIME) / 60
		run(SKAction.group([
			SKAction.moveTo(x: x * PATH_WIDTH_CGF - PATH_HALF_WIDTH_CGF, duration: time),
			SKAction.moveTo(y: y * PATH_WIDTH_CGF - PATH_HALF_WIDTH_CGF, duration: time)]))
		if let state = interface.shapeState {
			strokeColor = STATE_TO_COLOR[state]!
		}
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

let STATE_TO_COLOR: [ShapeNodeState:NSColor] = [
	ShapeNodeState.Chilling : NSColor.red,
	ShapeNodeState.CanNowMoveWaiting : NSColor.yellow,
	ShapeNodeState.CanNowMove : NSColor.black,
	ShapeNodeState.Moving : NSColor.green,
]
let SHAPENODE_Z: CGFloat = 10
let PATHNODE_Z: CGFloat = 5

let w = PATH_HALF_WIDTH_CGF * 0.8
let ww = PATH_HALF_WIDTH_CGF * 0.6
let PATH_WIDTH_CGF = CGFloat(PATH_WIDTH)
let DIR_TO_PATH: [Direction: CGPath] = [
	.UP: SKShapeNode(rect: CGRect(x: -w, y: -w, width: w * 2, height: w + PATH_HALF_WIDTH_CGF)).path!,
	.RIGHT: SKShapeNode(rect: CGRect(x: -w, y: -w, width: w + PATH_HALF_WIDTH_CGF + 10, height: w * 2)).path!,
	.LEFT: SKShapeNode(rect: CGRect(x: -w - PATH_HALF_WIDTH_CGF, y: -w, width: w * 2, height: w * 2)).path!,
	.DOWN: SKShapeNode(rect: CGRect(x: -w, y: -w - PATH_HALF_WIDTH_CGF, width: w * 2, height: w * 2)).path!,
]

var shapeNodePath: CGPath = {
	let path = CGMutablePath()
	path.move(to: NSPoint(x: -ww, y: ww))
	path.addLine(to: CGPoint(x: ww, y: ww))
	path.addLine(to: CGPoint(x: ww, y: -ww))
	path.addLine(to: CGPoint(x: -ww, y: -ww))
	path.closeSubpath()
	return path
}()

func getPathForOrentation(ori: [Direction]) -> CGPath {
	let path = CGMutablePath()
	path.move(to: NSPoint(x: -w, y: w))
	if ori.contains(.UP) {
		path.addLine(to: CGPoint(x: -w, y: PATH_HALF_WIDTH_CGF * 1.2))
		path.addLine(to: CGPoint(x: w, y: PATH_HALF_WIDTH_CGF * 1.2))
	}
	path.addLine(to: CGPoint(x: w, y: w))
	if ori.contains(.RIGHT) {
		path.addLine(to: CGPoint(x: PATH_HALF_WIDTH_CGF * 1.2, y: w))
		path.addLine(to: CGPoint(x: PATH_HALF_WIDTH_CGF * 1.2, y: -w))
	}
	path.addLine(to: CGPoint(x: w, y: -w))
	if ori.contains(.DOWN) {
		path.addLine(to: CGPoint(x: w, y: -PATH_HALF_WIDTH_CGF * 1.2))
		path.addLine(to: CGPoint(x: -w, y: -PATH_HALF_WIDTH_CGF * 1.2))
	}
	path.addLine(to: CGPoint(x: -w, y: -w))
	if ori.contains(.LEFT) {
		path.addLine(to: CGPoint(x: -PATH_HALF_WIDTH_CGF * 1.2, y: -w))
		path.addLine(to: CGPoint(x: -PATH_HALF_WIDTH_CGF * 1.2, y: w))
	}
	path.closeSubpath()
	return path
}
func getPathNodeAt(_ x:Int, _ y:Int, orientations: [Direction]) -> SKShapeNode {
	let w = PATH_HALF_WIDTH_CGF * 0.8
	var bytes: [CGPoint] = [CGPoint(x: -w, y: w), CGPoint(x: w, y: w),
							CGPoint(x: w, y: w),
							CGPoint(x: w, y: w), CGPoint(x: w, y: -w),
							CGPoint(x: w, y: -w),
							CGPoint(x: w, y: -w), CGPoint(x: -w, y: -w),
							CGPoint(x: -w, y: -w),
							CGPoint(x: -w, y: -w), CGPoint(x: -w, y: w),
							]
	for dir in orientations {
		switch dir {
		case .UP:
			bytes[0].y = PATH_HALF_WIDTH_CGF * 2
			bytes[1].y = PATH_HALF_WIDTH_CGF
		case .DOWN:
			bytes[5].y = PATH_HALF_WIDTH_CGF
			bytes[6].y = PATH_HALF_WIDTH_CGF
		default:
			break;
		}
	}
	let uint8Pointer = UnsafeMutablePointer<CGPoint>.allocate(capacity: 12)
	uint8Pointer.initialize(from: &bytes, count: 12)
	let node = SKShapeNode(rect: CGRect(x: -w, y: -w, width: w * 2, height: w * 2))//(points: uint8Pointer, count: 12)
	free(uint8Pointer)
	node.fillColor = NSColor.white
	node.lineWidth = 0
	return node
}
