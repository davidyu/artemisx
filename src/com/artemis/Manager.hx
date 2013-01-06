package com.artemis;

/**
 *
 * The Manager class.
 *  originally written by Arni Arent
 *  ported to HaXe by Lewen Yu
 *
 */

class Manager implements EntityObserver {
    
    private var world:World;

    private function initialize():Void {
		
	}

    private function setWorld(world:World) {
        this.world = world;
    }

    private function getWorld() {
        return world;
    }

    public function onAdded(e:Entity) {
    }

    public function onChanged(e:Entity) {
    }

    public function onDeleted(e:Entity) {
    }

    public function onDisabled(e:Entity) {
    }

    public function onEnabled(e:Entity) {
    }
}

