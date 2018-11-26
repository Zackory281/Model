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

