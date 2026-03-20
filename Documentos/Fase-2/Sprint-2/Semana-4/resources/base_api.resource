*** Settings ***
Documentation     Camada base da automação: HTTP + Auth + Utils
Library           RequestsLibrary
Library           Collections
Resource          data_factory.resource

*** Variables ***
${BASE_URL}       https://serverest.dev
${TOKEN}          ${EMPTY}

*** Keywords ***
Criar Sessao API
    Create Session    serverest    ${BASE_URL}    disable_warnings=True

# =========================
# HTTP (CORE)
# =========================
POST Endpoint
    [Arguments]    ${endpoint}    ${body}=${EMPTY}    ${headers}=${EMPTY}
    ${response}=    POST On Session    serverest    ${endpoint}    json=${body}    headers=${headers}    expected_status=any
    RETURN    ${response}

GET Endpoint
    [Arguments]    ${endpoint}    ${headers}=${EMPTY}
    ${response}=    GET On Session    serverest    ${endpoint}    headers=${headers}    expected_status=any
    RETURN    ${response}

DELETE Endpoint
    [Arguments]    ${endpoint}    ${headers}=${EMPTY}
    ${response}=    DELETE On Session    serverest    ${endpoint}    headers=${headers}    expected_status=any
    RETURN    ${response}

# =========================
# AUTH
# =========================
Fazer Login Request
    [Arguments]    ${usuario}
    ${payload}=    Create Dictionary    email=${usuario['email']}    password=${usuario['password']}
    ${response}=    POST Endpoint    /login    ${payload}
    RETURN    ${response}

Fazer Login e Obter Token
    [Arguments]    ${usuario}
    ${response}=    Fazer Login Request    ${usuario}
    Should Be Equal As Integers    ${response.status_code}    200
    ${token}=    Set Variable    ${response.json()['authorization']}
    RETURN    ${token}

Garantir Token Valido
    Run Keyword If    '${TOKEN}' == ''    Fazer Novo Login Admin

Fazer Novo Login Admin
    ${user}=    Gerar Dados de Usuario Completo
    POST Endpoint    /usuarios    ${user}
    ${token}=    Fazer Login e Obter Token    ${user}
    Set Suite Variable    ${TOKEN}    ${token}

Criar Header Autorizado
    [Arguments]    ${token_custom}=${EMPTY}
    IF    '${token_custom}' == '${EMPTY}'
        Garantir Token Valido
        ${headers}=    Create Dictionary    Authorization=${TOKEN}
    ELSE
        ${headers}=    Create Dictionary    Authorization=${token_custom}
    END
    RETURN    ${headers}

# =========================
# UTILS
# =========================
Validar Chaves do JSON
    [Arguments]    ${json}    @{campos}
    FOR    ${campo}    IN    @{campos}
        Dictionary Should Contain Key    ${json}    ${campo}
    END

Verificar Status e Reportar Falha
    [Arguments]    ${response}    ${status_esperado}    ${mensagem_customizada}
    ${status_atual}=    Convert To Integer    ${response.status_code}
    ${esperado}=       Convert To Integer    ${status_esperado}
    Should Be Equal    ${status_atual}    ${esperado}    msg=BUG DETECTADO: ${mensagem_customizada} (Status: ${status_atual})