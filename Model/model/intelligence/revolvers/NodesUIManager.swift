//
//  NodesModelExtension.swift
//  Model
//
//  Created by Zackory Cramer on 11/4/18.
//  Copyright © 2018 Zackori Cui. All rights reserved.
//

import Foundation

class NodesUIManager: NSObject, OutputDelegate {
	
	weak var _modelActionDelegate: NodesModelActionDelegate?
	
	// Mark: NodeActionDelegate stubs
	func uiAddNodes(nodes: [Node]) {
		_modelActionDelegate?.uiAddNodes(nodes)
	}
	
	func moveNodes(points :Points, directions :[Direction]) {
		//		perPoint(points: points, meta: directions, function: {(x:IntC, y:IntC, dir:Direction) in
		//			print("x: \(x)")
		//		})
	}
}
