package game.entity.characters.abilities.necrophos;

import flixel.FlxG;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxCollision;
import game.entity.characters.abilities.necrophos.Death_Pulse.Skull;

class Death_Seeker extends Ability
{ 
    var heal:Int = 0;
    var damage:Int = 0;
  
    var isCall = false;

    public function new() 

    {

        super(false,250,directional_entity_enemy_character,0.3,0,0,4,false,"assets/player/characters/necrophos/death_pulse.png");
        this.description = "The hero goes to another hero";
        super.setOptionPoint("range",[250,300,325,340]);
        super.setOptionPoint("cooldown",[16,14,13,11]);
        super.setOptionPoint("manacost",[115,130,145,160]);
        super.setOptionPoint("damage",[150,200,250,300]);
        super.setOptionPoint("heal",[100,125,150,180]);





    }

    override function update(elapsed:Float) {
        super.update(elapsed);

this.forEachOfType(Skull, function(skull:Skull) {
            if (!skull.alive)
            {

            
            skull.destroy();
			this.remove(skull, true);

            }
        });

      
    }

  override function functionSpell() 
  {
        selfEntity.heal(heal);

        PlayState.groupEntities.forEachAlive(function (player:Entity) 
        {
            if (player.typeEntity != COURIER && player.typeEntity != BUILDING )
            {
                if (player != selfEntity && player.team != selfEntity.team)
                {
                     if (FlxCollision.pixelPerfectCheck(rangeHitBox,player.entityHitbox))
                     {

                        var skull = new Skull(selfEntity.entityHitbox.x,selfEntity.entityHitbox.y,player,damage,selfEntity);
                        add(skull); 
                        selfEntity.addEffect(new DS_effect());
                        
                     }
                }
            }
        }); 

  }
        
    
}
class DS_effect extends Effect {
    public function new() 
    {
        super(true);    
    }
    override function activity() {
        setStatusEffect(NONEE,5);
    }
}
