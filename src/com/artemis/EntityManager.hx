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
    //TODO implement Bags 
	// Might not need because TArray will suffice; no raw array in Haxe anyway
	private var entities:TArray<Entity>; 
    private var disabled:Bitset;

    private var active : Int;
    private var added : Int64;
    private var created :Int64;
    private var deleted :Int64;

    private var identifierPool:IdentifierPool; 
}

private class IdentifierPool
{
    private var ids:FastList<Int>;
    private var nextAvailableId:Int;

    public function new() {
        ids = new FastList<Int>();
        nextAvailableId = 0;
    }
    
    public function checkout() {
        if (!ids.isEmpty()) {
            return ids.pop();
        }
        return nextAvailableId++;
    }
    
    public function checkin(id:Int) {
        ids.add(id);
    }
}