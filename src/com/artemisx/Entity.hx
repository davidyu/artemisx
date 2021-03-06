package com.artemisx;

import com.artemisx.utils.Bag;
import com.artemisx.utils.Bitset;
import com.artemisx.utils.UUID;

/**
 *
 *  The entity class.
 *  originally written by Arni Arent
 *  ported to HaXe by Team Yu
 *
 */

@:allow(com.artemisx)
class Entity 
{
    @:isVar public var uuid (get_uuid, null):String;
    @:isVar public var id (get_id, null):Int;
    @:isVar public var componentBits (get_componentBits, null):Bitset;
    @:isVar public var systemBits (get_systemBits, null):Bitset;

    private var world:World;
    private var entityManager:EntityManager;
    private var componentManager: ComponentManager;

    private function new(world:World, id:Int) 
    {
        this.world = world;
        this.id = id;
        entityManager = world.entityManager;
        componentManager = world.componentManager;
        systemBits = new Bitset();
        componentBits = new Bitset();

        reset();
    }

    private function reset() {
        systemBits.clear();
        componentBits.clear();
        uuid = UUID.getUuid();
    }

    public inline function addComponent(component:Component):Entity 
    {
        addComponentOfType(component, ComponentType.getTypeFor(Type.getClass(component)));
        return this;
    }

    public inline function addComponentOfType(component:Component, type:ComponentType):Entity
    {
        componentManager.addComponent(this, type, component);
        return this;
    }

    public inline function removeComponent(c:Class<Component>):Entity
    {
        removeComponentOfType(ComponentType.getTypeFor(c));
        return this;
    }

    public inline function removeComponentInstance(component:Component):Entity 
    {
        removeComponentOfType(ComponentType.getTypeFor(Type.getClass(component)));
        return this;
    }

    public inline function removeComponentOfType(type:ComponentType):Entity
    {
        componentManager.removeComponent(this, type);
        world.changedEntity( this, true );
        return this;
    }

    public function listComponents() : String {
        var str = "[ id:" + id + ">" ;

        var iter = componentBits.iter();
        for ( i in iter ) {
            str += " " + ComponentType.className( ComponentType.getTypeFromIndex( i ) );
        }

        str += " ]";
        return str;
    }

#if ( debug || fdb )
    // Examine components in more detail
    public function dumpComponents() : Array<Component> {
        var list = new Array<Component>();

        var iter = componentBits.iter();
        for ( i in iter ) {
            list.push( getComponentOfType( ComponentType.getTypeFor( ComponentType.getTypeFromIndex( i ) ) ) );
        }

        return list;
    }
#end

    public function toString() : String {
        return listComponents();
    }

    public function getWorld() { return world; }

    public inline function getComponentOfType(type:ComponentType):Component { return componentManager.getComponent(this, type); }
    // TODO: Ugly gets... probably not right.
    public inline function getComponent<T:Component>(clazz:Class<T>):T { return cast(componentManager.getComponent(this, ComponentType.getTypeFor(cast(clazz)))); }
    public inline function getComponents():Bag<Component> { return componentManager.getComponentsFor(this); }

    public inline function isActive():Bool { return entityManager.isActive(id); }
    public inline function isEnabled():Bool { return entityManager.isEnabled(id); }

    public inline function addToWorld() { world.addEntity(this); }
    public inline function changedInWorld() { world.changedEntity(this); }
    public inline function deleteFromWorld() { world.deleteEntity(this); }

    public inline function enable() { world.enableEntity(this); }
    public inline function disable() { world.disableEntity(this); }

    private inline function get_uuid() { return uuid; }
    private inline function get_id() { return id; }

    private inline function get_componentBits():Bitset { return componentBits; }
    private inline function get_systemBits():Bitset { return systemBits; }
}
