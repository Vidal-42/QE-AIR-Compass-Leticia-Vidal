*** Settings ***
Resource    base_api.resource

*** Keywords ***
Criar Body Carrinho
    [Arguments]    ${produto_id}
    ${item}=       Create Dictionary    idProduto=${produto_id}    quantidade=1
    ${lista}=      Create List    ${item}
    ${body}=       Create Dictionary    produtos=${lista}
    RETURN    ${body}

Criar Carrinho
    [Arguments]    ${body}
    ${headers}=     Criar Header Autorizado
    ${response}=    POST Endpoint    /carrinhos    ${body}    ${headers}
    RETURN    ${response}

Limpar Carrinho
    ${headers}=     Criar Header Autorizado
    DELETE Endpoint    /carrinhos/concluir-compra    ${headers}