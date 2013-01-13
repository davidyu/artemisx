package com.artemisx;

import com.utils.Bag;
import com.utils.Bitset;
import com.utils.UUID;

/**
 *
 *  The entity class.
 *  originally written by Arni Arent
 *  ported to HaXe by Lewen Yu (AND HARRY)
 *
 */

@:allow(com.artemisx)
class Entity 
{
	@:isVar public var uuid (getUuid, null):String;
    @:isVar public var id (getId, null):Int;
    @:isVar public var componentBits (getComponentBits, null):Bitset;
    @:isVar public var systemBits (getSystemBits, null):Bitset;

    private var world:World;
    private var entityManager:EntityManager;
	private var componentManager: ComponentManager;

    private function new(world:World, id:Int) 
	{
        this.world = world;
        this.id = id;
		entityManager = world.entityManager;
		componentManager = world.componentManager;
		systemBits = new Bitset();
		componentBits = new Bitset();
		
		reset();
    }
	
    private function reset() {
        systemBits.clear();
        componentBits.clear();
        uuid = UUID.getUuid();
    }

    public inline function addComponent(component:Component):Entity 
	{
		addComponentOfType(component, ComponentType.getTypeFor(Type.getClass(component)));
        return this;
    }
	
	public inline function addComponentOfType(component:Component, type:ComponentType):Entity
	{
		componentManager.addComponent(this, type, component);
		return this;
	}

    public inline function removeComponent(component:Component):Entity 
	{
        removeComponentOfType(ComponentType.getTypeFor(Type.getClass(component)));
        return this;
    }
	
	public inline function removeComponentOfType(type:ComponentType):Entity
	{
		componentManager.removeComponent(this, type);
		return this;
	}
	
	public inline function getUuid() { return uuid; }
	public inline function getId() { return id; }
	
	public inline function getComponentBits():Bitset { return componentBits; }
    public inline function getSystemBits():Bitset { return systemBits; }
	
	public function getWorld() { return world; }
	
	public inline function getComponent(type:ComponentType):Component { return componentManager.getComponent(this, type); }
    public inline function getComponents(fillBag:Bag<Component>):Bag<Component> { return componentManager.getComponentsFor(this, fillBag); }

    public inline function isActive():Bool { return entityManager.isActive(id); }
	public inline function isEnabled():Bool { return entityManager.isEnabled(id); }
	
    public inline function addToWorld() { world.addEntity(this); }
    public inline function changedInWorld() { world.changedEntity(this); }
    public inline function deleteFromWorld() { world.deleteEntity(this); }
	
	public inline function enable() { world.enableEntity(this); }
	public inline function disable() { world.disableEntity(this); }
}
