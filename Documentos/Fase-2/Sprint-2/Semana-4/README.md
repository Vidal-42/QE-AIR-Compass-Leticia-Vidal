# *Sprint 2* - Engenharia de Qualidade
# *Automação de Testes REST*: API ServeRest com Robot Framework

## Contexto do Projeto
Este repositório contém a infraestrutura de testes automatizados desenvolvida para a API ServeRest durante o programa de bolsas da AI/R Compass UOL. O foco da implementação foi substituir validações manuais por scripts robustos que cobrem desde o comportamento básico dos endpoints até cenários complexos de segurança e lógica de negócio.

## Escopo e Entregáveis
### A suíte foi projetada para garantir que as operações de Cadastro, Login, Gestão de Produtos e Fluxo de Carrinho operem conforme o esperado. Os principais objetivos práticos são:

- *Validação de Regras de Negócio*: Testes que impedem, por exemplo, o cadastro de e-mails duplicados ou a criação de produtos com nomes já existentes no catálogo.

- *Cobertura de Regressão*: Scripts específicos para monitorar bugs críticos identificados anteriormente, como a aceitação indevida de nomes vazios em produtos e falhas de segurança (IDOR) onde a API permitia a manipulação de recursos entre usuários distintos.

- *Verificação de Contrato*: Checkpoints automáticos para assegurar que o esquema JSON retornado pela API contenha todas as chaves obrigatórias.

## Organização do Framework
## O projeto utiliza uma arquitetura modular para separar a intenção do teste da complexidade técnica de cada requisição. A estrutura está dividida da seguinte forma:

Plaintext
Challenge_03/
  ├── results/              # Relatórios de execução, logs e evidências em HTML
  ├── resources/            # Camada de keywords estruturais e lógica de suporte
  │     ├── api.resource           # Centraliza a criação de sessões e métodos HTTP (POST, DELETE, etc.)
  │     ├── auth.resource          # Lógica de obtenção e persistência do Token Bearer
  │     ├── usuarios.resource      # Encapsula as chamadas aos endpoints de /usuarios
  │     ├── produtos.resource      # Encapsula as chamadas aos endpoints de /produtos
  │     ├── carrinho.resource      # Gerencia o ciclo de vida do carrinho (adição e checkout)
  │     ├── data_factory.resource  # Gerador de massa dinâmica (nomes, e-mails e IDs aleatórios)
  │     └── common.resource        # Validações transversais e limpeza de massa (Teardowns)
  ├── tests/                # Casos de teste declarativos (focados em comportamento)
  │     ├── login.robot            # Testes de autenticação positiva e negativa
  │     ├── usuarios.robot         # Fluxos de CRUD e validação de duplicidade
  │     ├── produtos.robot         # Gestão de inventário e permissões de Admin
  │     └── carrinho.robot         # Fluxos de compra end-to-end
  ├── .gitignore            # Filtro para não versionar logs locais e ambientes virtuais
  ├── README.md             # Guia técnico do projeto
  └── requirements.txt      # Bibliotecas Python necessárias para rodar o projeto
Decisões Técnicas e Implementação
Robot Framework & Libraries: Utilização da RequestsLibrary para o handshake com a API, além de Collections e String para manipular os dicionários de resposta e formatar strings dinâmicas.

Massa de Dados Idempotente: O arquivo data_factory.resource utiliza variáveis de tempo e strings randômicas para que cada execução gere um novo usuário/produto, evitando que o teste falhe por dados já existentes no banco.

Abstração por Keywords: Os arquivos na pasta tests/ não contêm URLs ou payloads brutos. Toda a lógica de montagem do JSON e headers está isolada nos resources, facilitando a manutenção caso a API sofra alterações estruturais.

Segurança Ativa: Implementação de verificações de status code 403 (Forbidden) em cenários onde usuários sem privilégios tentam acessar rotas administrativas ou recursos de terceiros.

Setup e Configuração Local
Para preparar o ambiente e rodar os scripts, siga os comandos:

Clonagem do Repositório:

Bash
git clone git@github.com:seu-usuario/qa-air-compass-uol.git
cd qa-air-compass-uol/Documentos/Fase_02/Sprint_02/Semana_04/Challenge_3
Instalação dos Pacotes:

Bash
pip install -r requirements.txt
Execução dos Testes
A suíte permite execuções totais ou direcionadas através de seletores nativos do Robot.

Rodar todos os cenários:

Bash
robot -d ./results tests/
Rodar apenas validações de bugs (Regressão):

Bash
robot -d ./results -i regressao tests/
Análise de Evidências
O Robot Framework gera logs visuais que podem ser consultados na pasta ./results:

log.html: Exibe o passo a passo de cada teste, incluindo o payload enviado e o corpo da resposta recebida da API ServeRest. Essencial para depuração técnica.

report.html: Fornece um dashboard resumido com a taxa de sucesso da execução e o tempo gasto em cada suíte.

Para visualizar, basta abrir qualquer um dos arquivos .html no seu navegador.