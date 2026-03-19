*** Settings ***
Documentation     Gestão de Usuários
Resource          ../resources/base_api.resource
Resource          ../resources/usuarios.resource
Suite Setup       Criar Sessao API
Test Teardown     Limpar Usuario Criado

*** Test Cases ***
Cenário 01: Cadastro de usuário comum com sucesso
    ${user}=           Gerar Dados de Usuario Completo
    Set To Dictionary  ${user}    administrador=false
    ${response}=       Criar Usuario    ${user}
    Should Be Equal As Integers    ${response.status_code}    201
    Set Test Variable  ${ID_USUARIO_CRIADO}    ${response.json()['_id']}

Cenário 02: Impedir e-mail duplicado
    ${user}=           Gerar Dados de Usuario Completo
    Criar Usuario      ${user}
    ${response}=       Criar Usuario    ${user}
    Should Be Equal As Integers    ${response.status_code}    400

Cenário de Regressão: Validar IDOR na exclusão
    ${user_v}=         Gerar Dados de Usuario Completo
    ${resp_v}=         Criar Usuario    ${user_v}
    ${id_v}=           Set Variable    ${resp_v.json()['_id']}
    ${user_a}=         Gerar Dados de Usuario Completo
    Set To Dictionary  ${user_a}    administrador=false
    Criar Usuario      ${user_a}
    ${token_a}=        Fazer Login e Obter Token    ${user_a}
    ${headers}=        Criar Header Autorizado    ${token_a}
    ${response}=       DELETE Endpoint    /usuarios/${id_v}    ${headers}
    Verificar Status e Reportar Falha    ${response}    403    Falha de IDOR detectada.