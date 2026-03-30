*** Settings ***
Documentation     Suíte de testes para o endpoint /produtos usando arquitetura Master File.
Resource          ../support/variables/base.robot
Resource          ../keywords/produtos.resource
Resource          ../keywords/usuarios.resource

Suite Setup       Criar Sessao API
Suite Teardown    Limpar Usuario Suite
Test Teardown     Limpar Produto Criado

*** Test Cases ***
Cenário 01: Cadastrar produto com sucesso como Admin (CT14)
    [Tags]             positivo    admin
    ${produto}=        Gerar Dados de Produto Realista
    ${response}=       Criar Produto    ${produto}
    Validar Status Code    ${response}    201
    Set Test Variable  ${ID_PRODUTO_CRIADO}    ${response.json()['_id']}
    Validar Chaves do JSON    ${response.json()}    _id

Cenário 02: Bloquear cadastro de produto por usuário comum (CT30)
    [Tags]             negativo    permissao
    ${user_comum}=     Gerar Dados de Usuario Completo
    Set To Dictionary  ${user_comum}    administrador=false
    Criar Usuario      ${user_comum}
    ${token_comum}=    Fazer Login e Obter Token    ${user_comum}
    
    ${produto}=        Gerar Dados de Produto Realista
    ${headers}=        Criar Header Autorizado    ${token_comum}
    ${response}=       POST Endpoint    /produtos    ${produto}    ${headers}
    
    Validar Status Code    ${response}    403
    Should Be Equal As Strings     ${response.json()['message']}    Rota exclusiva para administradores

Cenário 03: Impedir cadastro de produto com nome já existente (CT28)
    [Tags]             negativo    regra_negocio
    ${produto}=        Gerar Dados de Produto Realista
    Criar Produto      ${produto}
    ${response}=       Criar Produto    ${produto}
    
    Validar Status Code    ${response}    400
    Should Be Equal As Strings     ${response.json()['message']}    Já existe produto com esse nome

Cenário de Regressão: Validar erro ao cadastrar produto com nome vazio
    [Tags]             regressao    validacao
    ${produto}=        Gerar Dados de Produto Realista
    Set To Dictionary  ${produto}    nome=${EMPTY}
    ${response}=       Criar Produto    ${produto}
    
    # Mantive a sua keyword de reporte customizado que é excelente para o relatório
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
    
    # Validação de segurança para garantir que a API não "quebre" (500)
    Should Be True    ${response.status_code} < 500    msg=BUG: O servidor retornou erro 500 ao receber descricao muito longa.