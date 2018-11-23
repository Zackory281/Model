//
//  AttackController.swift
//  Model
//
//  Created by Zackory Cramer on 11/12/18.
//  Copyright © 2018 Zackori Cui. All rights reserved.
//

import Foundation

class AttackController {
	
	var _nodesController: NodesController
	var _tick: TickU = 0
	var _projectileController: ProjectileNodeController{
		get{ return _nodesController._projectileNodeController}}
	init(nodesController: NodesController) {
		_nodesController = nodesController
	}
	func attack(from shapeNode: ShapeNode, to point: Point) {
		let node = ProjectileNode(start: shapeNode._point, end: point, from: shapeNode, speed: 1, tick: _tick)
		_nodesController.addProjectileNode(node)
	}
	func tick(_ tick: TickU) {
		_tick = tick
		var toRemove = Set<ProjectileNode>()
		for proj in _projectileController.projectileNodes {
			if proj._hit {
				//print("Projectile \(proj) hit \(proj._end)")
				toRemove.insert(proj)
			}
		}
		_projectileController.projectileNodes.subtract(toRemove)
	}
}
