package com.artemisx;

import com.artemisx.utils.ClassHash;
import com.artemisx.utils.Bag;
import com.artemisx.utils.ImmutableBag;

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

// No protected members here, so no need to allow;
// @:allow(com.artemisx)
class World
{
    @:isVar public var entityManager(default, null):EntityManager;
    @:isVar public var componentManager(default, null):ComponentManager;

    @:isVar public var delta (getDelta, setDelta):Float ;

    private var added:Bag<Entity>;
    private var changed:Bag<Entity>;
    private var deleted:Bag<Entity>;
    private var enable:Bag<Entity>;
    private var disable:Bag<Entity>;

    private var managers:ClassHash<Dynamic, Manager>;
    private var managersBag:Bag<Manager>;

    private var systems:ClassHash<Dynamic, EntitySystem>;
    private var systemsBag:Bag<EntitySystem>;

    public function new()
    {
        managers = new ClassHash<Manager, Manager>();
        managersBag = new Bag<Manager>();

        systems = new ClassHash<Dynamic, EntitySystem>();
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
        manager.setWorld(this);
        return manager;
    }

    public inline function deleteManager(manager:Manager):Void
    {
        managers.remove(Type.getClass(manager)); //not quite sure if this is correct, see canonical implementation
        managersBag.remove(manager);
    }

    public inline function getDelta():Float
    {
        return delta;
    }

    public inline function setDelta(delta:Float):Float
    {
        this.delta = delta;
        return delta;
    }

    public inline function addEntity(e:Entity):Void
    {
        added.add(e);
    }

    public inline function changedEntity(e:Entity):Void
    {
        changed.add(e);
    }

    public inline function deleteEntity(e:Entity):Void {
        if (!deleted.contains(e)) {
            deleted.add(e);
        }
    }

    //note: in the canonical implementation this is simply "enable"
    public inline function enableEntity(e:Entity):Void
    {
        enable.add(e);
    }

    //note: in the canonical implementation this is simply "disable"
    public function disableEntity(e:Entity):Void
    {
        disable.add(e);
    }

    public inline function createEntity():Entity
    {
        return entityManager.createEntityInstance();
    }

    public inline function getEntity(entityId:Int):Entity
    {
        return entityManager.getEntity(entityId);
    }

    public inline function getSystems():ImmutableBag<EntitySystem>
    {
        return systemsBag;
    }

    // passive = true -> will not be processed by World
    public inline function setSystem<T:EntitySystem> (system:T, ?passive : Bool = false) : T
    {
        system.world = this;
        system.setPassive(passive);
        systems.set(Type.getClass(system), system);
        systemsBag.add(system);
        return system;
    }

    public inline function deleteSystem(system:EntitySystem):Void
    {
        systems.remove(Type.getClass(system));
        systemsBag.remove(system);
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

	public inline function getSystem<T:EntitySystem> (type:Class<T>):T
    {
		return cast(systems.get(type));
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

    public inline function process():Void
    {
        check(added,
              function (observer:EntityObserver, e:Entity) : Void
              {
                  observer.onAdded(e);
              });

        check(changed,
              function (observer:EntityObserver, e:Entity) : Void
              {
                  observer.onChanged(e);
              });

        check(disable,
              function (observer:EntityObserver, e:Entity) : Void
              {
                  observer.onDisabled(e);
              });

        check(enable,
              function (observer:EntityObserver, e:Entity) : Void
              {
                 observer.onEnabled(e);
              });

        check(deleted,
              function (observer:EntityObserver, e:Entity) : Void
              {
                  observer.onDeleted(e);
              });

        componentManager.clean();

        for (i in 0...systemsBag.size) {
            var system = systemsBag.get(i);
            if (!system.passive) {
                system.process();
            }
        }
    }

    public inline function getMapper<T:Component> (type:Class<T>) : ComponentMapper<T>
    {
        return ComponentMapper.getFor(type, this);
    }
}