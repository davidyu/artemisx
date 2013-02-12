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
    @:isVar private var world (get_world, set_world):World;

    private function initialize():Void { }
	
	private function get_world():World { return world; }
	
    private function set_world(world:World):World 
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

