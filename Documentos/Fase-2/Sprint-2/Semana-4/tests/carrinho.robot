*** Settings ***
Documentation     Endpoint /carrinhos
Resource          ../resources/base_api.resource
Resource          ../resources/carrinho.resource
Resource          ../resources/produtos.resource
Suite Setup       Criar Sessao API

*** Test Cases ***
Cenário 01: Criar carrinho com sucesso
    Limpar Carrinho
    ${prod}=           Gerar Dados de Produto Realista
    ${resp_p}=         Criar Produto    ${prod}
    ${id_p}=           Set Variable    ${resp_p.json()['_id']}
    ${body}=           Criar Body Carrinho    ${id_p}
    ${response}=       Criar Carrinho    ${body}
    Should Be Equal As Integers    ${response.status_code}    201

Cenário 02: Impedir mais de um carrinho
    Limpar Carrinho
    ${prod}=           Gerar Dados de Produto Realista
    ${resp_p}=         Criar Produto    ${prod}
    ${id_p}=           Set Variable    ${resp_p.json()['_id']}
    ${body}=           Criar Body Carrinho    ${id_p}
    Criar Carrinho     ${body}
    ${response}=       Criar Carrinho    ${body}
    Should Be Equal As Integers    ${response.status_code}    400

Cenário de Regressão: Estoque insuficiente
    Limpar Carrinho
    ${prod}=           Gerar Dados de Produto Realista    quantidade=5
    ${resp_p}=         Criar Produto    ${prod}
    ${id_p}=           Set Variable    ${resp_p.json()['_id']}
    ${item}=           Create Dictionary    idProduto=${id_p}    quantidade=6
    ${lista}=          Create List    ${item}
    ${body}=           Create Dictionary    produtos=${lista}
    ${response}=       Criar Carrinho    ${body}
    Verificar Status e Reportar Falha    ${response}    400    Vendeu acima do estoque.

Cenário de Regressão: Concluir compra sem carrinho
    Limpar Carrinho
    ${headers}=        Criar Header Autorizado
    ${response}=       DELETE Endpoint    /carrinhos/concluir-compra    ${headers}
    Verificar Status e Reportar Falha    ${response}    400    Concluiu sem carrinho.