package com.artemis;

/**
 *
 * The EntityObserver interface. Used for subscribing/listening to entity events
 *  originally written by Arni Arent
 *  ported to HaXe by Lewen Yu
 *
 */


interface EntityObserver {

    function added( e : Entity ) : Void;

    function changed( e : Entity ) : Void;

    function deleted( e : Entity ) : Void;

    function enabled( e : Entity ) : Void;

    function disabled( e : Entity ) : Void;
}

