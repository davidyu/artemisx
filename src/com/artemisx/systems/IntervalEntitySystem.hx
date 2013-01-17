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
	}
	
	override private inline function checkProcessing()
	{
		acc += world.getDelta();
		if (acc >= interval) {
			acc -= interval;
			return true;
		}
		return false;
	}
	
}