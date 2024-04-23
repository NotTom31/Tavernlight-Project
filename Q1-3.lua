-- Q1
--For question 1 I added error checks to ensure that releaseStorage is called correctly
local function releaseStorage(player)

    --Early return to ensure that the player value that was passed to releaseStorage is valid
    if not player or not player:isPlayer() then
        print("Error: releaseStorage - Invalid player object")
        return
    end

    -- Attempt to set storage value to -1
    local success = player:setStorageValue(1000, -1)
    if not success then
        print("Error: releaseStorage - Failed to set storage value for player: " .. player:getName())
        return
    end
end
    
function onLogout(player)
    if not player or not player:isPlayer() then
        print("Error: onLogout - Invalid player object")
        return false
    end

    if player:getStorageValue(1000) == 1 then
        addEvent(releaseStorage, 1000, player)
    end
    
    return true
end


--Q2
function printSmallGuildNames(memberCount)
    --this method is supposed to print names of all guilds that have less than memberCount max members
    local selectGuildQuery = "SELECT name FROM guilds WHERE max_members < %d;"
    local query = string.format(selectGuildQuery, memberCount)
    
    -- Execute the SQL query
    local result = db.storeQuery(query)
    
    if not result then
        print("Error: Unable to execute query.")
        return
    end
    
    -- Iterate over each row in the result
    repeat
        local guildName = result.getDataString(result, "name")
        if guildName then
            print(guildName)
        end
    until not result.next(result)
    
    -- Free the result set
    result.free(result)
end

--Q3
-- Removes a specific member from the player's party.
-- playerId The ID of the player.
-- membername The name of the member to be removed.
-- true if the member was removed, false otherwise.
function removeMemberFromParty(playerId, membername)
    local player = Player(playerId)
    if not player then
        print("Error: Player not found.")
        return false
    end
    
    local party = player:getParty()
    if not party then
        print("Error: Player is not in a party.")
        return false
    end
    
    -- Iterate over each member in the party
    for _, member in pairs(party:getMembers()) do --using _ for the index variable is a shorthand way to indicate that it is a throwaway variable that you won't need
        if member:getName() == membername then
            party:removeMember(member)
            print("Member removed from party: " .. membername)
            return true
        end
    end
    
    --If the loop completes without finding a party member, return false and print error message.
    print("Error: Member not found in party.")
    return false
end
