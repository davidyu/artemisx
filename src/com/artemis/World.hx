package com.artemis;

import com.utils.ClassHash;
import com.utils.TArray;

class World 
{
	public var em(default, null):EntityManager;
	public var cm:ComponentManager;
	
	public var delta:Float;
	
	private var added:TArray<Entity>;
	private var changed:TArray<Entity>;
	private var deleted:TArray<Entity>;
	private var enable:TArray<Entity>;
	private var disable:TArray<Entity>;
	
	private var managers:ClassHash<Manager, Manager>;
	private var managersBag:TArray<Manager>;
	
	private var systems:ClassHash<Dynamic, EntitySystem>;
	private var systemsBag:TArray<EntitySystem>;
	
	public function new()
	{
		
	}
	
	public function initalize():Void
	{
		
	}
	
	public function getComponentManager():ComponentManager
	{
		
	}
	
	public function getManager(managerType:Class<Manager>) {
		
	}
	
	
}