*** Settings ***
Documentation       Framework de Automação para a API ServeRest.
...                 Este arquivo centraliza bibliotecas, variáveis globais e recursos de suporte.

### Libraries 
Library             RequestsLibrary
Library             Collections
Library             FakerLibrary    locale=pt_BR
Library             String
Library             OperatingSystem

### Recursos de Configuração e Dados 
Resource            serverest_variables.robot
Resource            ../common/common.robot
Resource            ../data/data_factory.robot

### Keywords de Negócio (Resources)
# Importando as keywords refatoradas para ficarem disponíveis em toda a suíte
Resource            ../../keywords/usuarios.resource
Resource            ../../keywords/produtos.resource
Resource            ../../keywords/carrinho.resource