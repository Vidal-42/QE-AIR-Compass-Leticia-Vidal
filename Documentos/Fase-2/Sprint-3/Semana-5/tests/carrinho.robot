*** Settings ***
Documentation     Endpoint /carrinhos (Arquitetura Refatorada com Master File)
# Importamos apenas o arquivo mestre de configurações e as keywords de negócio
Resource          ../support/variables/base.robot
Resource          ../keywords/carrinho.resource
Resource          ../keywords/produtos.resource

Suite Setup       Criar Sessao API
Suite Teardown    Limpar Usuario Suite
Test Teardown     Limpar Carrinho


*** Test Cases ***
Cenário 01: Criar carrinho com sucesso
    Limpar Carrinho
    ${prod}=           Gerar Dados de Produto Realista
    ${resp_p}=         Criar Produto    ${prod}
    ${id_p}=           Set Variable    ${resp_p.json()['_id']}
    ${body}=           Criar Body Carrinho    ${id_p}
    ${response}=       Criar Carrinho    ${body}
    # Usando a keyword sugerida pelo seu mentor
    Validar Status Code    ${response}    201

Cenário 02: Impedir mais de um carrinho
    Limpar Carrinho
    ${prod}=           Gerar Dados de Produto Realista
    ${resp_p}=         Criar Produto    ${prod}
    ${id_p}=           Set Variable    ${resp_p.json()['_id']}
    ${body}=           Criar Body Carrinho    ${id_p}
    Criar Carrinho     ${body}
    ${response}=       Criar Carrinho    ${body}
    Validar Status Code    ${response}    400

Cenário de Regressão: Estoque insuficiente
    Limpar Carrinho
    ${prod}=           Gerar Dados de Produto Realista    quantidade=5
    ${resp_p}=         Criar Produto    ${prod}
    ${id_p}=           Set Variable    ${resp_p.json()['_id']}
    ${item}=           Create Dictionary    idProduto=${id_p}    quantidade=6
    ${lista}=          Create List    ${item}
    ${body}=           Create Dictionary    produtos=${lista}
    ${response}=       Criar Carrinho    ${body}
    # Substituímos a lógica antiga pela centralizada do mentor
    Validar Status Code    ${response}    400

Cenário de Regressão: Concluir compra sem carrinho
    Limpar Carrinho
    ${headers}=        Criar Header Autorizado
    ${response}=       DELETE Endpoint    /carrinhos/concluir-compra    ${headers}
    Validar Status Code    ${response}    400