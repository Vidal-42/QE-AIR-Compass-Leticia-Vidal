*** Settings ***
Documentation     Gestão de Usuários
Resource          ../support/variables/base.robot
Resource          ../keywords/usuarios.resource

Suite Setup       Criar Sessao API
Suite Teardown    Limpar Usuario Suite
Test Teardown     Limpar Usuario Criado


*** Test Cases ***
Cenário 01: Cadastro de usuário comum com sucesso
    ${user}=           Gerar Dados de Usuario Completo
    Set To Dictionary  ${user}    administrador=false
    ${response}=       Criar Usuario    ${user}
    Validar Status Code    ${response}    201
    Set Test Variable      ${ID_USUARIO_CRIADO}    ${response.json()['_id']}

Cenário 02: Impedir e-mail duplicado
    ${user}=           Gerar Dados de Usuario Completo
    Criar Usuario      ${user}
    ${response}=       Criar Usuario    ${user}
    Validar Status Code    ${response}    400

Cenário de Regressão: Validar IDOR na exclusão
    [Teardown]    Limpar Usuarios IDOR
    ${user_v}=         Gerar Dados de Usuario Completo
    ${resp_v}=         Criar Usuario    ${user_v}
    Set Test Variable  ${ID_VITIMA}      ${resp_v.json()['_id']}

    ${user_a}=         Gerar Dados de Usuario Completo
    Set To Dictionary  ${user_a}    administrador=false
    ${resp_a}=         Criar Usuario    ${user_a}
    Set Test Variable  ${ID_ATACANTE}    ${resp_a.json()['_id']}

    ${token_a}=        Fazer Login e Obter Token    ${user_a}
    ${headers}=        Criar Header Autorizado    ${token_a}
    ${response}=       DELETE Endpoint    ${ENDPOINT_USUARIOS}/${ID_VITIMA}    ${headers}
    Validar Status Code    ${response}    403
