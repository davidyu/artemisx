package com.artemis;

/**
 *
 * The entityManager class.
 *  originally written by Arni Arent
 *  ported to HaXe by Lewen Yu
 *
 */


class EntityManager extends Manager {
    private var entities; //TODO implement Bags
    private var disabled; //TODO implement BitSet

    private var active : Int;
    private var added : Int64;
    private var created : Int64;
    private var deleted : Int64;

    private var identifierPool; //TODO implement IdentifierPool
}
