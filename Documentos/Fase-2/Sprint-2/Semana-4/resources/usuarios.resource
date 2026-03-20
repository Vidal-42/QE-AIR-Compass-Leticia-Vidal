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