package com.artemis;

import com.utils.Bitset;
import com.utils.UUID;

/**
 *
 * The entity class.
 *  originally written by Arni Arent
 *  ported to HaXe by Lewen Yu
 *
 */

class Entity {
    public var id(getId, null) : Int;
    public var componentBits(getComponentBits, null) : Bitset;
    private var systemBits : Bitset;

    /* Future: maybe we need more than 32 components in some given game.
     * In such cases we should write a data structure for an unconstrained bitset.
     */

    private var world : World;
    private var entityManager : EntityManager;

    private var uuid : String;

    public function new( world : World, id : Int ) {
        this.world = world;
        this.id = id;
    }

    public function getId() : Int {
        return id;
    }

    private function getComponentBits() : Bitset {
        return componentBits;
    }

    private function getSystemBits() : Bitset {
        return systemBits;
    }

    private function reset() {
        systemBits.clear();
        componentBits.clear();
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
        return entityManager.isActive( id );
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
        return world;
    }
}
