// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script} from "forge-std/Script.sol";
import {TelegramRegistry} from "../src/TelegramRegistry.sol";

contract DeployTelegramRegistry is Script {
    function run() external returns (TelegramRegistry) {
        // Починаємо broadcast транзакцій
        vm.startBroadcast();

        // Деплоїмо контракт
        TelegramRegistry registry = new TelegramRegistry();

        // Закінчуємо broadcast
        vm.stopBroadcast();

        return registry;
    }
}
