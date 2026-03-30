*** Settings ***
Resource    ../support/variables/base.robot

*** Keywords ***
Criar Usuario
    [Documentation]    Cadastra um novo usuário no sistema.
    [Arguments]    ${usuario}
    ${response}=    POST Endpoint    ${ENDPOINT_USUARIOS}    ${usuario}
    RETURN    ${response}

Deletar Usuario
    [Documentation]    Remove um usuário específico através do ID.
    [Arguments]    ${id}
    ${response}=    DELETE Endpoint    ${ENDPOINT_USUARIOS}/${id}
    RETURN    ${response}

Limpar Usuario Criado
    [Documentation]    Teardown idempotente. Deleta ${ID_USUARIO_CRIADO} se a variável existir.
    ${id}=    Get Variable Value    ${ID_USUARIO_CRIADO}    ${None}
    IF    $id is not None
        Deletar Usuario    ${id}
    END

Limpar Usuarios IDOR
    [Documentation]    Teardown do cenário IDOR. Remove vítima e atacante de forma segura e independente.
    ${id_vitima}=      Get Variable Value    ${ID_VITIMA}      ${None}
    ${id_atacante}=    Get Variable Value    ${ID_ATACANTE}    ${None}
    IF    $id_vitima is not None
        Deletar Usuario    ${id_vitima}
    END
    IF    $id_atacante is not None
        Deletar Usuario    ${id_atacante}
    END