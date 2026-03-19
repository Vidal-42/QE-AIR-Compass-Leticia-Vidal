*** Settings ***
Resource    base_api.resource

*** Keywords ***
Criar Produto
    [Arguments]    ${produto}
    ${headers}=     Criar Header Autorizado
    ${response}=    POST Endpoint    /produtos    ${produto}    ${headers}
    RETURN    ${response}