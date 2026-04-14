*** Settings ***
Library    FakerLibrary    locale=pt_BR
Library    String

*** Keywords ***
Gerar Dados de Usuario Completo
    ${nome}     FakerLibrary.Name
    ${email}    FakerLibrary.Free Email
    ${senha}    FakerLibrary.Password    length=8
    &{usuario}  Create Dictionary    nome=${nome}    email=${email}    password=${senha}    administrador=true
    RETURN      &{usuario}

Gerar Dados de Produto Realista
    [Arguments]        ${quantidade}=100
    ${nome_p}          FakerLibrary.Word
    ${preco}           FakerLibrary.Random Int    min=10    max=5000
    ${desc}            FakerLibrary.Sentence
    &{produto}         Create Dictionary    nome=Prod ${nome_p} ${preco}    preco=${preco}    descricao=${desc}    quantidade=${quantidade}
    RETURN             &{produto}

Gerar Produto Com Descricao Excedente
    ${desc_longa}      Generate Random String    5001
    ${produto}=        Gerar Dados de Produto Realista
    Set To Dictionary  ${produto}    descricao=${desc_longa}
    RETURN             ${produto}