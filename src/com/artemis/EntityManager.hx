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

    private var active : Int;
    private var added : Int64;
    private var created :Int64;
    private var deleted :Int64;

    private var identifierPool : IdentifierPool;

    public new() {
        entities = new TArray<Entity>();
        disabled = new Bitset( 1 );
        identifierPool = new IdentifierPool();
    }

    override private function initialize() { }

    private function createEntityInstance() : Entity {
        Entity e = new Entity( world, identifierPool.checkout() );
        created++;
        return e;
    }

    override public function added( Entity e ) {
        active++;
        added++;
        entities.insert( e.getId(), e );
    }

    override public function enabled( Entity e ) {
        disabled.unset( e.getId() );
    }

    override public function disabled( Entity e ) {
        disabled.set( e.getId() );
    }

    override public function deleted(Entity e) {
        entities.insert( e.getId(), null );
        disabled.unset( e.getId() );
        identifierPool.checkin( e.getId() );
        active--;
        deleted++;
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
