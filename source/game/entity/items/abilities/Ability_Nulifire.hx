package game.entity.items.abilities;

class Ability_Nulifire extends Ability 
{
    public function new() 
    {
        super(false,400,PuppetsAbilityTypeEnum.directional_entity_enemy_character,0,0.5,0,1);
        this.skillpoints = 1;
    }    

    override function functionSpell() {
        super.functionSpell();

        enemyEntity.applieDispell(true);
    }
}