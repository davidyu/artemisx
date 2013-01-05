package com.artemis;


/**
 *
 * The Manager class.
 *  originally written by Arni Arent
 *  ported to HaXe by Lewen Yu
 *
 */

class Manager implements EntityObserver {
    
    private var world;

    private function initialize(); //I expect this to be overriden

    private function setWorld(World world) {
        this.world = world;
    }

    private function getWorld() {
        return world;
    }

    override public function added(Entity e) {
    }

    override public function changed(Entity e) {
    }

    override public function deleted(Entity e) {
    }

    override public function disabled(Entity e) {
    }

    override public function enabled(Entity e) {
    }
}

