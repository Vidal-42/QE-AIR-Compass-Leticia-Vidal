*** Settings ***
Documentation     Keywords para o endpoint /carrinhos
Resource          base_api.resource

*** Keywords ***
Criar Body Carrinho
    [Arguments]    ${id_produto}    ${quantidade}=1
    ${item}=       Create Dictionary    idProduto=${id_produto}    quantidade=${quantidade}
    ${lista}=      Create List          ${item}
    ${body}=       Create Dictionary    produtos=${lista}
    RETURN         ${body}

Criar Body Carrinho Customizado
    [Arguments]    ${lista_produtos}
    ${body}=       Create Dictionary    produtos=${lista_produtos}
    RETURN         ${body}

Criar Carrinho
    [Arguments]    ${body}    ${headers}=${EMPTY}
    IF    '${headers}' == '${EMPTY}'
        ${headers}=    Criar Header Autorizado
    END
    ${response}=    POST Endpoint    /carrinhos    ${body}    ${headers}
    RETURN    ${response}

Limpar Carrinho
    ${headers}=     Criar Header Autorizado
    # A API ServeRest limpa o carrinho ao concluir ou cancelar a compra
    ${response}=    DELETE Endpoint    /carrinhos/concluir-compra    ${headers}
    RETURN    ${response}

Criar Carrinho E Validar Sucesso
    [Arguments]    ${body}
    ${response}=    Criar Carrinho    ${body}
    Should Be Equal As Integers    ${response.status_code}    201
    RETURN    ${response}

Criar Carrinho E Validar Erro 400
    [Arguments]    ${body}
    ${response}=    Criar Carrinho    ${body}
    Should Be Equal As Integers    ${response.status_code}    400
    RETURN    ${response}

Criar Carrinho Sem Auth E Validar 401
    [Arguments]    ${body}
    ${headers}=     Create Dictionary    Authorization=None
    ${response}=    POST Endpoint    /carrinhos    ${body}    ${headers}
    Should Be Equal As Integers    ${response.status_code}    401

Criar Carrinho Com Token Custom
    [Arguments]    ${body}    ${token}
    ${headers}=     Create Dictionary    Authorization=${token}
    ${response}=    POST Endpoint    /carrinhos    ${body}    ${headers}
    Should Be Equal As Integers    ${response.status_code}    401

Validar Resposta 400 Carrinho
    [Arguments]    ${response}
    Should Be Equal As Integers    ${response.status_code}    400