*** Settings ***
Documentation     Gestão de Usuários
Resource          ../resources/base_api.resource
Resource          ../resources/usuarios.resource
Suite Setup       Criar Sessao API
Test Teardown     Limpar Usuario Criado

*** Test Cases ***
Cenário 01: Cadastro de usuário comum com sucesso
    ${user}=    Gerar Dados de Usuario Completo
    Set To Dictionary    ${user}    administrador=false

    ${response}=    Criar Usuario E Validar Sucesso    ${user}

    Should Be Equal As Integers    ${response.status_code}    201

    Validar Chaves do JSON    ${response.json()}    _id    message

    ${body}=    Set Variable    ${response.json()}
    ${id}=      Get From Dictionary    ${body}    _id

    Should Not Be Empty    ${id}

    Set Test Variable    ${ID_USUARIO_CRIADO}    ${id}


Cenário 02: Impedir e-mail duplicado
    ${user}=    Gerar Dados de Usuario Completo
    Criar Usuario    ${user}

    ${response}=    Criar Usuario    ${user}

    Should Be Equal As Integers    ${response.status_code}    400


Cenário de Regressão: Validar IDOR na exclusão
    ${user_v}=    Gerar Dados de Usuario Completo
    ${resp_v}=    Criar Usuario    ${user_v}
    ${id_v}=      Set Variable    ${resp_v.json()['_id']}

    ${user_a}=    Gerar Dados de Usuario Completo
    Set To Dictionary    ${user_a}    administrador=false
    Criar Usuario    ${user_a}

    ${token_a}=    Fazer Login e Obter Token    ${user_a}
    ${headers}=    Criar Header Autorizado    ${token_a}

    ${response}=    DELETE Endpoint    /usuarios/${id_v}    ${headers}

    Verificar Status e Reportar Falha    ${response}    403    Falha de IDOR detectada.


Cenário 03: Cadastro de usuário não-administrador com validação de contrato e persistência
    [Documentation]    Valida criação de usuário comum: status 201, contrato do body (_id, message) e persistência via GET /usuarios/{_id}

    ${user}=    Gerar Dados de Usuario Completo
    Set To Dictionary    ${user}    administrador=false

    ${response}=    Criar Usuario    ${user}

    Should Be Equal As Integers    ${response.status_code}    201

    Validar Chaves do JSON    ${response.json()}    _id    message

    ${body}=    Set Variable    ${response.json()}
    ${id}=      Get From Dictionary    ${body}    _id

    Should Not Be Empty    ${id}
    Should Not Be Empty    ${body["message"]}

    Set Test Variable    ${ID_USUARIO_CRIADO}    ${id}

    ${get_response}=    GET Endpoint    /usuarios/${ID_USUARIO_CRIADO}

    Should Be Equal As Integers    ${get_response.status_code}    200

    ${get_body}=    Set Variable    ${get_response.json()}

    Should Be Equal    ${get_body["email"]}    ${user["email"]}
    Should Be Equal    ${get_body["nome"]}     ${user["nome"]}
    Should Be Equal    ${get_body["administrador"]}    false


Cenário 04: Cadastro de usuário administrador com sucesso
    ${user}=    Gerar Dados de Usuario Completo
    Set To Dictionary    ${user}    administrador=true

    ${response}=    Criar Usuario    ${user}

    Should Be Equal As Integers    ${response.status_code}    201

    Validar Chaves do JSON    ${response.json()}    _id    message

    ${id}=    Get From Dictionary    ${response.json()}    _id
    Should Not Be Empty    ${id}

    Set Test Variable    ${ID_USUARIO_CRIADO}    ${id}


Cenário 05: Permitir usuários com mesmo nome
    ${user1}=    Gerar Dados de Usuario Completo
    ${user2}=    Gerar Dados de Usuario Completo

    Set To Dictionary    ${user2}    nome=${user1["nome"]}

    ${resp1}=    Criar Usuario    ${user1}
    Should Be Equal As Integers    ${resp1.status_code}    201

    ${resp2}=    Criar Usuario    ${user2}
    Should Be Equal As Integers    ${resp2.status_code}    201

    ${id}=    Get From Dictionary    ${resp2.json()}    _id
    Set Test Variable    ${ID_USUARIO_CRIADO}    ${id}


Cenário 06: Não permitir cadastro sem nome
    ${user}=    Gerar Dados de Usuario Completo
    Remove From Dictionary    ${user}    nome

    ${response}=    Criar Usuario    ${user}

    Should Be Equal As Integers    ${response.status_code}    400

    Validar Resposta 400 Com Campos    ${response}    nome


Cenário 07: Não permitir cadastro sem email
    ${user}=    Gerar Dados de Usuario Completo
    Remove From Dictionary    ${user}    email

    ${response}=    Criar Usuario    ${user}

    Should Be Equal As Integers    ${response.status_code}    400

    Validar Chaves do JSON    ${response.json()}    email


Cenário 08: Não permitir cadastro sem password
    ${user}=    Gerar Dados de Usuario Completo
    Remove From Dictionary    ${user}    password

    ${response}=    Criar Usuario    ${user}

    Should Be Equal As Integers    ${response.status_code}    400

    Validar Chaves do JSON    ${response.json()}    password


Cenário 09: Não permitir email inválido
    ${user}=    Gerar Dados de Usuario Completo
    Set To Dictionary    ${user}    email=email_invalido

    ${response}=    Criar Usuario    ${user}

    Should Be Equal As Integers    ${response.status_code}    400

    Validar Chaves do JSON    ${response.json()}    email


Cenário 10: Validar estrutura de erro no cadastro inválido
    ${user}=    Create Dictionary

    ${response}=    Criar Usuario    ${user}

    Should Be Equal As Integers    ${response.status_code}    400

    ${body}=    Set Variable    ${response.json()}

    Validar Chaves do JSON    ${body}    nome    email    password