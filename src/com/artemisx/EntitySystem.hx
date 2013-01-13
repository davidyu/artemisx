package com.artemisx;

import com.utils.Bag;
import com.utils.Bitset;
import com.utils.ClassHash;
import com.utils.ImmutableBag;

@:allow(com.artemisx)
class EntitySystem implements EntityObserver
{
    @:isVar public 	var actives (get_actives, null): Bag<Entity>;
	@:isVar public 	var world (null, set_world):World;
	@:isVar public 	var passive (isPassive, set_passive):Bool;
	
	private var aspect:Aspect;
	private var dummy:Bool; // Variable for performance
	
	private var systemIndex:Int;
	
	private var allSet: Bitset;
	private var exclusionSet:Bitset;
	private var oneSet:Bitset;
	
    public function new(aspect:Aspect) 
    {
		this.aspect = aspect;
		actives = new Bag();
		allSet = aspect.allSet;
		exclusionSet = aspect.exclusionSet;
		oneSet = aspect.oneSet;
		dummy = allSet.isEmpty() && oneSet.isEmpty();
		systemIndex = SystemIndexManager.getIndexFor(Type.getClass(this));
		
    }
	
	public inline function process():Void
	{
		if (checkProcessing()) {
			begin();
			processEntities(actives);
			end();
		}
	}
	
	private function begin():Void {}
	private function end():Void { }
	private function initialize():Void { }
	
	private inline function processEntities(entities:ImmutableBag<Entity>):Void { }
	private inline function checkProcessing():Bool { return true; }
	
	private inline function onInserted(e:Entity):Void { }
	private inline function onRemoved(e:Entity):Void { }
	
	private inline function check(e:Entity):Void
	{
		if (dummy) {
			return;
		}
		
		var contains = e.systemBits.get(systemIndex);
		var interested = true;
		var componentBits = e.componentBits;
		var i = allSet.nextSetBit(0);
		
		if (!allSet.isEmpty()) {
			while (i >= 0) {
				if (!componentBits.get(i)) {
					interested = false;
					break;
				}
				i = allSet.nextSetBit(++i);
			}
		}
		if (!exclusionSet.isEmpty() && interested) {
			interested = !exclusionSet.intersects(componentBits);
		}
		if (!oneSet.isEmpty()) {
			interested = oneSet.intersects(componentBits);
		}
		
		if (interested && !contains) {
			insertToSystem(e);
		} else if (!interested && contains) {
			removeFromSystem(e);
		}
	}
	
	private inline function insertToSystem(e:Entity):Void
	{
		actives.add(e);
		e.systemBits.set(systemIndex);
		onInserted(e);
	}
	
	private inline function removeFromSystem(e:Entity):Void
	{
		actives.remove(e);
		e.systemBits.unset(systemIndex);
		onRemoved(e);
	}
	
	public inline function onAdded(e:Entity):Void 	 { check(e); }
    public inline function onChanged(e:Entity):Void { check(e); }
    public inline function onDeleted(e:Entity):Void
    {
		if (e.systemBits.get(systemIndex)) {
			removeFromSystem(e);
		}
    }

	public inline function onEnabled(e:Entity):Void { check(e); }
    public inline function onDisabled(e:Entity):Void
    {
		if (e.systemBits.get(systemIndex)) {
			removeFromSystem(e);
		}
    }
	
	public inline function isPassive():Bool 	{ return passive;  } 
	public inline function setPassive(v:Bool) 	{ passive = v; return v; }
	public inline function getActives() 		{ return actives; }
	public inline function setWorld(v:World)	{ world = v; return v;  }
	

}

private class SystemIndexManager
{
	private static var INDEX:Int = 0;
	private static var indicies:ClassHash<EntitySystem, Null<Int>> = new ClassHash();
	
	public static function getIndexFor<T:EntitySystem>(es:Class<T>):Int
	{
		var index:Null<Int> = indicies.get(untyped es);
		
		if (index != null) {
			index = INDEX++;
			indicies.set(untyped es, index);
		}
		return index;
	}
}
