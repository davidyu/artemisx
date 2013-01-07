package com.artemis;

import com.utils.Bitset;
import com.utils.TArray;
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

    private var active (default, null) : Int;
    private var added (default, null) : Int64;
    private var created (default, null) :Int64;
    private var deleted (default, null) :Int64;

    private var identifierPool : IdentifierPool;

    public function new() {
        entities = new TArray<Entity>();
        disabled = new Bitset( 1 );
        identifierPool = new IdentifierPool();
        initialize();
    }

    override private function initialize() {
        active = 0;
        added = Int64.ofInt( 0 );
        created = Int64.ofInt( 0 );
        deleted = Int64.ofInt( 0 );
    }

    public function createEntityInstance() : Entity {
        var e = new Entity( world, identifierPool.checkout() );
        created = Int64.add( created, Int64.ofInt( 1 ) );
        return e;
    }

    override public function onAdded( e:Entity ) {
        active++;
        added = Int64.add( added, Int64.ofInt( 1 ) );
        entities.insert( e.getId(), e );
    }

    override public function onEnabled( e : Entity ) {
        disabled.unset( e.getId() );
    }

    override public function onDisabled( e : Entity ) {
        disabled.set( e.getId() );
    }

    override public function onDeleted( e : Entity ) {
        entities.insert( e.getId(), null );

        disabled.unset( e.getId() );

        identifierPool.checkin( e.getId() );
        active--;
        deleted = Int64.add( deleted, Int64.ofInt( 1 ) );
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
