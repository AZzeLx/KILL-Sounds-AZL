#include <cstrike>
#include <sourcemod>
#include <sdktools>
#include <sdkhooks>
#include <clientprefs>

#pragma semicolon 1

int kills[MAXPLAYERS+1];

Handle g_KillSounds_Cookie;
bool g_IsKSoundsEnabled[MAXPLAYERS + 1];

public Plugin myinfo = 
{
	name = "Kill Sounds",
	author = "AZzeL",
	description = "Show Kill Sounds",
	version = "1,0",
	url = "https://fireon.ro"
};

public void OnPluginStart()
{
	g_KillSounds_Cookie = RegClientCookie("KillSoundsCookie", "KillSoundsCookie", CookieAccess_Protected);

	HookEvent("player_death", Event_PlayerDeath);

	RegConsoleCmd("qs",Command_KILLSounds);
}

public void OnClientPutInServer(int client)
{
	g_IsKSoundsEnabled[client] = true;

	char buffer[64];
	GetClientCookie(client, g_KillSounds_Cookie, buffer, sizeof(buffer));
	if(StrEqual(buffer,"0"))
		g_IsKSoundsEnabled[client] = false;
}

public Action Command_KILLSounds(int client, int args) 
{
	if(g_IsKSoundsEnabled[client])
	{
		PrintToChat(client, " \x02KILL Sounds is now off");
		g_IsKSoundsEnabled[client] = false;
		SetClientCookie(client, g_KillSounds_Cookie, "0");
	}
	else
	{
		PrintToChat(client, " \x04KILL Sounds is now on");
		g_IsKSoundsEnabled[client] = true;
		SetClientCookie(client, g_KillSounds_Cookie, "1");
	}

	return Plugin_Handled;
}

public Event_PlayerDisconnect(Handle event, const char[] name, bool dontBroadcast)
{
	int attacker = GetClientOfUserId(GetEventInt(event, "userid"));
	kills[attacker] = 0;
}

public Event_PlayerDeath(Handle event, const char[] name, bool dontBroadcast)
{
	int victim = GetClientOfUserId(GetEventInt(event, "userid"));
	int attacker = GetClientOfUserId(GetEventInt(event, "attacker"));
	if(attacker == 0){return;}

       	if (g_IsKSoundsEnabled[attacker])  
        { 
		kills[attacker]++;

		if(kills[attacker] == 1)
		{
			ClientCommand(attacker, "play *AZL/KillSounds/firstblood.mp3");
		} else {
			if(kills[attacker] == 2)
			{
				ClientCommand(attacker, "play *AZL/KillSounds/doublekill.mp3");
			} else {
				if(kills[attacker] == 3)
				{
					ClientCommand(attacker, "play *AZL/KillSounds/triplekill.mp3");
				}else {
					if(kills[attacker] == 4)
					{
						ClientCommand(attacker, "play *AZL/KillSounds/qudrakill.mp3");
					} else {
						if(kills[attacker] == 5)
						{
							ClientCommand(attacker, "play *AZL/KillSounds/pentakill.mp3");
						} else {
							if(kills[attacker] == 6)
							{
								ClientCommand(attacker, "play *AZL/KillSounds/hexakill.mp3");
							}
						}
					}
				}
			}
		}
	}

	kills[victim] = 0;
}
