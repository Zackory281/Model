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
	var _projectileController: ProjectileNodeController{get{ return _nodesController._projectileNodeController}}
	var _geoemtryController: GeometryNodeController{get{ return _nodesController._geometryNodeController}}
	var _queue: GUIQueue{get{return _nodesController._queue}}
	var _damageEnteries:Queue<DamageEntry>
	init(nodesController: NodesController) {
		_nodesController = nodesController
		_damageEnteries = Queue<DamageEntry>()
	}
	func attack(from shapeNode: ShapeNode, to point: Point) {
		guard let geo = _geoemtryController._geometryNodes.first else {
			print("no nodes to shoot at."); return;
		}
		let node = ProjectileNode(from: shapeNode, to: geo, speed: 0.3, tick: _tick)
		_nodesController.addProjectileNode(node)
	}
	func queueDamage(_ entry: DamageEntry) {
		_damageEnteries.queue(entry)
	}
	func tick(_ tick: TickU) {
		_tick = tick
		var toRemove = Set<ProjectileNode>()
		for proj in _projectileController.projectileNodes {
			if proj._hit {
				//print("Projectile \(proj) hit \(proj._end)")
				toRemove.insert(proj)
				queueDamage(DamageEntry(from: proj._from, to: proj._to, damage: 0.1))
			}
		}
		while let entry = _damageEnteries.remove() {
			guard let to = entry._to else { continue }
			guard let from = entry._from else { continue }
			guard let geo = to as? GeometryNode else { continue }
			geo._health -= entry._damage
			_queue.update(node: to)
			_queue.remove(from)
		}
		_projectileController.projectileNodes.subtract(toRemove)
	}
}

class DamageEntry: NSObject {
	weak var _from, _to: NodeAbstract?
	let _damage: Float
	init(from: NodeAbstract?, to: NodeAbstract?, damage: Float) {
		_from = from
		_to = to
		_damage = damage
	}
}
