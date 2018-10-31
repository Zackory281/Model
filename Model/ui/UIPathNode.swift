//
//  UIPathNode.swift
//  Model
//
//  Created by Zackory Cramer on 10/30/18.
//  Copyright © 2018 Zackori Cui. All rights reserved.
//

import Foundation
import SpriteKit

class UIPathNode: SKShapeNode {
	
	init(_ x:Int, _ y:Int, orientations:[Direction]) {
		super.init()
		self.path = getPathNodeAt(x, y, orientations: orientations).path
		for dir in orientations {
			path = DIR_TO_PATH[dir]!
		}
		//(path as! CGMutablePath).addPath(path!)
		position = CGPoint(x: x * PATH_WIDTH - PATH_HALF_WIDTH, y: y * PATH_WIDTH - PATH_HALF_WIDTH)
		fillColor = NSColor.white
		lineWidth = 0
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

let w = PATH_HALF_WIDTH_CGF * 0.8
let DIR_TO_PATH: [Direction: CGPath] = [
	.UP: SKShapeNode(rect: CGRect(x: -w, y: -w, width: w * 2, height: w + PATH_HALF_WIDTH_CGF)).path!,
	.RIGHT: SKShapeNode(rect: CGRect(x: -w, y: -w, width: w + PATH_HALF_WIDTH_CGF + 10, height: w * 2)).path!,
	.LEFT: SKShapeNode(rect: CGRect(x: -w - PATH_HALF_WIDTH_CGF, y: -w, width: w * 2, height: w * 2)).path!,
	.DOWN: SKShapeNode(rect: CGRect(x: -w, y: -w - PATH_HALF_WIDTH_CGF, width: w * 2, height: w * 2)).path!,
]
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
