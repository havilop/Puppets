package game.entity.characters.abilities;


import flixel.FlxG;
import flixel.util.FlxCollision;

class BaseAbility extends Ability
{ 

    public function new() 

    {

        super(false,325,non_directional_aura,0,0,0,1,false,"assets/player/hud/ability_null.png");
        this.skillpoints = 1;

    }

    override function functionSpell() 
    {

    }
}
