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

    public function added(Entity e) {
    }

    public function changed(Entity e) {
    }

    public function deleted(Entity e) {
    }

    public function disabled(Entity e) {
    }

    public function enabled(Entity e) {
    }
}

