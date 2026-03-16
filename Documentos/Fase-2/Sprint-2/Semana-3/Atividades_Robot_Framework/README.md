# Projeto de Automação Robot Framework - Sprint-2

- Este projeto contém a resolução de 5 desafios de automação de testes propostos no Curso de Automação de Testes com Robot Framework da Udemy, focados em lógica de programação com Robot Framework e testes de API REST, desenvolvidos durante a Semana 3 da Sprint 2.

## Estrutura do Projeto

A estrutura de pastas foi organizada para separar a execução dos testes da lógica técnica:

- **tests/**: Arquivos .robot contendo os cenários de teste.
- **resources/**: Arquivos .resource contendo as keywords reutilizáveis e configurações de API.
- **results/**: Arquivos de log e relatórios gerados após a execução.

## Desafios Implementados

1. **01_lista_meses.robot**: Automação que percorre uma lista contendo os 12 meses do ano utilizando a estrutura de repetição FOR.
2. **02_dicionario_dias.robot**: Manipulação de variáveis do tipo dicionário para mapear e exibir os dias da semana.
3. **03_palavras_chave.robot**: Implementação de keywords customizadas com passagem de argumentos e retorno de valores.
4. **04_fluxo_cadastro_login.robot**: Automação de API utilizando a RequestsLibrary para realizar o fluxo de cadastro e login no ambiente ServeRest.
5. **05_percorrendo_listas.robot**: Aplicação de lógica condicional IF dentro de estruturas de repetição FOR para filtragem de dados.

## Bibliotecas Utilizadas

- RequestsLibrary
- Collections
- String

## Comandos de Execução

Para executar todos os testes e organizar os logs na pasta de resultados:

```bash
robot -d ./results tests/

Para executar um teste específico:

robot -d ./results tests/04_fluxo_cadastro_login.robot
