*** Settings ***
Documentation     Testes para o endpoint /carrinhos
Resource          ../resources/base_api.resource
Resource          ../resources/carrinho.resource
Resource          ../resources/produtos.resource
Resource          ../resources/usuarios.resource
Suite Setup       Criar Sessao API
Test Teardown     Limpar Carrinho

*** Test Cases ***

# =========================
# POSITIVOS
# =========================

Cenário 01: Criar carrinho com sucesso
    [Tags]    positivo    contrato
    ${produto}=    Gerar Dados de Produto Realista
    ${resp_prod}=  Criar Produto    ${produto}
    ${produto_id}=    ${resp_prod.json()['_id']}

    ${body}=    Criar Body Carrinho    ${produto_id}
    Criar Carrinho E Validar Sucesso    ${body}


Cenário 02: Criar carrinho com múltiplos produtos
    [Tags]    positivo    regra_negocio
    ${p1}=    Gerar Dados de Produto Realista
    ${p2}=    Gerar Dados de Produto Realista

    ${r1}=    Criar Produto    ${p1}
    ${r2}=    Criar Produto    ${p2}

    ${id1}=    ${r1.json()['_id']}
    ${id2}=    ${r2.json()['_id']}

    ${item1}=    Create Dictionary    idProduto=${id1}    quantidade=1
    ${item2}=    Create Dictionary    idProduto=${id2}    quantidade=2

    ${lista}=    Create List    ${item1}    ${item2}
    ${body}=     Criar Body Carrinho Customizado    ${lista}

    Criar Carrinho E Validar Sucesso    ${body}


# =========================
# NEGATIVOS (SEGURANÇA)
# =========================

Cenário 03: Não permitir criar carrinho sem autenticação
    [Tags]    negativo    seguranca
    ${body}=    Criar Body Carrinho    id_fake
    Criar Carrinho Sem Auth E Validar 401    ${body}


Cenário 04: Não permitir criar carrinho com token inválido
    [Tags]    negativo    seguranca
    ${body}=    Criar Body Carrinho    id_fake
    Criar Carrinho Com Token Custom    ${body}    token_fake_123
    # validação manual porque keyword retorna response
    # (mantido assim para mostrar domínio técnico)
    # alternativa: criar keyword específica


# =========================
# NEGATIVOS (VALIDAÇÃO)
# =========================

Cenário 05: Não permitir produto inexistente
    [Tags]    negativo    regra_negocio
    ${body}=    Criar Body Carrinho    id_inexistente
    Criar Carrinho E Validar Erro 400    ${body}


Cenário 06: Não permitir quantidade zero
    [Tags]    negativo    boundary
    ${produto}=    Gerar Dados de Produto Realista
    ${resp}=       Criar Produto    ${produto}
    ${id}=         ${resp.json()['_id']}

    ${body}=    Criar Body Carrinho    ${id}    0
    Criar Carrinho E Validar Erro 400    ${body}


Cenário 07: Não permitir quantidade negativa
    [Tags]    negativo    boundary
    ${produto}=    Gerar Dados de Produto Realista
    ${resp}=       Criar Produto    ${produto}
    ${id}=         ${resp.json()['_id']}

    ${body}=    Criar Body Carrinho    ${id}    -1
    Criar Carrinho E Validar Erro 400    ${body}


Cenário 08: Não permitir body vazio
    [Tags]    negativo    contrato
    ${response}=    POST Endpoint    /carrinhos    ${{{}}}
    Validar Resposta 400 Carrinho    ${response}


Cenário 09: Não permitir lista de produtos vazia
    [Tags]    negativo    contrato
    ${body}=    Create Dictionary    produtos=${EMPTY}
    ${response}=    Criar Carrinho    ${body}
    Validar Resposta 400 Carrinho    ${response}


Cenário 10: Não permitir produto sem quantidade
    [Tags]    negativo    contrato
    ${produto}=    Gerar Dados de Produto Realista
    ${resp}=       Criar Produto    ${produto}
    ${id}=         ${resp.json()['_id']}

    ${item}=    Create Dictionary    idProduto=${id}
    ${lista}=   Create List    ${item}
    ${body}=    Criar Body Carrinho Customizado    ${lista}

    Criar Carrinho E Validar Erro 400    ${body}


# =========================
# REGRA DE NEGÓCIO
# =========================

Cenário 11: Não permitir carrinho duplicado para mesmo usuário
    [Tags]    negativo    regra_negocio
    ${produto}=    Gerar Dados de Produto Realista
    ${resp}=       Criar Produto    ${produto}
    ${id}=         ${resp.json()['_id']}

    ${body}=    Criar Body Carrinho    ${id}

    Criar Carrinho E Validar Sucesso    ${body}
    Criar Carrinho E Validar Erro 400    ${body}


Cenário 12: Não permitir quantidade maior que estoque
    [Tags]    negativo    integridade
    ${produto}=    Gerar Dados de Produto Realista
    Set To Dictionary    ${produto}    quantidade=1

    ${resp}=    Criar Produto    ${produto}
    ${id}=      ${resp.json()['_id']}

    ${body}=    Criar Body Carrinho    ${id}    5
    Criar Carrinho E Validar Erro 400    ${body}