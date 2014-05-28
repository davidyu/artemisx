package com.artemisx;

import com.artemisx.utils.Bag;
import com.artemisx.utils.Bitset;

/**
 * ComponentManager
 * originally written by Arni Arent
 * ported to HaXe by Team Yu
 */

@:allow(com.artemisx)
class ComponentManager extends Manager
{
    private var componentsByType:Bag<Bag<Component>>;   // Try Bag<IntHash<Component> later
    private var deletedEntities:Bag<Entity>;

    public function new() 
    {
        componentsByType = new Bag();
        deletedEntities = new Bag();
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

    private inline function addComponent(e:Entity, type:ComponentType, component:Component) : Void
    {
        componentsByType.ensureCapacity(type.index);

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
        if (components == null) {
            components = new Bag();
            componentsByType.set(type.index, components);
        }
        return components;
    }

    private inline function getComponent(e:Entity, type:ComponentType):Component 
    {
        var components = componentsByType.get(type.index);
        var cmp : Component = null;
        if (components != null) {
            cmp = components.get(e.id);
        }
        return cmp;
    }

    public inline function getComponentsFor(e:Entity):Bag<Component>
    {
        var entityCmps: Bag<Component> = new Bag<Component>();
        var componentBits:Bitset = e.componentBits;
        var i = componentBits.nextSetBit(0);

        while (i >= 0) {
            entityCmps.add(componentsByType.get(i).get(e.id));
            i = componentBits.nextSetBit(i + 1);
        }
        return entityCmps;
    }

    // batch remove all components attached to entities deleted on this update
    private function clean():Void
    {
        if (deletedEntities.size > 0) {
            for (i in 0...deletedEntities.size) {
                removeComponentsOfEntity(deletedEntities.get(i));
            }
            deletedEntities.clear();
        }
    }

    override public function onDeleted(e:Entity):Void { deletedEntities.add(e); }
}
