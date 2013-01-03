package com.artemis;

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

    //Future: maybe we need more than 32 components in some given game. In such cases we should write a data structure for an unconstrained bitset.

    private var world; //: World;
    private var entityManager; //: EntityManager;

    private var uuid : Int; //implement this

    public function new( World, id ) {
        this.world = world;
        this.id = id;
    }

    public function getId() : Int {
        return id;
    }

    public function getComponentBits() : Int {
        return componentBits;
    }

    public function getSystemBits() : Int {
        return systemBits;
    }
}
