//
//  UIGeometryNode.swift
//  Model
//
//  Created by Zackory Cramer on 11/13/18.
//  Copyright © 2018 Zackori Cui. All rights reserved.
//

import Foundation
import AppKit

class UIGeometryNode: UINode {
	init(nodeInterface: NodeIterface) {
		super.init()
		position = CGPoint(x: CGFloat(nodeInterface.point.0) * PATH_WIDTH_CGF, y: CGFloat(nodeInterface.point.1) * PATH_WIDTH_CGF)
		switch nodeInterface.geometry! {
		case let .Square(w, h):
			self.path = CGPath(rect: CGRect(x: PATH_WIDTH_CGF * 0.1, y: PATH_WIDTH_CGF * 0.1, width: PATH_WIDTH_CGF * CGFloat(w) - PATH_WIDTH_CGF * 0.2, height: PATH_WIDTH_CGF * CGFloat(h) - PATH_WIDTH_CGF * 0.2), transform: nil)
		default:
			break
		}
		self.fillColor = nodeInterface.color!
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
