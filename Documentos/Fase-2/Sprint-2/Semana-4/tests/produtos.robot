*** Settings ***
Documentation     Suíte de testes para o endpoint /produtos.
Resource          ../resources/base_api.resource
Resource          ../resources/produtos.resource
Resource          ../resources/usuarios.resource
Suite Setup       Criar Sessao API

*** Test Cases ***
Cenário 01: Cadastrar produto com sucesso como Admin (CT14)
    [Tags]             positivo    admin
    ${produto}=        Gerar Dados de Produto Realista
    ${response}=       Criar Produto    ${produto}
    
    Should Be Equal As Integers    ${response.status_code}    201
    Validar Chaves do JSON         ${response.json()}    _id

Cenário 02: Bloquear cadastro de produto por usuário comum (CT30)
    [Tags]             negativo    permissao
    ${user_comum}=     Gerar Dados de Usuario Completo
    Set To Dictionary  ${user_comum}    administrador=false
    Criar Usuario      ${user_comum}
    ${token_comum}=    Fazer Login e Obter Token    ${user_comum}
    
    ${produto}=        Gerar Dados de Produto Realista
    ${headers}=        Criar Header Autorizado    ${token_comum}
    ${response}=       POST Endpoint    /produtos    ${produto}    ${headers}
    
    Should Be Equal As Integers    ${response.status_code}    403
    Should Be Equal As Strings     ${response.json()['message']}    Rota exclusiva para administradores

Cenário 03: Impedir cadastro de produto com nome já existente (CT28)
    [Tags]             negativo    regra_negocio
    ${produto}=        Gerar Dados de Produto Realista
    Criar Produto      ${produto}
    ${response}=       Criar Produto    ${produto}
    
    Should Be Equal As Integers    ${response.status_code}    400
    Should Be Equal As Strings     ${response.json()['message']}    Já existe produto com esse nome

Cenário de Regressão: Validar erro ao cadastrar produto com nome vazio
    [Tags]             regressao    validacao
    ${produto}=        Gerar Dados de Produto Realista
    Set To Dictionary  ${produto}    nome=${EMPTY}
    ${response}=       Criar Produto    ${produto}
    
    Verificar Status e Reportar Falha    ${response}    400    A API aceitou o cadastro de um produto com nome vazio.

Cenário de Regressão: Cadastrar produto com preço negativo
    [Tags]             regressao    integridade
    ${produto}=        Gerar Dados de Produto Realista
    Set To Dictionary  ${produto}    preco=-50
    ${response}=       Criar Produto    ${produto}
    
    Verificar Status e Reportar Falha    ${response}    400    A API aceitou o cadastro de um produto com preço negativo.

Cenário de Limite: Cadastrar produto com descrição excessiva
    [Tags]             negativo    estresse
    ${produto}=        Gerar Produto Com Descricao Excedente
    ${response}=       Criar Produto    ${produto}
    
    Should Be True    ${response.status_code} < 500    msg=BUG: O servidor retornou erro 500 ao receber descricao muito longa.