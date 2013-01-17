package com.artemisx.systems;

import com.artemisx.Aspect;
import com.artemisx.Entity;
import com.artemisx.EntitySystem;
import com.artemisx.utils.ImmutableBag;

class EntityProcessingSystem extends EntitySystem
{
	public function new(aspect:Aspect) 
	{
		super(aspect);
	}
	
	private inline function processEntity(e:Entity):Void { }
	
	override private function processEntities(entities:ImmutableBag<Entity>)
	{
		for (i in 0...entities.size) {
			processEntity(entities.get(i));
		}
	}
	
	override private inline function checkProcessing() { return true; }
	
}