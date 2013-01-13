package com.artemisx;

/**
 *
 * The EntityObserver interface. Used for subscribing/listening to entity events
 *  originally written by Arni Arent
 *  ported to HaXe by Lewen Yu and Harry
 *
 */

@:allow(com.artemisx)
interface EntityObserver {

    function onAdded(e:Entity):Void;

    function onChanged(e:Entity):Void;

    function onDeleted(e:Entity):Void;

    function onEnabled(e:Entity):Void;

    function onDisabled(e:Entity):Void;
}

