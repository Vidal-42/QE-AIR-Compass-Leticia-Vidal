*** Settings ***
Resource    ../support/variables/base.robot

*** Keywords ***
Criar Body Carrinho
    [Arguments]    ${produto_id}
    # Usando a variável de quantidade padrão sugerida pela IA
    ${item}=        Create Dictionary    idProduto=${produto_id}    quantidade=${QTD_PADRAO_CARRINHO}
    ${lista}=       Create List    ${item}
    ${body}=        Create Dictionary    produtos=${lista}
    RETURN    ${body}

Criar Carrinho
    [Arguments]    ${body}
    ${headers}=     Criar Header Autorizado
    # Usando a variável de endpoint centralizada
    ${response}=    POST Endpoint    ${ENDPOINT_CARRINHOS}    ${body}    ${headers}
    RETURN    ${response}

Limpar Carrinho
    [Documentation]    Conclui a compra do usuário logado, restaurando o estoque. Seguro se não houver carrinho.
    ${headers}=     Criar Header Autorizado
    ${response}=    DELETE Endpoint    ${ENDPOINT_CONCLUIR_COMPRA}    ${headers}
    # 200 = carrinho concluído, 400 = sem carrinho ativo — ambos são estados limpos
    Should Be True    ${response.status_code} == 200 or ${response.status_code} == 400
