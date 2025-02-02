// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TelegramRegistry {
    // Константа для оплати реєстрації (0,005 ETH)
    uint256 public constant REGISTRATION_FEE = 0.0001 ether;

    // Відображення: Telegram ID (рядок) -> адреса користувача, яка здійснила реєстрацію
    mapping(string => address) public telegramOwners;

    // Адреса власника контракту (для виведення коштів, наприклад)
    address public owner;

    // Подія, яка логуватиме реєстрацію
    event Registered(string telegramId, address indexed registrant);

    constructor() {
        owner = msg.sender;
    }

    // Модифікатор для викликів, доступних лише власнику
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this operation");
        _;
    }

    /**
     * @notice Реєстрація користувача за допомогою його Telegram ID.
     * @param telegramId Рядок з унікальним Telegram ID користувача.
     * @dev Для реєстрації користувач повинен відправити рівно 0,005 ETH.
     */
    function register(string calldata telegramId) external payable {
        require(msg.value == REGISTRATION_FEE, "The wrong amount of ETH was sent");
        require(telegramOwners[telegramId] == address(0), "Telegram ID is already registered");

        // Зберігаємо, що даний Telegram ID зареєстрований певною Ethereum-адресою
        telegramOwners[telegramId] = msg.sender;
        emit Registered(telegramId, msg.sender);
    }

    /**
     * @notice Функція перевіряє, чи зареєстрований в системі певний Telegram ID.
     * @param telegramId Рядок з Telegram ID.
     * @return true, якщо Telegram ID знайдений (зареєстрований), інакше false.
     */
    function isRegistered(string calldata telegramId) external view returns (bool) {
        return telegramOwners[telegramId] != address(0);
    }

    /**
     * @notice Функція для видалення Telegram ID з реєстру.
     * @param telegramId Рядок з Telegram ID.
     */
    function deleteTelegramId(string calldata telegramId) external {
        delete telegramOwners[telegramId];
    }

    /**
     * @notice Функція для виведення накопичених ETH із контракту власником.
     */
    function withdraw() external onlyOwner {
        payable(owner).transfer(address(this).balance);
    }
}
