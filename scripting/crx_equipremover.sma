#include <amxmodx>
#include <amxmisc>
#include <engine>

#define PLUGIN_VERSION "1.0"

new const g_szEntities[][] = { "player_weaponstrip", "game_player_equip" }

public plugin_init() 
{
	register_plugin("Equip Remover", PLUGIN_VERSION, "OciXCrom")
	register_cvar("@EquipRemover", PLUGIN_VERSION, FCVAR_SERVER|FCVAR_SPONLY|FCVAR_UNLOGGED)
	fileRead()
}

fileRead()
{
	new szConfigsName[256], szFilename[256], szMap[32], bool:blMatch
	get_configsdir(szConfigsName, charsmax(szConfigsName))
	formatex(szFilename, charsmax(szFilename), "%s/EquipRemover.ini", szConfigsName)
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
				blMatch = true
		}
		
		fclose(iFilePointer)
	}
	
	if(!blMatch)
		pause("ad")
	else
	{
		for(new i, iEnt = -1; i < sizeof(g_szEntities); i++)
		{
			iEnt = -1
			
			while((iEnt = find_ent_by_class(iEnt, g_szEntities[i])))
				if(is_valid_ent(iEnt))
					remove_entity(iEnt)
		}
	}
}