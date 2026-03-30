*** Settings ***
Documentation     Testes de Login (Versão Refatorada com Master File)
Resource          ../support/variables/base.robot
Resource          ../keywords/usuarios.resource

Suite Setup       Criar Sessao API
Suite Teardown    Limpar Usuario Suite


*** Test Cases ***
Cenário 01: Login realizado com sucesso
    [Tags]    smoke    positivo
    ${user}=           Gerar Dados de Usuario Completo
    Criar Usuario      ${user}
    ${response}=       Fazer Login Request    ${user}
    
    # Substituído pela Keyword do seu mentor:
    Validar Status Code    ${response}    200
    Dictionary Should Contain Key    ${response.json()}    authorization

Cenário 02: Login com senha inválida
    [Tags]    negativo
    ${user}=           Gerar Dados de Usuario Completo
    Criar Usuario      ${user}
    ${body_errado}=    Create Dictionary    email=${user['email']}    password=erro123
    ${response}=       POST Endpoint    /login    ${body_errado}
    
    Validar Status Code    ${response}    401

Cenário 03: Login com e-mail não cadastrado
    [Tags]    negativo
    ${user_fake}=      Gerar Dados de Usuario Completo
    ${response}=       Fazer Login Request    ${user_fake}
    
    Validar Status Code    ${response}    401

Cenário de Segurança: Acesso com Token Malformado
    [Tags]    segurança    bug
    ${headers}=        Create Dictionary    Authorization=Bearer token_fake_123
    ${response}=       GET Endpoint    /carrinhos    ${headers}
    
    # Mantendo sua lógica de reportar falha caso o bug ainda exista
    Verificar Status e Reportar Falha    ${response}    401    A API não tratou token malformado.