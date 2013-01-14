package com.artemisx.systems;
import com.artemisx.Aspect;
import com.artemisx.Entity;
import com.artemisx.utils.ImmutableBag;

class IntervalEntityProcessingSystem extends IntervalEntitySystem
{

	public function new(aspect:Aspect, interval:Float) 
	{
		super(aspect, interval);
	}
	
	private inline function processEntity(e:Entity) { }
	
	override private inline function processEntities(entities:ImmutableBag<Entity>)
	{
		for (i in 0...entities.size) {
			processEntity(entities.get(i));
		}
	}
	
}