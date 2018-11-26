//
//  UIGeometryNode.swift
//  Model
//
//  Created by Zackory Cramer on 11/13/18.
//  Copyright © 2018 Zackori Cui. All rights reserved.
//

import Foundation
import AppKit
import SpriteKit

class UIGeometryNode: UINode {
	var hbar:SKShapeNode!
	init(nodeInterface: NodeIterface) {
		super.init()
		position = CGPoint(x: CGFloat(nodeInterface.point.0) * PATH_WIDTH_CGF, y: CGFloat(nodeInterface.point.1) * PATH_WIDTH_CGF)
		switch nodeInterface.geometry! {
		case let .Square(w, h):
			self.path = CGPath(rect: CGRect(x: PATH_WIDTH_CGF * 0.1, y: PATH_WIDTH_CGF * 0.1, width: PATH_WIDTH_CGF * CGFloat(w) - PATH_WIDTH_CGF * 0.2, height: PATH_WIDTH_CGF * CGFloat(h) - PATH_WIDTH_CGF * 0.2), transform: nil)
		case let .Triangle(points):
			let path = CGMutablePath()
			let p2 = toCGPoint(points[1])
			let p3 = toCGPoint(points[2])
			var sy: CGFloat
			if p2.y == 0.0 {
				sy = PATH_WIDTH_CGF * 0.1
			} else {
				sy = p2.y * PATH_WIDTH_CGF - PATH_WIDTH_CGF * 0.1
			}
			path.move(to: CGPoint(x: PATH_WIDTH_CGF * 0.1, y: sy))
			path.addLine(to: CGPoint(x: p2.x * PATH_WIDTH_CGF - PATH_WIDTH_CGF * 0.1, y: sy))
			var sx: CGFloat
			if p3.x == 0 {
				sx = PATH_WIDTH_CGF * 0.1
			} else {
				sx = p3.x * PATH_WIDTH_CGF - PATH_WIDTH_CGF * 0.1
			}
			path.addLine(to: CGPoint(x: sx, y: p3.y * PATH_WIDTH_CGF - sy))
			path.closeSubpath()
			self.path = path
		default:
			break
		}
		let path = CGMutablePath()
		path.move(to: CGPoint(x: -30, y: 0))
		path.addLine(to: CGPoint(x: 30, y: 0))
		let health = SKShapeNode(path: path)
		hbar = SKShapeNode(path: getBarline(nodeInterface.health!))
		health.position.y = 30
		health.strokeColor = NSColor.white
		health.lineWidth = 3
		hbar.strokeColor = NSColor.green
		hbar.lineWidth = 3
		hbar.position.y = 30
		hbar.zPosition = 12
		addChild(health)
		addChild(hbar)
		zPosition = GEONODE_Z
		alpha = 0.5
		self.fillColor = nodeInterface.color!
	}
	
	override func update(interface: NodeUpdateIterface) {
		hbar.path = getBarline(interface.health!)
	}
	
	private func getBarline(_ f: Float) -> CGPath {
		let hpath = CGMutablePath()
		hpath.move(to: CGPoint(x: -30, y: 0))
		hpath.addLine(to: CGPoint(x: -30 + 60 * CGFloat(f), y: 0))
		return hpath
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

