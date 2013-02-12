package com.artemisx.systems;

import com.artemisx.Aspect;
import com.artemisx.EntitySystem;

class IntervalEntitySystem extends EntitySystem
{
	private var acc:Float;
	private var interval:Float;
	
	public function new(aspect:Aspect, interval:Float) 
	{
		super(aspect);
		this.interval = interval;
		acc = 0;
	}
	
	override private inline function checkProcessing()
	{
		acc += world.delta;
		if (acc >= interval) {
			acc -= interval;
			return true;
		}
		return false;
	}
	
}