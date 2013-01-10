package com.artemis;

/**
 *
 * The Manager class.
 *  originally written by Arni Arent
 *  ported to HaXe by Lewen Yu
 *
 */

class Manager implements EntityObserver {
    public var world (getWorld, setWorld) : World;

    //this function made public until Haxe's @:allow metadata feature is enabled
    public function initialize() : Void { }

    //note to self: world setter and getter are public until Haxe's @:allow metadata are enabled
    public function setWorld( world:World ) : World {
        this.world = world;
        return world;
    }

    public function getWorld() : World {
        return world;
    }

    public function onAdded( e:Entity ) {
    }

    public function onChanged( e:Entity ) {
    }

    public function onDeleted( e:Entity ) {
    }

    public function onDisabled( e:Entity ) {
    }

    public function onEnabled( e:Entity ) {
    }
}

