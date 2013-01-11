package com.artemis;

import com.utils.Bag;
import com.utils.ImmutableBag;

/**
 * ...
 * @author 
 */

class EntitySystem implements EntityObserver
{
    public var world (default, setWorld) : World;
    public var passive(isPassive, setPassive) : Bool;
    public var actives : Bag<Entity>;

    public function new() 
    {
    }

    public function initialize()
    {
    }

    public function onAdded( e:Entity )
    {
    }

    public function onChanged( e:Entity )
    {
    }

    public function onDeleted( e:Entity )
    {
    }

    public function onDisabled( e:Entity )
    {
    }

    public function onEnabled( e:Entity )
    {
    }

    private function begin() : Void
    {
    }

    public function process() : Void {
        if(checkProcessing()) {
            begin();
            processEntities(actives);
            end();
        }
    }

    private function end() : Void
    {
    }

    private function processEntities(entities : ImmutableBag<Entity>) : Void
    {
    }

    public function setWorld(world : World) : World
    {
        this.world = world;
        return world;
    }

    private function checkProcessing() : Bool
    {
        return true;
    }

    public function setPassive(passive : Bool) : Bool
    {
        this.passive = passive;
        return passive;
    }

    public function isPassive() : Bool
    {
        return passive;
    }

}
