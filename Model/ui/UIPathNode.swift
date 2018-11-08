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
	
	func update(_ x: CGFloat, _ y: CGFloat, _ color: NSColor) {}
}
class UIPathNode: UINode {
	
	init(_ x:CGFloat, _ y:CGFloat, orientations:[Direction], _ color:NSColor = .white) {
		super.init()
		self.path = getPathForOrentation(ori: orientations)
		//(path as! CGMutablePath).addPath(path!)
		position = CGPoint(x: CGFloat(x) * PATH_WIDTH_CGF - PATH_HALF_WIDTH_CGF, y: CGFloat(y) * PATH_WIDTH_CGF - PATH_HALF_WIDTH_CGF)
		fillColor = color
		lineWidth = 0
		let label = SKLabelNode(text: orientations.description)
		label.fontSize = 12
		label.position = CGPoint(x: 200, y: 0)
		//self.addChild(label)
	}
	
	override func update(_ x: CGFloat, _ y: CGFloat, _ color: NSColor) {
		fillColor = color
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

class UIShapeNode: UINode {
	
	init(_ x:CGFloat, _ y:CGFloat, orientations:[Direction], _ color:NSColor = .white) {
		super.init()
		self.path = shapeNodePath
		position = CGPoint(x: CGFloat(x) * PATH_WIDTH_CGF - PATH_HALF_WIDTH_CGF, y: CGFloat(y) * PATH_WIDTH_CGF - PATH_HALF_WIDTH_CGF)
		print(color)
		fillColor = color
		strokeColor = NSColor.gray
		lineWidth = 1
	}
	
	override func update(_ x: CGFloat, _ y: CGFloat, _ color: NSColor) {
		position = CGPoint(x: x * PATH_WIDTH_CGF - PATH_HALF_WIDTH_CGF, y: y * PATH_WIDTH_CGF - PATH_HALF_WIDTH_CGF)
		fillColor = color
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

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
		path.addLine(to: CGPoint(x: -w, y: PATH_HALF_WIDTH_CGF))
		path.addLine(to: CGPoint(x: w, y: PATH_HALF_WIDTH_CGF))
	}
	path.addLine(to: CGPoint(x: w, y: w))
	if ori.contains(.RIGHT) {
		path.addLine(to: CGPoint(x: PATH_HALF_WIDTH_CGF, y: w))
		path.addLine(to: CGPoint(x: PATH_HALF_WIDTH_CGF, y: -w))
	}
	path.addLine(to: CGPoint(x: w, y: -w))
	if ori.contains(.DOWN) {
		path.addLine(to: CGPoint(x: w, y: -PATH_HALF_WIDTH_CGF))
		path.addLine(to: CGPoint(x: -w, y: -PATH_HALF_WIDTH_CGF))
	}
	path.addLine(to: CGPoint(x: -w, y: -w))
	if ori.contains(.LEFT) {
		path.addLine(to: CGPoint(x: -PATH_HALF_WIDTH_CGF, y: -w))
		path.addLine(to: CGPoint(x: -PATH_HALF_WIDTH_CGF, y: w))
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
