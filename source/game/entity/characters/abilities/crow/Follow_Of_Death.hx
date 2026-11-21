package game.entity.characters.abilities.crow;

import flixel.sound.FlxSound;

class Follow_Of_Death extends Ability 
{
    public function new() 
    {
        super(false,300,directional_entity_enemy_character,0.1,15,0,4,false,Path.getPathCharacter('crow','ability1.png'));

    }   
    override function functionSpell() {
        super.functionSpell();

        enemyEntity.addEffect(new Follow_Of_Death_Effect(selfEntity));
        
    } 
}
class Follow_Of_Death_Effect extends Effect
{
    var entity:Entity;
    var sound:FlxSound;
    public function new(entitySpeed:Entity) 
    {
        super(false);    

        entity = entitySpeed;
        sound = new FlxSound();
        sound.loadEmbedded(Path.getPathCharacter('crow','ability1.ogg'));
    }
    override function activity() {
        setStatusEffect(NONEE,10,function name() {
            sound.play(true,0.0,15.0);
            entity.addFlatBonus('speed',35);
            
        },function () {
            entity.removeFlatBonus('speed',35);
            sound.destroy();
            if (selfEntity.health <= 0)
            {
                
                Sound.playCharacter('crow','ability1_kill');
            }
        },function (elapsed:Float) {
            
        });
    }
}