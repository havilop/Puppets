package game.entity.buildings.tower;

class TowerAttack extends Ability
{
    public function new() 
    {
        super(true,500,non_directional_aura,0,0,0,1,false);
        this.skillpoints = 1;
        this.setUpdate(3);    
    }
    override function functionSpell() {
        super.functionSpell();

         
    }
}