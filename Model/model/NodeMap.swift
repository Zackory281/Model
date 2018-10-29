//
//  Map.swift
//  Model
//
//  Created by Zackory Cramer on 10/24/18.
//  Copyright © 2018 Zackori Cui. All rights reserved.
//

import Foundation
import GameplayKit

class NodeMap {
	
	private var _tailNodes:[PathNode]
	private var _nodeTree:NodeTree<PathNode>
	
	init() {
		_tailNodes = []
		_nodeTree = NodeTree()
	}
	
	func addNodeOnStep() {
		
	}
	
	func addTailNodes(tailNode:PathNode) {
		_tailNodes.append(tailNode)
	}
	
	func addShapeNodeToTail(shapeNode:ShapeNode) {
		shapeNode.setPathNode(pathNode: _tailNodes[0])
		_tailNodes[0].setShapeNode(node: shapeNode)
	}
	
	func toString() -> String {
		
		var m:[[UInt8]] = []
		for _ in 0..<8 {
			var l:[UInt8] = []
			for _ in 0..<8 {
				l.append(0)
			}
			m.append(l)
		}
		for no in _tailNodes {
			var head = no
			while head.hasNext() {
				m[head.getPoint()[1]][head.getPoint()[0]] = head.isFree() ? 1 : 2;
				head = head.next()
			}
			m[head.getPoint()[1]][head.getPoint()[0]] = head.isFree() ? 1 : 2
		}
		var str:String = ""
		for ll in m.reversed() {
			for i in ll {
				str += i == 0 ? "-" : i == 1 ? "0" : "*"
			}
			str += "\n"
		}
		return str
	}
}
