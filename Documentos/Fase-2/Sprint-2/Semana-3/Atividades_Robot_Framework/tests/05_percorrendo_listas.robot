*** Settings ***
Resource         ../resources/logica_utils.resource

*** Variables ***
@{VALORES}    1  5  7  10  12

*** Test Cases ***
Cenário: Filtrar números específicos em uma lista
    Log To Console    ${\n}Iniciando filtro de valores...
    Analisar lista de números de forma inteligente    ${VALORES}