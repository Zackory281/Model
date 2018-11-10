//
//  Map.swift
//  Model
//
//  Created by Zackory Cramer on 10/24/18.
//  Copyright © 2018 Zackori Cui. All rights reserved.
//

import Foundation
import AppKit


class PathNodeController {
	
	private var _tailNodes:[PathNodeAbstract]
	private var _nodeTree: NodeTree<PathNodeAbstract>
	private var _headNodes: Set<PathNodeAbstract>
	
	var _nodesToUpdate: Set<PathNodeAbstract>
	var _nodesToAdd: Set<PathNodeAbstract>
	
	func addNodeOnStep() {
		
	}
	
	/// Stitch the head after it's been added.
	/// - Returns: the node stitched to.
	func stitch(head: PathNodeAbstract) -> PathNodeAbstract? {
		let _dirNodes = _nodeTree.getNeibhorNodesAt(head._point).filter { arg -> Bool in
			return arg.0._prevs.isEmpty
		}
		guard let tail = _dirNodes.first?.0 as? SerialPathNode else {
			return nil
		}
		tail._prev = head
		(head as! SerialPathNode)._next = tail
		(head as! SerialPathNode)._direction = _dirNodes.first!.1
		return tail
	}
	
	/// Stitch the tail after it's been added.
	/// - Returns: the node stitched to.
	func stitch(tail: PathNodeAbstract) -> PathNodeAbstract? {
		let _dirNodes = _nodeTree.getNeibhorNodesAt(tail._point).filter { (node, dir) -> Bool in
			return node._nexts.isEmpty
		}
		guard let head = _dirNodes.first?.0 as? SerialPathNode else {
			return nil
		}
		head._next = tail
		(tail as! SerialPathNode)._next = head
		(tail as! SerialPathNode)._direction = _dirNodes.first!.1
		return head
	}
	
	/// - returns: the pathnode successfully inserted
	func addPathNode(at point: Point) -> PathNodeAbstract?{
		//_nodeTree.addPathNode(pathNode: PathNode.init(x, y))
		// TODO: fix me!
		guard _nodeTree.isEmpty(at: point) else { print("I thought there weren't any nodes?");return nil }
		let node = SerialPathNode(point: point)
		_nodesToAdd.insert(node)
		let _dirNodes = _nodeTree.getNeibhorNodesAt(node._point).filter { (node, dir) -> Bool in
			return (node._nexts.isEmpty || node._prevs.isEmpty)
		}
		switch _dirNodes.count {
		case 0:
			break
		case 1:
			let (n, d) = _dirNodes[0]
			if let n = n as? SerialPathNode {
				if n._next == nil {
					n._next = node
					node._prev = n
					n._direction = d.opposite()
					_nodesToUpdate.insert(n)
					break
				}
				if n._prev == nil && (n._next?._point)! != node._point {
					n._prev = node
					node._next = n
					node._direction = d.opposite()
					n._direction = d
					_nodesToUpdate.insert(n)
					break
				}
			}
		case 2:
			for (n, d) in _dirNodes {
				if let n = n as? SerialPathNode {
					if n._next == nil {
						n._next = node
						node._prev = n
						n._direction = d.opposite()
						_nodesToUpdate.insert(n)
					} else if n._prev == nil && (n._next?._point)! != node._point {
						n._prev = node
						node._next = n
						node._direction = d
						_nodesToUpdate.insert(n)
					}
				}
			}
			break
		default:
			break
		}
		guard addNodeIntoTree(node: node) else { print("insertion of node into tree failed"); return nil }
		_nodeTree.addNode(node: node)
		return node
	}
	
	func addTailNodes(tailNode:PathNodeAbstract) {
		_tailNodes.append(tailNode)
	}
	
	/// - returns: the pathnodes successfully inserted
	func addHeadNode(_ head: PathNodeAbstract) -> [PathNodeAbstract] {
		guard addNodeIntoHeadSet(node: head) else { print("insertion into head set failed"); return []}
		
		let nodes = Stack<PathNodeAbstract>()
		if let d = stitch(head: head) {
			_nodesToUpdate.insert(d)
		}
		_nodesToAdd.insert(head)
		nodes.stack(head)
		while let top = nodes.pop() {
			guard addNodeIntoTree(node: top) else {
				print("insertion of seg node into tree failed");
				break
			}
			nodes.stack(top._prevs)
			_nodesToAdd.append(contentsOf: top._prevs)
		}
		return []
	}
	
	func addShapeNodeToTail(shapeNode:ShapeNode) {
		shapeNode._pathNode = _tailNodes[0]
		_tailNodes[0]._shapeNode = shapeNode
	}
	
	func getPathNodeAt(_ point: Point) -> PathNodeAbstract?{
		return _nodeTree.getNodesAt(point.0, point.1).first
	}
	
	init(width: IntC, height: IntC) {
		_nodeTree = NodeTree<PathNodeAbstract>.init(width: width, height: height)
		_tailNodes = []
		_headNodes = Set<PathNodeAbstract>()
		_nodesToUpdate = []
		_nodesToAdd = []
	}
	
	private func addNodeIntoTree(node: PathNodeAbstract) -> Bool{
		guard !_nodeTree.exists(node: node) else { return false;}
		_nodeTree.addNode(node: node)
		return true
	}
	
	private func addNodeIntoHeadSet(node: PathNodeAbstract) -> Bool{
		guard !_headNodes.contains(node) else { return false;}
		_headNodes.insert(node)
		return true
	}
}

protocol PathNodeActionDelegate :NSObjectProtocol {
	func uiAddPathNodes(nodes: [Node])
}
