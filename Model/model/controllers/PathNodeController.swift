//
//  Map.swift
//  Model
//
//  Created by Zackory Cramer on 10/24/18.
//  Copyright © 2018 Zackori Cui. All rights reserved.
//

import Foundation

class PathNodeController {
	
	private var _tailNodes:[PathNode]
	private var _nodeTree:NodeTree<PathNode>
	private var _headNodes: Set<PathNode>
	weak var _nodeActionDelegate: OutputDelegate?
	
	func addNodeOnStep() {
		
	}
	
	func addPathNodeAt(_ x:IntC, _ y:IntC) {
		//_nodeTree.addPathNode(pathNode: PathNode.init(x, y))
		// TODO: fix me!
		let node = PathNode(x, y)
		guard addNodeIntoTree(node: node) else { print("insertion of node into tree failed"); return}
		_nodeTree.addNode(node: node)
		_nodeActionDelegate?.uiAddNodes(nodes: [node])
	}
	
	func addTailNodes(tailNode:PathNode) {
		_tailNodes.append(tailNode)
	}
	
	func addHeadNode(_ head: PathNode) {
		guard addNodeIntoHeadSet(node: head) else { print("insertion into head set failed"); return}
		var head: PathNode? = head
		var points: Points = []
		var nodes: [Node] = []
		repeat{
			guard addNodeIntoTree(node: head!) else {
				print("insertion of seg node into tree failed");
				break
			}
			points.append(contentsOf: head!.getPoint())
			nodes.append(head!)
			head = head?.prev()
		} while head != nil
		_nodeActionDelegate?.uiAddNodes(nodes: nodes)
	}
	
	func addShapeNodeToTail(shapeNode:ShapeNode) {
		shapeNode.setPathNode(pathNode: _tailNodes[0])
		_tailNodes[0].setShapeNode(node: shapeNode)
	}
	
	func getPathNodeAt(_ x: IntC, _ y: IntC) -> PathNode?{
		return _nodeTree.getNodesAt(x, y).first
	}
	
	init(width: IntC, height: IntC) {
		_nodeTree = NodeTree<PathNode>.init(width: width, height: height)
		_tailNodes = []
		_headNodes = Set<PathNode>()
		//_nodeTree = NodeTree<PathNode>()
	}
	
	private func addNodeIntoTree(node: PathNode) -> Bool{
		guard !_nodeTree.exists(node: node) else { return false;}
		_nodeTree.addNode(node: node)
		return true
	}
	
	private func addNodeIntoHeadSet(node: PathNode) -> Bool{
		guard !_headNodes.contains(node) else { return false;}
		_headNodes.insert(node)
		return true
	}
	
	func toString() -> String {
		
//		var m:[[UInt8]] = []
//		for _ in 0..<8 {
//			var l:[UInt8] = []
//			for _ in 0..<8 {
//				l.append(0)
//			}
//			m.append(l)
//		}
//		for no in _tailNodes {
//			var head = no
//			while head.hasNext() {
//				m[head.getPoint()[1]][head.getPoint()[0]] = head.isFree() ? 1 : 2;
//				head = head.next()!
//			}
//			m[head.getPoint()[1]][head.getPoint()[0]] = head.isFree() ? 1 : 2
//		}
//		var str:String = ""
//		for ll in m.reversed() {
//			for i in ll {
//				str += i == 0 ? "-" : i == 1 ? "0" : "*"
//			}
//			str += "\n"
//		}
//		return str
		return "I am dummy function"
	}
}

protocol PathNodeActionDelegate :NSObjectProtocol {
	func uiAddPathNodes(nodes: [Node])
}
