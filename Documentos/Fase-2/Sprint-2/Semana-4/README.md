# *Challenge 3* - Quality Engineering & AI — CompassUOL | Fase 2
# **Automação de Testes da API ServeRest**

## Objetivo do Projeto
Este repositório consolida a suíte de testes automatizados desenvolvida para a API ServeRest. O objetivo principal foi a transição do planejamento de testes exploratórios (SBTM) para uma estrutura de testes automatizados, para validar e analisar regras de negócio, fluxos positivos e nagtivos de Usuários, Login, Produtos e Carrinhos em diferentes casos de teste no ambiente.

Este projeto foca em cenários de exceção, segurança (IDOR) e persistência de dados, de forma que seja possível identificar bugs e inconsistências de forma adequada.

## Decisões Técnicas e Implementação
A arquitetura foi planejada para ser idempotente (pode ser executada várias vezes sem falhar por dados redundantes).

- **Robot Framework & RequestsLibrary**: Escolhidos pela clareza na escrita de testes (DSL) e gerenciamento de sessões HTTP.

- **Data Factory (Faker)**: Implementação de geração de massa dinâmica para e-mails e nomes reais, levando em consideração a simulação de um ecommerce na API e a maior variedade de dados, o que possibilita mais testes realistas.

- **Modularização (Resources)**: Separação entre a camada de teste (o que testar) e a camada de keywords (como testar), facilitando a manutenção de endpoints.

- **Tratamento de Bugs de Regressão**: Scripts configurados para expor falhas críticas de segurança, como a manipulação de tokens malformados e falhas de autorização entre usuários.

## Estrutura do Repositório
```
Semana-4/
├── resources/ # Camada de abstração (Keywords e Lógica)
│   ├── base_api.resource # Setup de sessão, Auth Admin e verbos HTTP
│   ├── usuarios.resource # Lógica específica do endpoint /usuarios
│   ├── produtos.resource # Regras de negócio e payloads de /produtos
│   └── carrinhos.resource # Fluxos de adição e checkout de /carrinhos
├── tests/ # Camada de execução (Cenários de Teste)
│   ├── login.robot # Autenticação e integridade de Token
│   ├── usuarios.robot # Gestão de contas e testes de IDOR
│   ├── produtos.robot # Inventário e controle de perfil Admin
│   └── carrinhos.robot # Regras de estoque e fluxo de compra
├── results/ # Artefatos gerados pós-execução (ignorados no Git)
├── .gitignore # Proteção contra versionamento de logs e venv
└── requirements.txt # Dependências do projeto (Robot, Requests, Faker)
```

### Guia de Configuração e Instalação

#### 1. Pré-requisitos
- Python 3.10 ou superior instalado.
- Git configurado.

#### 2. Clonagem e Acesso
```bash
git clone https://github.com/seu-usuario/QE-AIR-Compass-Leticia-Vidal.git
cd QE-AIR-Compass-Leticia-Vidal/Documentos/Fase-2/Sprint-2/Semana-4
```

## 3. Instalação de Dependências
Recomenda-se o uso de um ambiente virtual:

**Instalação direta das bibliotecas necessárias**
```bash
pip install robotframework robotframework-requests robotframework-faker
```

## Execução dos Testes
Para rodar a suíte completa e gerar os relatórios na pasta organizada:

```bash
robot -d ./results tests/
```

Para rodar apenas um módulo específico (ex: Login):
```bash
robot -d ./results tests/login.robot
```

## Visualização de Evidências

**Após o término dos testes, o framework gera automaticamente dois arquivos fundamentais na pasta /results:**

- log.html (Depuração Técnica): Permite inspecionar cada requisição enviada, o status code recebido e o corpo do JSON. É aqui que validamos os 3 bugs identificados (IDOR, Token e Carrinho).

- report.html (Visão Executiva): Dashboard com a taxa de sucesso e tempo de execução.

> [!NOTE]
> Sobre os resultados: Atualmente, a execução apresenta 14 PASS / 3 FAIL. As falhas são deliberadas e servem como evidência de bugs reais encontrados na API ServeRest, detalhados no relatório de Issues do projeto.
