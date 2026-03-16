*** Settings ***
Documentation    Desafio 01: Percorrer e exibir meses do ano.

*** Variables ***
@{MESES}    Janeiro  Fevereiro  Março  Abril  Maio  Junho  Julho  Agosto  Setembro  Outubro  Novembro  Dezembro

*** Test Cases ***
Cenário: Listar todos os meses do ano
    Log To Console    ${\n}--- Calendário ---
    FOR    ${mes}    IN    @{MESES}
        Log To Console    Mês: ${mes}
    END