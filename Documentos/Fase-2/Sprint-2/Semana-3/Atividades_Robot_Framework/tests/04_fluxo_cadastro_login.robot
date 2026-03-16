*** Settings ***
Resource         ../resources/common.resource
Resource         ../resources/api_usuarios.resource
Suite Setup      Conectar na API

*** Test Cases ***
Cenário: Cadastrar usuário e validar acesso
    ${EMAIL}    Set Variable    leticia_vidal_test@automacao.com
    
    # Passo 1: Cadastro
    Cadastrar um novo usuário    Leticia Vidal    ${EMAIL}    123456    true    201
    
    # Passo 2: Login
    ${RESPOSTA}    Realizar login com sucesso    ${EMAIL}    123456
    
    # Validação
    Dictionary Should Contain Key    ${RESPOSTA}    authorization
    Log To Console    ${\n}Login realizado com sucesso!