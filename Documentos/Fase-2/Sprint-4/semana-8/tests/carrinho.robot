*** Settings ***
Documentation     Suíte de Testes do Endpoint /carrinhos
Resource          ../resources/base_api.resource
Resource          ../resources/carrinho.resource
Resource          ../resources/produtos.resource
Resource          ../resources/usuarios.resource
Suite Setup       Criar Sessao API
Test Setup        Limpar Carrinho

*** Test Cases ***

# =========================
# POSITIVOS
# =========================

Cenário 01: Criar carrinho com sucesso
    [Tags]    positivo    contrato
    ${produto}=      Gerar Dados de Produto Realista
    ${resp_prod}=    Criar Produto    ${produto}
    ${produto_id}=   Set Variable     ${resp_prod.json()['_id']}
    
    ${body}=         Criar Body Carrinho    ${produto_id}
    Criar Carrinho E Validar Sucesso        ${body}

Cenário 02: Criar carrinho com múltiplos produtos
    [Tags]    positivo    regra_negocio
    ${p1}=    Gerar Dados de Produto Realista
    ${p2}=    Gerar Dados de Produto Realista
    ${r1}=    Criar Produto    ${p1}
    ${r2}=    Criar Produto    ${p2}
    ${id1}=   Set Variable    ${r1.json()['_id']}
    ${id2}=   Set Variable    ${r2.json()['_id']}

    ${item1}=    Create Dictionary    idProduto=${id1}    quantidade=1
    ${item2}=    Create Dictionary    idProduto=${id2}    quantidade=2
    ${lista}=    Create List          ${item1}    ${item2}
    ${body}=     Criar Body Carrinho Customizado    ${lista}
    Criar Carrinho E Validar Sucesso    ${body}

# =========================
# NEGATIVOS E REGRESSÃO
# =========================

Cenário 03: Não permitir criar carrinho sem autenticação
    [Tags]    negativo    seguranca
    ${body}=    Criar Body Carrinho    id_fake
    Criar Carrinho Sem Auth E Validar 401    ${body}

Cenário 05: Não permitir produto inexistente
    [Tags]    negativo    regra_negocio
    ${body}=    Criar Body Carrinho    id_inexistente
    Criar Carrinho E Validar Erro 400    ${body}

Cenário de Regressão: Estoque insuficiente
    [Tags]    regressao
    ${prod}=      Gerar Dados de Produto Realista    quantidade=5
    ${resp_p}=    Criar Produto    ${prod}
    ${id_p}=      Set Variable     ${resp_p.json()['_id']}
    
    ${body}=      Criar Body Carrinho    ${id_p}    6
    ${response}=  Criar Carrinho    ${body}
    Verificar Status e Reportar Falha    ${response}    400    Vendeu acima do estoque.

Cenário de Regressão: Concluir compra sem carrinho
    [Tags]    regressao
    ${headers}=   Criar Header Autorizado
    ${response}=  DELETE Endpoint    /carrinhos/concluir-compra    ${headers}
    Verificar Status e Reportar Falha    ${response}    400    Concluiu sem carrinho.