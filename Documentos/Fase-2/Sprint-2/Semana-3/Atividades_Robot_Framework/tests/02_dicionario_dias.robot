*** Settings ***
Documentation    Desafio 02: Dicionário de dias da semana.

*** Variables ***
&{DIAS_SEMANA}    seg=Segunda-feira  ter=Terça-feira  qua=Quarta-feira  qui=Quinta-feira  sex=Sexta-feira

*** Test Cases ***
Cenário: Exibir dias úteis do dicionário
    Log To Console    ${\n}--- Dias Úteis ---
    FOR    ${chave}    IN    @{DIAS_SEMANA.keys()}
        Log To Console    Abreviação: ${chave} -> Nome: ${DIAS_SEMANA["${chave}"]}
    END