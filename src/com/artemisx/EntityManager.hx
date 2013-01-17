package com.artemisx;

import com.artemisx.utils.Bag;
import com.artemisx.utils.Bitset;
import com.artemisx.utils.TArray;
import haxe.FastList;
import haxe.Int64;

/**
 *
 * The entityManager class.
 *  originally written by Arni Arent
 *  ported to HaXe by Lewen Yu and HARRY
 *
 */

@:allow(com.artemisx)
class EntityManager extends Manager {
    private var entities:Bag<Entity>;
    private var disabled:Bitset;

    @:isVar public var activeEntityCount (getActiveEntityCount, null):Int;
    @:isVar public var totalAdded (getTotalAdded, null):Int64;
    @:isVar public var totalCreated (getTotalCreated, null):Int64;
    @:isVar public var totalDeleted (getTotalDeleted, null):Int64;

    private var identifierPool:IdentifierPool;

    public function new() 
	{
        entities = new Bag<Entity>();
        disabled = new Bitset(1);
        identifierPool = new IdentifierPool();
		
		activeEntityCount = 0;
        totalAdded = Int64.ofInt(0);
        totalCreated = Int64.ofInt(0);
        totalDeleted = Int64.ofInt(0);
    }

    override public function initialize() {}

    public inline function createEntityInstance():Entity 
	{
        var e = new Entity(world, identifierPool.checkout());
        totalCreated = Int64.add(totalCreated, Int64.ofInt(1) );
        return e;
    }

    override public inline function onEnabled(e:Entity) { disabled.unset(e.id); }
    override public inline function onDisabled(e:Entity) { disabled.set(e.id); }
	override public inline function onAdded(e:Entity) 
	{
        activeEntityCount++;
        totalAdded = Int64.add(totalAdded, Int64.ofInt(1) );
        entities.set(e.id, e);
    }
	
    override public inline function onDeleted(e:Entity) 
	{
        entities.set(e.id, null);

        disabled.unset(e.id);

        identifierPool.checkin(e.id);
        activeEntityCount--;
        totalDeleted = Int64.add(totalDeleted, Int64.ofInt(1) );
    }

    // Returns whether the Entity (given entityId) is activeEntityCount.
    // activeEntityCount means the entity is being actively processed.
    public inline function isActive(entityId:Int):Bool { return entities.get(entityId) != null; }

    // Check if the specified entityId is enabled.
    // Enabled means...what? enabled -> activeEntityCount but activeEntityCount -/> enabled?
    public inline function isEnabled(entityId:Int):Bool { return !disabled.get(entityId); }

    // Get how many entities are activeEntityCount in this world.
    public function getActiveEntityCount():Int { return activeEntityCount; }

    // Get how many entities have been totalCreated in the world since start.
    // totalCreated entities >= totalAdded entities, since a totalCreated entity is not always totalAdded
    public function getTotalCreated():Int64 { return totalCreated; }

    // Get how many entities have been totalAdded to the world since start.
    public function getTotalAdded():Int64 { return totalAdded; }

    // Get how many entities have been totalDeleted from the world since start.
    public function getTotalDeleted():Int64 { return totalDeleted; }

    private inline function getEntity(entityId:Int):Entity 
	{
        var e = entities.get(entityId);
        #if debug
        if (e == null) {
            throw "Queried entity does not exist.";
        }
        #end
        return e;
    }
}

private class IdentifierPool
{
    private var ids:Bag<Int>;
    private var nextAvailableId:Int;

    public function new() 
	{
        ids = new Bag();
        nextAvailableId = 0;
    }

    public inline function checkout() 
	{
        if (ids.size > 0) {
            return ids.removeLast();
        }
        return nextAvailableId++;
    }

    public inline function checkin(id:Int) { ids.add(id); }
}
