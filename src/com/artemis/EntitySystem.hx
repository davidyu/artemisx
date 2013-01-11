package com.artemis;

/**
 * ...
 * @author 
 */

class EntitySystem implements EntityObserver
{
    public var world (default, setWorld) : World;
    public var passive(default, setPassive) : Bool;

    public function new() 
    {
    }

    public function initialize()
    {
    }

    public function onAdded( e:Entity )
    {
    }

    public function onChanged( e:Entity )
    {
    }

    public function onDeleted( e:Entity )
    {
    }

    public function onDisabled( e:Entity )
    {
    }

    public function onEnabled( e:Entity )
    {
    }

    public function setWorld(world : World) : World
    {
        this.world = world;
        return world;
    }

    public function setPassive(passive : Bool) : Bool
    {
        this.passive = passive;
        return passive;
    }
	
	public function process() { }
	

}
