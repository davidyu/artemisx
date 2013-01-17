package com.artemisx;

/**
 *
 * The Manager class.
 *  originally written by Arni Arent
 *  ported to HaXe by Lewen Yu and Harry
 *
 */

@:allow(com.artemisx)
class Manager implements EntityObserver 
{
    @:isVar private var world (getWorld, setWorld):World;

    private function initialize():Void { }
	
	private function getWorld():World { return world; }
	
    private function setWorld(world:World):World 
	{
        this.world = world;
        return world;
    }
	
    public function onAdded(e:Entity) {}

    public function onChanged(e:Entity) {}

    public function onDeleted(e:Entity) {}

    public function onDisabled(e:Entity) {}

    public function onEnabled(e:Entity) {}

}

