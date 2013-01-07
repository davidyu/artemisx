package com.artemis;

import haxe.FastList;
import haxe.Int64;

/**
 *
 * The entityManager class.
 *  originally written by Arni Arent
 *  ported to HaXe by Lewen Yu
 *
 */

class EntityManager extends Manager {
    private var entities : TArray<Entity>;
    private var disabled : Bitset;

    private var active : Int;
    private var added : Int64;
    private var created : Int64;
    private var deleted : Int64;

    private var identifierPool : IdentifierPool;

    public function new() {
        entities = new TArray<Entity>();
        disabled = new Bitset( 1 );
        identifierPool = new IdentifierPool();
    }

    override private function initialize() { }

    private function createEntityInstance() : Entity {
        var e = new Entity( world, identifierPool.checkout() );
        created++;
        return e;
    }

    override public function added( e : Entity ) {
        active++;
        added++;
        entities.insert( e.getId(), e );
    }

    override public function enabled( e : Entity ) {
        disabled.unset( e.getId() );
    }

    override public function disabled( e : Entity ) {
        disabled.set( e.getId() );
    }

    override public function deleted( e : Entity ) {
        entities.insert( e.getId(), null );

        disabled.unset( e.getId() );

        identifierPool.checkin( e.getId() );

        active--;
        deleted++;
    }

    //Returns whether the Entity (given entityId) is active.
    //  Active means the entity is being actively processed.
    public function isActive( entityId : Int ) : Bool {
        return entities[ entityId ] != null;
    }

    //Check if the specified entityId is enabled.
    //  Enabled means...
    public function isEnabled( entityId : Int ) : Bool {
        return !disabled.get( entityId );
    }

    // Get how many entities are active in this world.
    public function getActiveEntityCount() : Int {
        return active;
    }

    // Get how many entities have been created in the world since start.
    //  created entities >= added entities, since a created entity is not always added
    public function getTotalCreated() : Int64 {
        return created;
    }

    // Get how many entities have been added to the world since start.
    public function getTotalAdded() : Int64 {
        return added;
    }

    // Get how many entities have been deleted from the world since start.
    public function getTotalDeleted() : Int64 {
        return deleted;
    }

    private function getEntity( entityId : Int ) : Entity {
        var e = entities[ entityId ];
        #if debug
        if ( e == null ) {
            throw "Queried entity does not exist."
        }
        #end
        return e;
    }

}

private class IdentifierPool
{
    private var ids : FastList<Int>;
    private var nextAvailableId : Int;

    public function new() {
        ids = new FastList<Int>();
        nextAvailableId = 0;
    }

    public function checkout() {
        if ( !ids.isEmpty() ) {
            return ids.pop();
        }
        return nextAvailableId++;
    }

    public function checkin( id:Int ) {
        ids.add( id );
    }
}
