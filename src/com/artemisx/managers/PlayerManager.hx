package com.artemisx.managers;

import com.artemisx.Entity;
import com.artemisx.Manager;
import com.artemisx.utils.Bag;

class PlayerManager extends Manager
{
	private var entitiesByPlayer:Hash<Bag<Entity>>;
	private var playerByEntity:IntHash<String>;
	
	public function new() 
	{
		playerByEntity = new IntHash();
		entitiesByPlayer = new Hash();
	}
	
	public function setPlayer(e:Entity, player:String)
	{
		playerByEntity.set(e.id, player);
		
		var entities:Bag<Entity> = entitiesByPlayer.get(player);
		if (entities == null) {
			entities = new Bag();
			entitiesByPlayer.set(player, entities);
		}
		entities.add(e);
	}
	
	public inline function getEntitiesOfPlayer(player:String):Bag<Entity>
	{
		var entities:Bag<Entity> = entitiesByPlayer.get(player);
		if (entities == null) {
			entities = new Bag();
		}
		return entities;
	}
	
	public inline function removeFromPlayer(e:Entity):Void
	{
		var player:String = playerByEntity.get(e.id);
		if (player != null) {
			var entities:Bag<Entity> = entitiesByPlayer.get(player);
			if (entities != null) {
				entities.remove(e);
			}
		}
	}
	
	public inline function getPlayer(e:Entity):String { return playerByEntity.get(e.id); }
	
	override private function initialize():Void { }
	
	override public inline function onDeleted(e:Entity) { removeFromPlayer(e); }
	
	
}