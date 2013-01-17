package com.artemisx.managers;

import com.artemisx.Entity;
import com.artemisx.Manager;
import com.artemisx.utils.Bag;

class GroupManager extends Manager
{
	private var entitiesByGroup:Hash<Bag<Entity>>;
	private var groupsByEntity:IntHash<Bag<String>>; // No object hash yet, apart from flash-specific platforms.
	
	public function new() 
	{
		entitiesByGroup = new Hash();
		groupsByEntity = new IntHash();
	}
	
	override private function initialize() { }
	
	public inline function add(e:Entity, group:String):Void
	{
		var entities:Bag<Entity> = entitiesByGroup.get(group);
		if (entities == null) {
			entities = new Bag();
			entitiesByGroup.set(group, entities);
		}
		entities.add(e);
		
		var groups:Bag<String> = groupsByEntity.get(e.id);
		if (groups == null) {
			groups = new Bag();
			groupsByEntity.set(e.id, groups);
		}
		groups.add(group);
	}
	
	public inline function remove(e:Entity, group:String):Void
	{
		var entities:Bag<Entity> = entitiesByGroup.get(group);
		if (entities != null) {
			entities.remove(e);
		}
		
		var groups:Bag<String> = groupsByEntity.get(e.id);
		if (groups != null) {
			groups.remove(group);
		}
	}
	
	public inline function removeFromAllGroups(e:Entity)
	{
		var groups:Bag<String> = groupsByEntity.get(e.id);
		if (groups != null) {
			for (i in 0...groups.size) {
				var entities:Bag<Entity> = entitiesByGroup.get(groups.get(i));
				if (entities != null) {
					entities.remove(e);
				}
			}
			groups.clear();
		}
	}
	
	public inline function getEntities(group:String):Bag<Entity>
	{
		var entities:Bag<Entity> = entitiesByGroup.get(group);
		if (entities == null) {
			entities = new Bag();
			entitiesByGroup.set(group, entities);
		}
		return entities;
	}
	
	public inline function getGroups(e:Entity):Bag<String> { return groupsByEntity.get(e.id); }
	
	public inline function isInAnyGroup(e:Entity):Bool { return getGroups(e) != null; }
	
	public inline function isInGroup(e:Entity, group:String)
	{
		if (group != null) {
			var groups:Bag<String> = groupsByEntity.get(e.id);
			for (i in 0...groups.size) {
				var g:String = groups.get(i);
				if (group == g) {
					return true;
				}
			}
		}
		return false;
	}
	
	override public inline function onDeleted(e:Entity) { removeFromAllGroups(e); }
}