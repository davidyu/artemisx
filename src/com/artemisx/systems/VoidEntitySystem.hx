package com.artemisx.systems;

import com.artemisx.Aspect;
import com.artemisx.Entity;
import com.artemisx.EntitySystem;
import com.artemisx.utils.ImmutableBag;

class VoidEntitySystem extends EntitySystem
{

	public function new() 
	{
		super(Aspect.getEmpty());
	}
	
	override private function processEntities(entities:ImmutableBag<Entity>)
	{
		processSystem();
	}
	
	private function processSystem() { }
	
	override private inline function checkProcessing() { return true; }
	
}