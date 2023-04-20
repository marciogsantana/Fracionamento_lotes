# Desafio fracionamento de lotes
[![NPM](https://img.shields.io/npm/l/react)](https://github.com/marciogsantana/Fracionamento_lotes/blob/main/LICENCE) 

# Sobre o desafio

### Criar um smart contract para tokenizar terrenos, e transferir a posse deles.
Requisitos
- Existirão 3 tipos de usuários neste smart contract
- O owner -  carteira que criou o contrato
- As AAs (autoridades arrendadoras) (ex: cartório de registro de imóveis, que faz o primeiro registro do terreno)
- Populares (pessoas ou empresas detentoras de terrenos)
- Somente o Owner pode conceder permissão para uma carteira ser conhecida como AA,
- Somente uma AA pode mintar um NFT de terreno, e este terreno inicialmente é de posse da AA
- As AAs podem fracionar um NFT de um lote e transferi-los entre os Populares, mas esse NFT tem que se relacionar ao NFT de origem, mantendo assim o rastreio de onde ele foi fracionado, a partir daí o NFT do terreno INTEIRO, não pode mais ser transacionado, somente suas frações
- Um NFT que já esteja na posse de um Popular, pode ser fracionado por uma AA mediante uma autorização do Popular
- Os metadados aqui não são importantes, mas sim como todo ecossistema, de transação, permissão e fracionamento se comporta
- O projeto deve ter testes unitários que garantam os cenários acima
Bonus: De uma solução para herança, no caso de falecimento de um proprietário, como este imóvel poderia ser transferido para os herdeiros.

 De acordo com as minhas pesquisas, era possível fazer esta implementação usando dois contratos ERC721 e ERC20, entretanto, achei confuso o rastreamento dos tokens, por isso resolvi usar o ERC1155, já que é um protocolo mais moderno e já tem nativo a função de fracionar NFT.

 O objetivo foi montar o ecossistema, ignorando por hora os metadados e conexão com front. Por isso o contrato foi escrito usando Solidity e plataforma Remix, por ser mais rápida e prática, principalmente porque foi necessário a constante trocas de carteiras, para os testes unitários, foi usado Hardhat e JS. Sobre os testes unitários, faço uma ressalva, não foi possível implementar todos em função do tempo.  

### Diagrama UML do contrato
## todas as funcionalidades foram testadas e estão operacionais 
![Uml](https://github.com/marciogsantana/imagens/blob/main/Use%20Case%20Model_%20Bulletin%20Board%20System%20(1).png) 

# Tecnologias utilizadas
- Solidity
- Remix
- Hardhat
- JS


# Autor

Márcio Gomes de Santana

https://www.linkedin.com/in/marcio-gomes-de-santana-05347198/
