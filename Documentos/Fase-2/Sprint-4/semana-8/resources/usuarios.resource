*** Settings ***
Resource    base_api.resource

*** Variables ***
${ID_USUARIO_CRIADO}    ${EMPTY}

*** Keywords ***
Criar Usuario
    [Arguments]    ${usuario}
    ${response}=    POST Endpoint    /usuarios    ${usuario}
    RETURN    ${response}

Deletar Usuario
    [Arguments]    ${id}
    ${response}=    DELETE Endpoint    /usuarios/${id}
    RETURN    ${response}

Limpar Usuario Criado
    Run Keyword If    '${ID_USUARIO_CRIADO}' != '${EMPTY}'    Deletar Usuario    ${ID_USUARIO_CRIADO}

Validar Resposta 201 E Registrar ID
    [Arguments]    ${response}
    Should Be Equal As Integers    ${response.status_code}    201
    Validar Chaves do JSON         ${response.json()}    _id    message
    ${id}=    Get From Dictionary  ${response.json()}    _id
    Should Not Be Empty            ${id}
    Set Test Variable              ${ID_USUARIO_CRIADO}    ${id}

Validar Resposta 400 Com Campos
    [Arguments]    ${response}    @{campos}
    Should Be Equal As Integers    ${response.status_code}    400
    Validar Chaves do JSON         ${response.json()}    @{campos}

Criar Usuario E Validar Sucesso
    [Arguments]    ${usuario}
    ${response}=    Criar Usuario    ${usuario}
    Validar Resposta 201 E Registrar ID    ${response}
    RETURN    ${response}