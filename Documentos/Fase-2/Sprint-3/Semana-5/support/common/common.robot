*** Settings ***
Library    OperatingSystem
Library    Collections
Library    RequestsLibrary
Library    String

Resource   ../data/data_factory.robot

*** Keywords ***
# ==========================================
# SESSÃO E LOGIN (CORE)
# ==========================================
Criar Sessao API
    Create Session    serverest    ${BASE_URL}    disable_warnings=True

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
    [Documentation]    Garante que ${TOKEN} está válido na suíte. Cria um novo usuário admin e autentica.
    ${status}=    Run Keyword And Return Status    Variable Should Exist    ${TOKEN}
    IF    not ${status} or '${TOKEN}' == '${EMPTY}'
        ${user}=          Gerar Dados de Usuario Completo
        ${resp_user}=     POST Endpoint    /usuarios    ${user}
        Should Be Equal As Integers    ${resp_user.status_code}    201
        Set Suite Variable    ${ID_USUARIO_SUITE}    ${resp_user.json()['_id']}
        ${token_novo}=    Fazer Login e Obter Token    ${user}
        Set Suite Variable    ${TOKEN}    ${token_novo}
    END

Limpar Usuario Suite
    [Documentation]    Remove o usuário admin criado pelo Suite Setup. Seguro se o ID não existir.
    ${id}=    Get Variable Value    ${ID_USUARIO_SUITE}    ${None}
    IF    $id is not None
        DELETE Endpoint    /usuarios/${id}
    END

Criar Header Autorizado
    [Arguments]    ${token_custom}=${EMPTY}
    IF    '${token_custom}' == '${EMPTY}'
        Garantir Token Valido
        ${headers}=    Create Dictionary    Authorization=${TOKEN}
    ELSE
        ${headers}=    Create Dictionary    Authorization=${token_custom}
    END
    RETURN    ${headers}

# ==========================================
# MÉTODOS HTTP
# ==========================================
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

# ==========================================
# UTILITÁRIOS E VALIDAÇÕES
# ==========================================
Validar Status Code
    [Arguments]    ${response}    ${status_code}
    Should Be True    ${response.status_code} == ${status_code}

Verificar Status e Reportar Falha
    [Arguments]    ${response}    ${status_esperado}    ${mensagem_customizada}
    IF    ${response.status_code} != ${status_esperado}
        Fail    ${mensagem_customizada} (Status recebido: ${response.status_code})
    END

Validar Chaves do JSON
    [Arguments]    ${json}    @{campos}
    FOR    ${campo}    IN    @{campos}
        Dictionary Should Contain Key    ${json}    ${campo}
    END