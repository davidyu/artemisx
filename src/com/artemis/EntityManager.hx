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

    public var active(default, null) : Int64;
    private var added(default, null) : Int64;
    private var created(default, null) :Int64;
    private var deleted(default, null) :Int64;

    private var identifierPool : IdentifierPool;

    public function new() {
        entities = new TArray<Entity>();
        disabled = new Bitset( 1 );
        identifierPool = new IdentifierPool();
    }

    override private function initialize() { }

    private function createEntityInstance() : Entity {
        var e:Entity = new Entity( world, identifierPool.checkout() );
        Int64.add(created, Int64.ofInt(1)); // QQ where is operator overloading when you need it
        return e;
    }

    override public function onAdded(e:Entity) {
        Int64.add(active, Int64.ofInt(1));
		Int64.add(added, Int64.ofInt(1));
        //entities.insert( e.getId(), e );
    }

    override public function onEnabled(e:Entity) {
        disabled.unset( e.getId() );
    }

    override public function onDisabled(e:Entity) {
        disabled.set( e.getId() );
    }

    override public function onDeleted(e:Entity) {
        //entities.insert( e.getId(), null );
        disabled.unset( e.getId() );
        identifierPool.checkin( e.getId() );
		Int64.add(active, Int64.ofInt(-1));
		Int64.add(deleted, Int64.ofInt(1));

    }
	
	public function isActive(entityId:Int):Bool
	{
		return entities[entityId] != null;
	}
	
	public function isEnabled(entityId:Int):Bool
	{
		return !disabled.get(entityId);
	}
	
	private function getEntity(entityId:Int):Entity
	{
		return entities[entityId];
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
