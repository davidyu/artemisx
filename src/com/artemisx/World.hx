package com.artemisx;

import com.artemisx.utils.ClassHash;
import com.artemisx.utils.Bag;
import com.artemisx.utils.ImmutableBag;

class World
{
    @:isVar public var entityManager(default, null):EntityManager;
    @:isVar public var componentManager(default, null):ComponentManager;

    @:isVar public var delta (get_delta, set_delta):Float ;

    public function new()
    {
        managers = new ClassHash<Manager>();
        managersBag = new Bag<Manager>();

        systems = new ClassHash<EntitySystem>();
        systemsBag = new Bag<EntitySystem>();

        added = new Bag<Entity>();
        changed = new Bag<Entity>();
        deleted = new Bag<Entity>();
        enable = new Bag<Entity>();
        disable = new Bag<Entity>();

        componentManager = new ComponentManager();
        setManager(componentManager);

        entityManager = new EntityManager();
        setManager(entityManager);
    }

    public function initialize():Void
    {
        for (i in 0...managersBag.size) {
            managersBag.get(i).initialize();
        }

        for (i in 0...systemsBag.size) {
            ComponentMapperInitHelper.config(systemsBag.get(i), this);
            systemsBag.get(i).initialize();
        }
    }

    public inline function getEntityManager():EntityManager
    {
        return entityManager;
    }

    public inline function getComponentManager():ComponentManager
    {
        return componentManager;
    }

	public inline function getManager<M:Manager>(managerType:Class<M>):M
    {
        return cast(managers.get(managerType));
    }
	
	public function getManagerSafe<M:Manager> (managerType:Class<M>) : M
    {
        var man:M;
		
        if (Std.is(managers.get(managerType), managerType)) {
            man = cast managers.get(managerType);
            return man;
        }
        return null;
    }
	
    public inline function setManager<M:Manager>(manager:M):M
    {
        managers.set(Type.getClass(manager), manager);
        managersBag.add(manager);
        manager.world = this;
        return manager;
    }

    public inline function deleteManager(manager:Manager):Void
    {
        managers.remove(Type.getClass(manager)); //not quite sure if this is correct, see canonical implementation
        managersBag.remove(manager);
    }

    public inline function addEntity(e:Entity):Void
    {
        added.add(e);
    }

    public inline function deleteEntity(e:Entity, ?flush:Bool=false):Void {
        if (!deleted.contains(e)) {
            deleted.add(e);
        }
		if (flush) {
			process();
		}
    }
	
	public function deleteEntities():Void {
		deleted.clear();
		if ( !entityManager.entities.isEmpty() ) {
			for ( i in 0...entityManager.entities.size ) {
				if ( entityManager.entities.get( i ) != null ) {
					deleted.add( entityManager.entities.get( i ) );
				}
			}
		}
	}

    //note: in the canonical implementation this is simply "enable"
    public inline function enableEntity(e:Entity):Void
    {
        enable.add(e);
    }
	
	public inline function changedEntity(e:Entity):Void
    {
        changed.add(e);
    }

    //note: in the canonical implementation this is simply "disable"
    public function disableEntity(e:Entity):Void
    {
        disable.add(e);
    }
	
	public inline function containsActiveEntity(e:Entity):Bool
	{
		return entityManager.entities.contains(e);
	}
	
    public inline function createEntity():Entity
    {
		var e = entityManager.createEntityInstance();
        return e;
    }

    // passive = true -> will not be processed by World
    public inline function setSystem<T:EntitySystem> (system:T, ?passive:Bool = false):T
    {
        system.world = this;
        system.passive = passive;
        systems.set(Type.getClass(system), system);
        systemsBag.add(system);
        return system;
    }

    public inline function deleteSystem(system:EntitySystem):Void
    {
        systems.remove(Type.getClass(system));
        systemsBag.remove(system);
    }
	
	public inline function deleteSystemsOfTypes(types:Array<Class<EntitySystem>>):Void
	{
		for (i in types) {
			var sys = systems.get( i );
			if ( sys != null ) {
				systems.remove( i );
				systemsBag.remove( sys );
			}
		}
	}
	
	public inline function disableSystemsOfTypes(types:Array<Class<EntitySystem>>):Void
	{
		for (i in types) {
			var sys = systems.get(i);
			if ( sys != null ) {
				sys.passive = true;
			}
		}
	}
	
	public inline function enableSystemsOfTypes(types:Array<Class<EntitySystem>>):Void
	{
		for (i in types) {
			var sys = systems.get(i);
			if ( sys != null ) {
				sys.passive = false;
			}
		}
	}
	
