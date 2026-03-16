*** Settings ***
Library    String

*** Keywords ***
Analisar lista de números de forma inteligente
    [Arguments]    ${lista_numeros}
    FOR    ${num}    IN    @{lista_numeros}
        IF    ${num} == 5 or ${num} == 10
            Log To Console    Alvo encontrado: Eu sou o número ${num}!
        ELSE
            Log To Console    O número ${num} não é 5 nem 10.
        END
    END

Gerar email dinâmico
    [Arguments]    ${nome}    ${sobrenome}
    ${aleatorio}    Generate Random String    4    chars=[LETTERS]
    ${email}        Set Variable    ${nome}_${sobrenome}_${aleatorio}@automacao.com
    RETURN          ${email}