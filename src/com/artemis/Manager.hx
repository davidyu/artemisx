package com.artemis;

/**
 *
 * The Manager class.
 *  originally written by Arni Arent
 *  ported to HaXe by Lewen Yu
 *
 */

class Manager implements EntityObserver {
    private var world : World;

    private function initialize() { } //I expect this to be overriden

    private function setWorld( world : World ) {
        this.world = world;
    }

    private function getWorld() {
        return world;
    }

    public function added( e : Entity ) { }

    public function changed( e : Entity ) { }

    public function deleted( e : Entity ) { }

    public function enabled( e : Entity ) { }

    public function disabled( e : Entity ) { }
}