	public inline function getEntity(entityId:Int):Entity
    {
        return entityManager.getEntity(entityId);
    }
	
	public inline function getMapper<T:Component> (type:Class<T>) : ComponentMapper<T>
    {
        return ComponentMapper.getFor(type, this);
    }
	
	public inline function getSystem<T:EntitySystem> (type:Class<T>):T
    {
		return cast(systems.get(type));
    }
	
	public inline function getSystems():ImmutableBag<EntitySystem>
    {
        return systemsBag;
    }
	
    public inline function getSystemSafe<T:EntitySystem> (type:Class<T>):T
    {
        var sys:T;
		
        if (Std.is(systems.get(type), type)) {
            sys = cast systems.get(type);
            return sys;
		}
        return null;
    }
	
	public inline function process():Void
    {
        check(added, fAdded);
        check(changed, fChanged);
        check(disable, fDisabled);
        check(enable, fEnabled);
        check(deleted, fDeleted);		  

        componentManager.clean();

        for (i in 0...systemsBag.size) {
            var system = systemsBag.get(i);
            if (!system.passive) {
                system.process();
            }
        }
    }
	
	// Privates 
	private var added:Bag<Entity>;
    private var changed:Bag<Entity>;
    private var deleted:Bag<Entity>;
    private var enable:Bag<Entity>;
    private var disable:Bag<Entity>;

    private var managers:ClassHash<Manager>;
    private var managersBag:Bag<Manager>;

    private var systems:ClassHash<EntitySystem>;
    private var systemsBag:Bag<EntitySystem>;
	
	private inline function get_delta():Float
    {
        return delta;
    }

    private inline function set_delta(delta:Float):Float
    {
        this.delta = delta;
        return delta;
    }
	
    // note to self: in the canonical implementations of notifySystems and notifyManagers, Ari used a strange
    // loop condition. I've simplified it here. Hopefully I'm not shooting myself in the foot.
    private inline function notifySystems(post: EntitySystem -> Entity -> Void, e:Entity):Void
    {
        for (i in 0...systemsBag.size) {
            post(systemsBag.get(i), e);
        }
    }

    private inline function notifyManagers(post: Manager -> Entity -> Void, e:Entity):Void
    {
        for(i in 0...managersBag.size) {
            post(managersBag.get(i), e);
        }
    }

    private function check(entities:Bag<Entity>, method:EntityObserver -> Entity -> Void):Void
	{
        if (!entities.isEmpty()) {
            for (i in 0...entities.size) {
                var e = entities.get(i);
                notifyManagers(method, e);
                notifySystems(method, e);
            }
            entities.clear();
        }
    }
	
	private static var fAdded = function (observer:EntityObserver, e:Entity) : Void {
		observer.onAdded(e);
	}
	private static var fChanged = function (observer:EntityObserver, e:Entity) : Void {
		observer.onChanged(e);
	}
	private static var fDisabled = function (observer:EntityObserver, e:Entity) : Void {
		observer.onDisabled(e);
	}
	private static var fEnabled = function (observer:EntityObserver, e:Entity) : Void {
		observer.onEnabled(e);
	}
	private static var fDeleted = function (observer:EntityObserver, e:Entity) : Void {
		observer.onDeleted(e);
	}
}

// TODO Test this thoroughly
// takes each ComponentMapper field in the System and casts them into the correct Component.
// caveat 1: use @Mapper(ComponentName) ComponentMapper annotation instead of @Mapper ComponentMapper<ComponentName>
// caveat 2: also you must give the FULL class name (my.package.ComponentName instead of just ComponentName), this is a limitation of resolveClass
private class ComponentMapperInitHelper
{
    public static function config(target:Dynamic, world:World)
    {
        try {
            var annotations = haxe.rtti.Meta.getFields(Type.getClass(target));
            
            for (fieldName in Reflect.fields(annotations)) {
                var componentClassName = Reflect.field(annotations, fieldName).Mapper[0];
                
                if (componentClassName != null) {
                    var componentType:Class<Dynamic> = Type.resolveClass(componentClassName);
                    Reflect.setField(target, fieldName, world.getMapper(componentType));
                }
            }
        } catch (msg:String) {
            trace("Error in CompError while setting component mappers: " + msg);
        }
    }
}

private class Performer {
	public function new() {}
	public function perform(observer:EntityObserver, e:Entity) {
		
	}
}
