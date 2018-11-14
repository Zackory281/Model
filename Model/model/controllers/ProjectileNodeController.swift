//
//  ProjectileNodeController.swift
//  Model
//
//  Created by Zackory Cramer on 11/12/18.
//  Copyright © 2018 Zackori Cui. All rights reserved.
//

import Foundation

class ProjectileNodeController: NSObject {
	var projectileNodes = Set<ProjectileNode>()
	private weak var _queue: GUIQueue?
	
	func addProjectile(_ node: ProjectileNode) {
		projectileNodes.insert(node)
		_queue?.add(node: node)
	}
	
	func tick(_ tick:TickU) {
		for node in projectileNodes {
			node.tick(tick)
			_queue?.update(node: node)
		}
	}
	
	init(queue: GUIQueue) {
		_queue = queue
	}
}
