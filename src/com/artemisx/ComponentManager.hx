package com.artemisx;

import com.utils.Bag;
import com.utils.Bitset;

@:allow(com.artemisx)
class ComponentManager extends Manager
{
	private var componentsByType:Bag<Bag<Component>>;		// Try Bag<IntHash<Component> later
	private var deleted:Bag<Entity>;
	
	public function new() 
	{
		componentsByType = new Bag();
		deleted = new Bag();
	}
	
	override private function initialize() {}
	
	private inline function removeComponentsOfEntity(e:Entity):Void
	{
		var componentBits:Bitset = e.componentBits;
		var i = componentBits.nextSetBit(0);
		
		while (i >= 0) {
			componentsByType.get(i).set(e.id, null);
			i = componentBits.nextSetBit(i + 1);
		}
		componentBits.clear();
		
	}
	
	private inline function addComponent(e:Entity, type:ComponentType, component:Component)
	{
		componentsByType.ensureCapacity(type.getIndex());
		
		var components:Bag<Component> = componentsByType.get(type.index);
		if (components == null) {
			components = new Bag();
			componentsByType.set(type.index, components);
		}
		components.set(e.id, component);
		
		e.componentBits.set(type.index);
	}
	
	private inline function removeComponent(e:Entity, type:ComponentType):Void
	{
		if (e.componentBits.get(type.index)) {
			componentsByType.get(type.index).set(e.id, null);
			e.componentBits.unset(type.index);
		}
	}
	
	private inline function getComponentsByType(type:ComponentType):Bag<Component>
	{
		var components = componentsByType.get(type.index);
		if (components != null) {
			components = new Bag();
			componentsByType.set(type.index, components);
		}
		return null;
	}
	
	private inline function getComponent(e:Entity, type:ComponentType)
	{
		var components = componentsByType.get(type.index);
		if (components != null) {
			return components.get(e.id);
		}
		return null;
	}
	
	public inline function getComponentsFor(e:Entity, fillBag:Bag<Component>):Bag<Component>
	{
		var componentBits:Bitset = e.componentBits;
		var i = componentBits.nextSetBit(0);
		
		while (i >= 0) {
			fillBag.add(componentsByType.get(i).get(e.id));
			i = componentBits.nextSetBit(i + 1);
		}
		return fillBag;
	}
	
	private function clean():Void
	{
		if (deleted.size > 0) {
			for (i in 0...deleted.size) {
				removeComponentsOfEntity(deleted.get(i));
			}
			deleted.clear();
		}
	}
	
	override public inline function onDeleted(e:Entity):Void { deleted.add(e); }
}
