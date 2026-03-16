*** Settings ***
Resource    common.resource
Library     Collections

*** Keywords ***
Cadastrar um novo usuário
    [Arguments]    ${nome}    ${email}    ${password}    ${admin}    ${status_esperado}
    ${payload}     Create Dictionary    
    ...            nome=${nome}    
    ...            email=${email}    
    ...            password=${password}    
    ...            administrador=${admin}
    
    ${resposta}    POST On Session    alias=ServeRest    url=/usuarios    json=${payload}    expected_status=${status_esperado}
    RETURN         ${resposta}

Realizar login com sucesso
    [Arguments]    ${email}    ${password}
    ${payload}     Create Dictionary    email=${email}    password=${password}
    
    ${resposta}    POST On Session    alias=ServeRest    url=/login    json=${payload}    expected_status=200
    RETURN         ${resposta.json()}