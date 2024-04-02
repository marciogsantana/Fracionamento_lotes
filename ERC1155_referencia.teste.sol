// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

 * @dev ERC1155GamingExplained está usando ERC1155 para criação de multi-tokens,
 * ERC1155Supply que adiciona rastreamento do token retornando seu totalBalance e
 * Ownable para garantir que só o dono do contrato pode executar funções adminstrativas do contrato
 */
contract ERC1155GamingExplained is ERC1155, ERC1155Supply, Ownable {
    /*
     * @dev nome do contrato, muito usado por marketplaces
     */
    string public constant name = "GamingExplained";
    /*
     * @dev assets é o mapping é necessário para o gerenciamento diferentes metadaUrl de cada token
     * existente no contrato
     */
    mapping(uint256 => TokenMetadata) public assets;
    /*
     * @dev TokenMetadata tipo customizável que serve para adicionar novos tokenIds
     */
    struct TokenMetadata {
        bool exists;
        bool isNonFungible;
        TokenType tokenType;
        string metadataURI;
    }
    /*
     * @dev TokenType tipos de token aceitos nesse contrato
     */
    enum TokenType {
        GOLD,
        ITEMS,
        WOOD
    } // GOLD = 0, ITEMS: 1, WOOD = 2
    /*
     * @dev TokenIdExist erro customizado para reverter a transação já exista
     */
    error TokenIdExists(uint256);
    /*
     * @dev TokenIdDoesNotExist erro customizado para reverter a transação caso o token não exista
     */
    error TokenIdDoesNotExist(uint256);
    /*
     * @dev TokenIdDoesNotExist erro customizado para reverter a transação caso o token não exista
     */
    error TokenIdNFTMinted(uint256);

    /*
     * @dev o paramêtro contractMetadata(https://example.com)
     * @param contractMetadata é um metadado utilizado a nível do contrato
     */
    constructor(string memory contractMetadata)
        ERC1155(contractMetadata)
        Ownable(_msgSender())
    {}

    /*
     * @dev O metódo addToken não é implementado para força você que tá só lendo a práticar
     * Depois de ler em entender, pratique, rescreva, melhore este código, assim você vai aprender.
     * Lembre-se entender não é aprender! Mete bronca aí no código.
     */
    function addToken(
        uint256 tokenId,
        bool isNonFungible,
        TokenType tokenType,
        string memory metadataURI
    ) external onlyOwner {
        if (assets[tokenId].exists) {
            revert TokenIdExists(tokenId);
        }

        assets[tokenId] = TokenMetadata({
            exists: true,
            isNonFungible: isNonFungible,
            tokenType: tokenType,
            metadataURI: metadataURI
        });
    }

    /*
     * @dev mint de novos tokens se o tokenId estive cadastrado
     */
    function mint(
        address account,
        uint256 tokenId,
        uint256 value
    ) external onlyOwner {
        if (!assets[tokenId].exists) {
            revert TokenIdDoesNotExist(tokenId);
        }

        if (assets[tokenId].isNonFungible == true) {
            if (super.totalSupply(tokenId) == 1) {
                revert TokenIdNFTMinted(tokenId);
            }
            _mint(account, tokenId, 1, "");
        } else {
            _mint(account, tokenId, value, "");
        }
    }

    /*
     * @dev retorna a uri do tokenId
     */
    function uri(uint256 tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        return assets[tokenId].metadataURI;
    }

    /*
     * @ contractURI é utilizada por marketplace como OpenSea
     */
    function contractURI() external view returns (string memory) {
        return super.uri(0);
    }

    /*
     * Substituição(override) é necessária neste caso porque ERC1155 e ERC1155Supply definem esta função.
     */
    function _update(
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory values
    ) internal virtual override(ERC1155, ERC1155Supply) {
        super._update(from, to, ids, values);
    }
}
