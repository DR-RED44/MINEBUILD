local function shutdown_multiplayer_server()
    minetest.request_shutdown("This game is single-player only.", false)
end

if not minetest.is_singleplayer() then
    minetest.log("warning", "singleplayer_lock: Multiplayer server startup blocked.")
    minetest.after(0, shutdown_multiplayer_server)
else
    minetest.register_on_joinplayer(function(player)
        local players = minetest.get_connected_players()

        if #players > 1 then
            local player_name = player:get_player_name()
            minetest.kick_player(player_name, "This game is single-player only.")
        end
    end)
end