*** Settings ***
Resource    ../support/variables/base.robot

*** Keywords ***
Criar Produto
    [Documentation]    Cadastra um novo produto no sistema utilizando um token de administrador.
    [Arguments]    ${produto}
    ${headers}=     Criar Header Autorizado
    ${response}=    POST Endpoint    ${ENDPOINT_PRODUTOS}    ${produto}    ${headers}
    RETURN    ${response}

Deletar Produto
    [Documentation]    Remove um produto pelo ID. Seguro se o produto não existir (404 é ignorado).
    [Arguments]    ${id}
    ${headers}=     Criar Header Autorizado
    ${response}=    DELETE Endpoint    ${ENDPOINT_PRODUTOS}/${id}    ${headers}
    Should Be True    ${response.status_code} == 200 or ${response.status_code} == 404

Limpar Produto Criado
    [Documentation]    Teardown idempotente. Deleta ${ID_PRODUTO_CRIADO} se existir.
    ${id}=    Get Variable Value    ${ID_PRODUTO_CRIADO}    ${None}
    IF    $id is not None
        Deletar Produto    ${id}
    END
