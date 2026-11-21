package game.entity.characters.abilities.necrophos;

import flixel.FlxG;
import flixel.util.FlxCollision;


class Sadist extends Ability
{ 

    public function new() 

    {

        super(true,325,non_directional_aura,0,0,0,1,true,"assets/player/characters/necrophos/aura.png");

        this.skillpoints = 1;

        updateOptionsPoints();
    }

    override function functionSpell() 
    {
      
    }
    override function addSignals() {
        super.addSignals();

        selfEntity.onKilledSomeone.add(function () 
        {
           selfEntity.heal(5); 
        });
    }
}