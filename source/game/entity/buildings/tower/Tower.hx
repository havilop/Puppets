package game.entity.buildings.tower;

class Tower extends Entity
{
	public function new(TEAM:PuppetsTeamEnum) 
    {
        super();
		team = TEAM;
        typeEntity = BUILDING;

        name = "TOWER";
		setAbilities([TowerAttack]);

		this.addFlatBonus('maxhealth', 1800);
		this.addFlatBonus('health_regeneration', -1.1);
		health = 1800;

		entityHitbox.setGraphicSize(75, 125);
		entityHitbox.updateHitbox();
		PlayState.mapHud.addIcon(this);
    }
}