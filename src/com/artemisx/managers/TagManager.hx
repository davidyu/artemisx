package com.artemisx.managers;
import com.artemisx.Entity;

class TagManager extends Manager
{
	private var entitiesByTag:Hash<Entity>;
	private var tagsByEntity:IntHash<String>;
	
	public function new() 
	{
		entitiesByTag = new Hash();
		tagsByEntity = new IntHash();
	}
	
	public inline function register(tag:String, e:Entity):Void
	{
		entitiesByTag.set(tag, e);
		tagsByEntity.set(e.id, tag);
	}
	
	// Different from original because we use IntHash for tagsByEntity
	public inline function unregister(tag:String):Void 
	{ 
		var entity = entitiesByTag.get(tag);
		if (entity != null) {
			tagsByEntity.remove(entity.id);
		}
		entitiesByTag.remove(tag);
	}
	
	public inline function isRegistered(tag:String):Bool { return entitiesByTag.exists(tag); } // Different from original maybe?
	
	public inline function getEntity(tag:String):Entity { return entitiesByTag.get(tag); }
	
	public inline function getRegisteredTags():Iterator<String> { return tagsByEntity.iterator(); }
	
	override private function initialize():Void { }
	
	override public inline function onDeleted(e:Entity)
	{
		var removedTag:String = tagsByEntity.get(e.id);
		if (removedTag != null) {
			tagsByEntity.remove(e.id);
			entitiesByTag.remove(removedTag);
		}
	}

	
}