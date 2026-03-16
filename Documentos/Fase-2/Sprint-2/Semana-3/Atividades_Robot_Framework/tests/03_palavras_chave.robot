*** Settings ***
Resource         ../resources/logica_utils.resource

*** Test Cases ***
Cenário: Criar email de usuário para teste
    ${EMAIL_GERADO}    Gerar email dinâmico    Leticia    Vidal
    Log To Console    ${\n}Email gerado para o portfólio: ${EMAIL_GERADO}