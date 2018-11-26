//
//  ProjectileNode.swift
//  Model
//
//  Created by Zackory Cramer on 11/12/18.
//  Copyright © 2018 Zackori Cui. All rights reserved.
//

import Foundation

typealias FPoint = (Float, Float)
class ProjectileNode : NodeAbstract {
	var _radius: Int8 = 10
	let _start, _end: FPoint
	var _distance: Float
	var _speed: Float
	var _dx, _dy: Float
	let _startTick: TickU
	var _fpoint: FPoint!
	var _hit: Bool {
		return Float(_tick-_startTick) * _speed > _distance
	}
	var _tick: TickU
	weak var _from: NodeAbstract?
	weak var _to: NodeAbstract?
	
	init(from: NodeAbstract, to: GeometryNode, speed: Float, tick: TickU) {
		(_start, _end, _speed) = (toFloatPoint(from._point), toFloatPoint(to._point), speed)
		(_dx, _dy) = (_end.0 - _start.0, _end.1 - _start.1)
		_distance = sqrt(_dx * _dx + _dy * _dy)
		_startTick = tick
		_tick = tick
		_from = from
		_to = to
		super.init()
	}
	
	func tick(_ tick: TickU) {
		_tick = tick
		let perCent = Float(_tick-_startTick) / (_distance / _speed)
		_fpoint = (_start.0 + _dx * perCent, _start.1 + _dy * perCent)
	}
	
	override var _type: NodeType {get{return .Projectile}}
}
