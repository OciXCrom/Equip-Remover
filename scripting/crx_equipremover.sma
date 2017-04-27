#include <amxmodx>
#include <amxmisc>
#include <engine>

#define PLUGIN_VERSION "1.1"

new const g_szEntities[][] = { "player_weaponstrip", "game_player_equip" }

public plugin_init() 
{
	register_plugin("Equip Remover", PLUGIN_VERSION, "OciXCrom")
	register_cvar("CRXEquipRemover", PLUGIN_VERSION, FCVAR_SERVER|FCVAR_SPONLY|FCVAR_UNLOGGED)
	ReadFile()
}

ReadFile()
{
	new szConfigsName[256], szFilename[256]
	get_configsdir(szConfigsName, charsmax(szConfigsName))
	formatex(szFilename, charsmax(szFilename), "%s/EquipRemover.ini", szConfigsName)
	
	if(!file_exists(szFilename))
		goto @CP_REMOVE
		
	new szMap[32], bool:bMatch
	get_mapname(szMap, charsmax(szMap))
	
	new iFilePointer = fopen(szFilename, "rt")
	
	if(iFilePointer)
	{
		new szData[32]
		
		while(!feof(iFilePointer))
		{
			fgets(iFilePointer, szData, charsmax(szData))
			trim(szData)
			
			if(szData[0] == EOS || szData[0] == ';')
				continue
			
			if(equali(szMap, szData))
				bMatch = true
		}
		
		fclose(iFilePointer)
	}
	
	if(!bMatch)
	{
		pause("ad")
		return
	}
		
	@CP_REMOVE:
	
	for(new i, iEnt = -1; i < sizeof(g_szEntities); i++)
	{
		iEnt = -1
		
		while((iEnt = find_ent_by_class(iEnt, g_szEntities[i])))
		{
			if(is_valid_ent(iEnt))
				remove_entity(iEnt)
		}
	}
}