package com.artemis;

import com.utils.ClassHash;
import com.utils.Bag;
import com.utils.ImmutableBag;

// takes each ComponentMapper field in the System and casts them into the correct Component.

// caveat 1: use @Mapper(ComponentName) ComponentMapper annotation instead of @Mapper ComponentMapper<ComponentName>
// caveat 2: also you must give the FULL class name (my.package.ComponentName instead of just ComponentName), this is a limitation of resolveClass
private class ComponentMapperInitHelper
{
    public static function config(target : Dynamic, world : World)
    {
        var annotations = haxe.rtti.Meta.getFields(Type.getClass(target));
        for ( fieldName in Reflect.fields(annotations) )
        {
            var componentClassName = Reflect.field(annotations, fieldName).Mapper[0];
            if (componentClassName != null)
            {
                var componentType : Class<Dynamic> = Type.resolveClass(componentClassName);
                Reflect.setField(target, fieldName, world.getMapper(componentType));
            }
        }
    }
}

class World
{
    public var em(default, null):EntityManager;
    public var cm(default, null):ComponentManager;

    public var delta (getDelta, setDelta) : Float ;

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

        cm = new ComponentManager();
        setManager(cm);

        em = new EntityManager();
        setManager(em);
    }

    public function initialize():Void
    {
        for (i in 0...managersBag.size)
        {
            managersBag.get(i).initialize();
        }

        for (i in 0...systemsBag.size)
        {
            ComponentMapperInitHelper.config(systemsBag.get(i), this);
            systemsBag.get(i).initialize();
        }
    }

    public function getEntityManager() : EntityManager
    {
        return em;
    }

    public function getComponentManager() : ComponentManager
    {
        return cm;
    }

    public function setManager<M : Manager> (manager : M) : M
    {
        managers.set(Type.getClass(manager), manager);
        managersBag.add(manager);
        manager.setWorld(this);
        return manager;
    }

    public function getManager<M : Manager> (managerType:Class<M>) : M
    {
        var man : M;
        if (Std.is(managers.get(managerType), managerType))
        {
            man = cast managers.get(managerType);
            return man;
        }

        return null;
    }

    public function deleteManager<M : Manager>(manager : M) : Void
    {
        managers.remove(Type.getClass(manager)); //not quite sure if this is correct, see canonical implementation
        managersBag.removeElement(cast (manager, Manager));
    }

    public function getDelta() : Float
    {
        return delta;
    }

    public function setDelta(delta : Float) : Float
    {
        this.delta = delta;
        return delta;
    }

    public function addEntity(e : Entity) : Void
    {
        added.add(e);
    }

    public function changedEntity(e : Entity) : Void
    {
        changed.add(e);
    }

    public function deleteEntity(e : Entity) : Void {
        if (!deleted.contains(e))
        {
            deleted.add(e);
        }
    }

    //note: in the canonical implementation this is simply "enable"
    public function addEnable(e : Entity) : Void
    {
        enable.add(e);
    }

    //note: in the canonical implementation this is simply "disable"
    public function addDisable(e : Entity) : Void
    {
        disable.add(e);
    }

    public function createEntity() : Entity
    {
        return em.createEntityInstance();
    }

    public function getEntity(entityId : Int) : Entity
    {
        return em.getEntity(entityId);
    }

    public function getSystems() : ImmutableBag<EntitySystem>
    {
        return systemsBag;
    }

    // passive = true -> will not be processed by World
    public function setSystem<T : EntitySystem> (system : T, passive : Bool)
    {
        system.setWorld(this);
        system.setPassive(passive);
        systems.set(Type.getClass(system), system);
        systemsBag.add(system);
        return system;
    }

    //note: function below is simply overloaded setSystem in the canonical implementation
    public function setSystemToProcess<T:EntitySystem> (system : T)
    {
        return setSystem(system, false);
    }

    public function deleteSystem(system : EntitySystem) : Void
    {
        systems.remove(Type.getClass(system));
        systemsBag.removeElement(system);
    }

    //note to self: in the canonical implementations of notifySystems and notifyManagers, Ari used a strange
    // loop condition. I've simplified it here. Hopefully I'm not shooting myself in the foot.
    private function notifySystems(post: EntitySystem -> Entity -> Void, e : Entity) : Void
    {
        for (i in 0...systemsBag.size)
        {
            post(systemsBag.get(i), e);
        }
    }

    private function notifyManagers(post: Manager -> Entity -> Void, e : Entity) : Void
    {
        for(a in 0...managersBag.size)
        {
            post(managersBag.get(a), e);
        }
    }

    public function getSystem<T : EntitySystem> (type : Class<T>) : T
    {
        var sys : T;
        if (Std.is(systems.get(type), type))
        {
            sys = cast systems.get(type);
            return sys;
        }

        return null;
    }

    private function check(entities : Bag<Entity>, postMethod: EntityObserver -> Entity -> Void) : Void
    {
        if (!entities.isEmpty()) {
            for (i in 0...entities.size)
            {
                var e = entities.get(i);
                notifyManagers(postMethod, e);
                notifySystems(postMethod, e);
            }
            entities.clear();
        }
    }

    public function process() : Void
    {
        check(added,
              function (observer : EntityObserver, e : Entity) : Void
              {
                  observer.onAdded(e);
              });

        check(changed,
              function (observer : EntityObserver, e : Entity) : Void
              {
                  observer.onChanged(e);
              });

        check(disable,
              function (observer : EntityObserver, e : Entity) : Void
              {
                  observer.onDisabled(e);
              });

        check(enable,
              function (observer : EntityObserver, e : Entity) : Void
              {
                 observer.onEnabled(e);
              });

        check(deleted,
              function (observer : EntityObserver, e : Entity) : Void
              {
                  observer.onDeleted(e);
              });

        cm.clean();

        for (i in 0...systemsBag.size)
        {
            var system = systemsBag.get(i);
            if (!system.isPassive()) {
                system.process();
            }
        }
    }

    public function getMapper<T : Component> (type : Class<T>) : ComponentMapper<T>
    {
        return ComponentMapper.getFor(type, this);
    }
}
