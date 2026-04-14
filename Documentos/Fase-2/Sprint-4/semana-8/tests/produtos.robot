*** Settings ***
Documentation     Suíte de testes para o endpoint /produtos (Refatorado nível prova)
Resource          ../resources/base_api.resource
Resource          ../resources/produtos.resource
Resource          ../resources/usuarios.resource
Suite Setup       Criar Sessao API
Test Teardown     Limpar Usuario Criado

*** Test Cases ***

Cenário 01: Cadastrar produto com sucesso como Admin (CT14)
    [Tags]    positivo    admin    contrato

    ${produto}=    Gerar Dados de Produto Realista
    ${response}=   Criar Produto    ${produto}

    Validar Resposta 201 Produto    ${response}

    ${ID_PRODUTO}=    Set Variable    ${response.json()['_id']}

    ${get_response}=    GET Endpoint    /produtos/${ID_PRODUTO}
    Should Be Equal As Integers    ${get_response.status_code}    200


Cenário 02: Bloquear cadastro de produto por usuário comum (CT30)
    [Tags]    negativo    permissao

    ${user}=    Gerar Dados de Usuario Completo
    Set To Dictionary    ${user}    administrador=false
    Criar Usuario E Validar Sucesso    ${user}

    ${token}=    Fazer Login e Obter Token    ${user}
    ${headers}=  Criar Header Autorizado      ${token}

    ${produto}=  Gerar Dados de Produto Realista
    ${response}= POST Endpoint    /produtos    ${produto}    ${headers}

    Validar Resposta 403 Produto    ${response}


Cenário 03: Impedir cadastro de produto com nome já existente (CT28)
    [Tags]    negativo    regra_negocio

    ${produto}=    Gerar Dados de Produto Realista
    Criar Produto E Validar Sucesso    ${produto}

    ${response}=   Criar Produto    ${produto}

    Validar Resposta 400 Produto    ${response}    message


Cenário 04: Não permitir cadastro sem nome
    [Tags]    negativo    contrato

    ${produto}=    Gerar Dados de Produto Realista
    Remove From Dictionary    ${produto}    nome

    ${response}=    Criar Produto    ${produto}

    Validar Resposta 400 Produto    ${response}    nome


Cenário 05: Não permitir preço negativo
    [Tags]    negativo    regra_negocio

    ${produto}=    Gerar Dados de Produto Realista
    Set To Dictionary    ${produto}    preco=-50

    ${response}=    Criar Produto    ${produto}

    Validar Resposta 400 Produto    ${response}    preco


Cenário 06: Não permitir payload vazio
    [Tags]    negativo    contrato

    ${response}=    Criar Produto    ${{{}}}

    Validar Resposta 400 Produto    ${response}    nome    preco    descricao    quantidade


Cenário 07: Validar limite de descrição longa
    [Tags]    negativo    estresse

    ${produto}=    Gerar Produto Com Descricao Excedente
    ${response}=   Criar Produto    ${produto}

    Should Be True    ${response.status_code} < 500