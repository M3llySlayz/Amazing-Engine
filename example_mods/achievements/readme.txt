Put your achievement jsons here.

Here's an example of an achievement (your JSON should look like this):

{
	"name": "Road to Ten Million",
	"desc": "Gain 10 Million scores in total.",
	"save_tag": "ten_million",
	"hidden": false,
	"clearAchievements": true,
        "week_nomiss": null,
        "lua_code": null,
	"global": null,
	"index": -1,
        "song": ""
}
Note that using this will add your achievement to the menu, but if you wanna get rid of all the other ones, structure it this way:

{
	"name": "",
	"desc": "",
	"save_tag": "",
	"hidden": false,
	"clearAchievements": false,
	"index": null,
        "song": null,
        "global":  [
            this part is where ALL your achievements go, so if you plan on doing this, make sure you know it's just one file. (don't copy paste this part lol)
            ["Road to Ten Million", "Gain 10 Million scores in total.", "ten_million", false],
            ["Road to a Billion", "Gain 1 Billion scores in total.", "one_billion", false]
        ]
}


As for giving it, your LUA file should probably be in `scripts`, with something along these lines:
function onUpdate(elapsed) 
  if getProperty("songScore") >= 10000000 then
    giveAchievement("ten_million")
   -- will return "Unlocked Achievement ten_million" if this achievement is not unlocked
   -- if it is already unlocked, it will return "Achievement ten_million is already unlocked!"
   -- if the achievement does not exist, it will return "Achievement ten_million does not exist"
  end
end