//Method 1 using new and delete
void Game::addItemToPlayer(const std::string& recipient, uint16_t itemId)
{
    Player* player = g_game.getPlayerByName(recipient);
    if (!player) {
        player = new Player(nullptr);
        if (!IOLoginData::loadPlayerByName(player, recipient)) {
            delete player; //free up the new player object before return
            return;
        }
    }

    Item* item = Item::CreateItem(itemId);
    if (!item) {
        delete player; //free up the new player object before return
        return;
    }
    
    g_game.internalAddItem(player->getInbox(), item, INDEX_WHEREEVER, FLAG_NOLIMIT);
    
    if (player->isOffline()) {
        IOLoginData::savePlayer(player);
    }
    delete player; //free up the new player object after its been used
}


//we can also avoid using new all together if we are on C++ 14 or newer 
//we can make use of smart pointers that manage the lifetime of dynamically allocated objects.

//Method 2 using make_unique
#include <memory> // Include for std::make_unique

void Game::addItemToPlayer(const std::string& recipient, uint16_t itemId)
{
    std::unique_ptr<Player> player = g_game.getPlayerByName(recipient);
    if (!player) {
        player = std::make_unique<Player>(nullptr);
        if (!IOLoginData::loadPlayerByName(player.get(), recipient)) {
            // No need to delete, unique_ptr will handle cleanup
            return;
        }
    }

    std::unique_ptr<Item> item = Item::CreateItem(itemId);
    if (!item) {
        // No need to delete, unique_ptr will handle cleanup
        return;
    }
    
    g_game.internalAddItem(player->getInbox(), item.get(), INDEX_WHEREEVER, FLAG_NOLIMIT);
    
    if (player->isOffline()) {
        IOLoginData::savePlayer(player.get());
    }
    
    // No need to delete, unique_ptr will handle cleanup
}