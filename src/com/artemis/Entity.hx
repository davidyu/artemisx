package com.artemis;

import com.utils.UUID;

/**
 *
 * The entity class.
 *  originally written by Arni Arent
 *  ported to HaXe by Lewen Yu
 *
 */

class Entity {
    private var id : Int;
    private var componentBits : Int;
    private var systemBits : Int;

    /* Future: maybe we need more than 32 components in some given game.
     * In such cases we should write a data structure for an unconstrained bitset.
     */

    private var world:World; //: World;
    private var entityManager:EntityManager; //: EntityManager;

    private var uuid : String;

    public function new(world:World, id) {
        this.world = world;
        this.id = id;
    }

    public function getId() : Int {
        return id;
    }

    private function getComponentBits() : Int {
        return componentBits;
    }

    private function getSystemBits() : Int {
        return systemBits;
    }

    private function reset() {
        systemBits = 0;
        componentBits = 0;
        uuid = UUID.getUuid();
    }

    public function addComponent( component ) : Entity {
        //TODO
        return this;
    }

    public function removeComponent( component ) : Entity {
        //TODO
        return this;
    }

    public function isActive() : Bool {
        //TODO
		return true;
    }

    public function isEnabled() : Bool {
        //TODO
		return true;
    }

    public function getComponent() {
        //TODO
    }

    public function getComponents() {
        //TODO
    }

    public function addToWorld() {
        //TODO
    }

    public function changedInWorld() {
        //TODO
    }

    public function deleteFromWorld() {
        //TODO
    }

    public function getUuid() {
        return uuid;
    }

    public function getWorld() {
        //TODO
    }
}
