package game.entity.characters.abilities.necrophos;

import flixel.FlxG;
import flixel.util.FlxCollision;

class Scythe extends Ability
{ 
    var duration:Int = 0;
    var cof:Float = 0;
    var perm_bonus = 0;

    public function new() 

    {

        super(false,300,directional_entity_enemy_character,1.5,0,0,3,false,"assets/player/characters/necrophos/ult.png",true);
        this.description = "Stunning the enemy and  when stun is over the enemy deals the damage per him maxhealth - health and when the person kill the enemy with scythe gives bonus to health_regeneration";
        super.setOptionPoint("cooldown",[0,100,100]);
        super.setOptionPoint("manacost",[200,200,200]);
        super.setOptionPoint("duration",[1,1.3,1.6]);
        super.setOptionPoint("cof",[0.7,0.8,0.9]);
        super.setOptionPoint("perm_bonus",[3,6,9]);
       // super.updateOptionsPoints();

    }

    override function functionSpell() 
    {
        Sound.playCharacter('necrophos','reapers_scythe_begin');
        enemyEntity.addEffect(new Effect_Necrophos_Scythe(cof,selfEntity,perm_bonus));
    }
}
class Effect_Necrophos_Scythe extends Effect
{
    var cof:Float = 0;
    var otherPlayer:Entity;
    var bonus:Int;
    public function new(Cof:Float,OtherPlayer:Entity,Bonus:Int) 
    {
       super(true);
       cof = Cof;
       otherPlayer = OtherPlayer;
       bonus = Bonus;
    }
    override function activity() {
        
        setStatusEffect(STUN,1.5,function name() {
            selfEntity.addVisualEffect(new Scythe_Effect());
            Sound.playCharacter('necrophos','scythe_target');
        },function name() {
            selfEntity.takeDamage(magic,Std.int((selfEntity.maxhealth - selfEntity.health) * cof),otherPlayer);
            if (selfEntity.health <= 0)
            {
                otherPlayer.addFlatBonus("health_regeneration",bonus);
                otherPlayer.addFlatBonus("mana_regeneration",bonus / 2);
            }
        });        
        
    }
    


}
class Scythe_Effect extends VisualEffect 
{
    var image:FlxSprite;

    public function new() 
    {
        super();
        image = new FlxSprite(0,0,'assets/player/characters/necrophos/scythe.png');
        
        add(image);
    }   
    override function update(elapsed:Float) {
        super.update(elapsed);
        image.x = selfEntity.entityHitbox.x;
        image.y = selfEntity.entityHitbox.y;
    } 
}