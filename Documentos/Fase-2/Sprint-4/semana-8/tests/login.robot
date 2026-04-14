*** Settings ***
Documentation     Testes de Login
Resource          ../resources/base_api.resource
Resource          ../resources/usuarios.resource
Suite Setup       Criar Sessao API

*** Test Cases ***
Cenário 01: Login realizado com sucesso
    ${user}=           Gerar Dados de Usuario Completo
    Criar Usuario      ${user}
    ${response}=       Fazer Login Request    ${user}
    Should Be Equal As Integers    ${response.status_code}    200
    Dictionary Should Contain Key  ${response.json()}    authorization

Cenário 02: Login com senha inválida
    ${user}=           Gerar Dados de Usuario Completo
    Criar Usuario      ${user}
    ${body_errado}=    Create Dictionary    email=${user['email']}    password=erro123
    ${response}=       POST Endpoint    /login    ${body_errado}
    Should Be Equal As Integers    ${response.status_code}    401

Cenário 03: Login com e-mail não cadastrado
    ${user_fake}=      Gerar Dados de Usuario Completo
    ${response}=       Fazer Login Request    ${user_fake}
    Should Be Equal As Integers    ${response.status_code}    401

Cenário de Segurança: Acesso com Token Malformado
    ${headers}=        Create Dictionary    Authorization=Bearer token_fake_123
    ${response}=       GET Endpoint    /carrinhos    ${headers}
    Verificar Status e Reportar Falha    ${response}    401    A API não tratou token malformado.

Cenário 04: Não permitir login sem email
    ${body}=    Create Dictionary    password=123456
    ${response}=    POST Endpoint    /login    ${body}

    Should Be Equal As Integers    ${response.status_code}    400
    Validar Chaves do JSON    ${response.json()}    email

Cenário 05: Não permitir login com body vazio
    ${response}=    POST Endpoint    /login    ${{{}}}

    Should Be Equal As Integers    ${response.status_code}    400
    Validar Chaves do JSON    ${response.json()}    email    password

Cenário 06: Validar resposta de erro no login inválido
    ${user_fake}=    Gerar Dados de Usuario Completo

    ${response}=    Fazer Login Request    ${user_fake}

    Should Be Equal As Integers    ${response.status_code}    401
    Validar Chaves do JSON    ${response.json()}    message
    Should Not Be Empty    ${response.json()['message']}
    Dictionary Should Not Contain Key    ${response.json()}    authorization