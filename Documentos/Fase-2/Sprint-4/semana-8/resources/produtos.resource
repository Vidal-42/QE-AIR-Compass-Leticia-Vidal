*** Settings ***
Resource    base_api.resource

*** Keywords ***
Criar Produto
    [Arguments]    ${produto}
    ${headers}=     Criar Header Autorizado
    ${response}=    POST Endpoint    /produtos    ${produto}    ${headers}
    RETURN    ${response}

Validar Resposta 201 Produto
    [Arguments]    ${response}
    Should Be Equal As Integers    ${response.status_code}    201
    Validar Chaves do JSON         ${response.json()}    _id    message
    Should Not Be Empty            ${response.json()['_id']}
    Should Not Be Empty            ${response.json()['message']}


Validar Resposta 400 Produto
    [Arguments]    ${response}    @{campos}
    Should Be Equal As Integers    ${response.status_code}    400
    Validar Chaves do JSON         ${response.json()}    @{campos}


Validar Resposta 403 Produto
    [Arguments]    ${response}
    Should Be Equal As Integers    ${response.status_code}    403
    Validar Chaves do JSON         ${response.json()}    message
    Should Not Be Empty            ${response.json()['message']}


Criar Produto E Validar Sucesso
    [Arguments]    ${produto}
    ${response}=    Criar Produto    ${produto}
    Validar Resposta 201 Produto    ${response}
    RETURN    ${response}