package game.entity.characters.abilities.necrophos;

import flixel.FlxG;
import flixel.util.FlxCollision;
import game.entity.characters.abilities.monkey_king.Jingu_Mastery.Jingu_Mastery_Effet;

class HeartStopped_Aura extends Ability
{ 
    var damage:Float = 0;

    public function new() 

    {

        super(true,325,non_directional_aura,0,0,0,4,true,"assets/player/characters/necrophos/aura.png");

        this.setUpdate(0.2);

        super.setOptionPoint("damage",[0.11,0.15,0.21,0.27]);

    }

    override function functionSpell() 
    {
        PlayState.groupEntities.forEachAlive(function (player:Entity) 
        {
            if (player.typeEntity == CHARACTER)
            {
                if (player != selfEntity && player.team != selfEntity.team && !player.dead)
                {
                     if (FlxCollision.pixelPerfectCheck(rangeHitBox,player.entityHitbox))
                     {

                        var damagee = player.maxhealth - ((player.maxhealth - (player.maxhealth * damage / 100)));
                        var damageink = ( damagee + (selfEntity.health_regeneration * 0.5) );
                        player.takeDamage(magic,damageink,selfEntity);  
                     }
                }
            }
        });
    }

      
     
    
}