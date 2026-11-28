package game.entity.characters.abilities.necrophos;

class Ghost_Shroud extends Ability
{
    public function new() 
    {
        super(false,400,non_directional_aura,0,5,15,4,false,"assets/player/characters/necrophos/ghost.png");
        setOptionPoint("cooldown",[5,5,5,5]);
        setOptionPoint("manacost",[5,5,5,5]);
      //  updateOptionsPoints();
    }

    override function functionSpell() 
    {
        Sound.playCharacter('necrophos','spirit_form');
        selfEntity.addEffect(new Necrophos_Effect_Ghost_Shroud());
    } 
}
class Necrophos_Effect_Ghost_Shroud extends Effect
{
    public function new() 
    {
		super(true, "assets/player/characters/necrophos/ghost.png", "Ethereal", 'etheral and get more magic', true, true);
    }
    override function activity() {
        
        var sw = selfEntity.health_regeneration + (selfEntity.health_regeneration * 60 / 100);
        setStatusEffect(ETHEREAL,2.5,function name() {
            selfEntity.addFlatBonus("health_regeneration",sw);
        },function s() {
            selfEntity.removeFlatBonus("health_regeneration",sw);
        },null);
    }
}