//
//  ShapeController.swift
//  Model
//
//  Created by Zackory Cramer on 11/12/18.
//  Copyright © 2018 Zackori Cui. All rights reserved.
//

import Foundation

class ShapeController : NSObject {
	var _nodesController: NodesController
	var _shapeNodeController: ShapeNodeController
	var _pathNodeController: PathNodeController
	var _attackController: AttackController
	var _tick: TickU = 0
	
	private var queue: GUIQueue{get{return _nodesController._queue}}
	
	func tick(_ tick: TickU) {
		_tick = tick
		shapeNodeStateChange()
		startAdvanceNodes()
		finishAdvanceNodes()
	}
	
	func startAdvanceNodes() {
		for node in _shapeNodeController._toStartAdvanceNodes {
			let newPath = node._pathNode!.getNext(node._direction)!
			var ns: [NodeAbstract] = [newPath]
			if let oldPath = node._pathNode, oldPath._ocNode == node {
				ns.append(oldPath)
				oldPath._ocNode = nil
				oldPath._taken = false
			}
			newPath._ocNode = node
			newPath._taken = true
			node._pathNode = newPath
			_shapeNodeController.move(node)
			_nodesController._queue._nodesToUpdate.append(contentsOf: ns)
		}
		_shapeNodeController._toStartAdvanceNodes.removeAll()
	}
	
	func finishAdvanceNodes() {
		for node in _shapeNodeController._toFinishAdvanceNodes {
			let oldPath = (node._pathNode! as! SerialPathNode)._prev!
			if oldPath._ocNode == node {
				oldPath._taken = false
			}
			_nodesController._queue._nodesToUpdate.append(contentsOf: [node, oldPath])
		}
		_shapeNodeController._toFinishAdvanceNodes.removeAll()
	}
	
	func shapeNodeStateChange() {
		for node in _shapeNodeController._shapeNodes {
			node.tick(_tick)
			if node._changedState {
				switch node._state {
				case .Moving:
					_shapeNodeController._toStartAdvanceNodes.insert(node)
				default:
					break
				}
				switch node._lastState {
				case .Moving:
					_shapeNodeController._toFinishAdvanceNodes.insert(node)
				default:
					break
				}
				node._changedState = false
			}
			switch node._state {
			case .Chilling :
				if let next = (node._pathNode as! SerialPathNode)._next, !next._taken {
					node._state = .CanNowMoveWaiting
				} else {
					node._state = .Attacking
					queue.update(node: node)
				}
			case .CanNowMoveWaiting:
				if let next = (node._pathNode as! SerialPathNode)._next, next._taken {
					node._state = .Chilling
				}
				if node._lastStateTick + CAN_MOVE_WAIT_TIME < _tick {
					node._state = .CanNowMove
					node._lastStateTick = _tick
				}
			case .Moving:
				if node._lastStateTick + MOVING_TIME < _tick {
					node._state = .Chilling
					node._lastStateTick = _tick
				}
			case .Attacking:
				if node._lastStateTick + ATTACK_TIME < _tick, let next = (node._pathNode as? SerialPathNode)?._next, !next._taken {
					node._state = .CanNowMoveWaiting
					node._lastStateTick = _tick
					queue.update(node: node)
				}
				if (_tick - node._lastStateTick) % ATTACK_TIME == 1 {
					_attackController.attack(from: node, to : (10, 10))
				}
			default:
				break
			}
		}
	}
	
	init(nodesController: NodesController, shapeNodeController: ShapeNodeController, pathNodeController: PathNodeController,attackController: AttackController) {
		_nodesController = nodesController
		_shapeNodeController = shapeNodeController
		_pathNodeController = pathNodeController
		_attackController = attackController
	}
}
