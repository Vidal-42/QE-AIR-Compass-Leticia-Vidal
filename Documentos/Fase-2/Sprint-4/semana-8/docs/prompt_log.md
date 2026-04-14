# Rota /usuarios

### Prompt 1

**Objetivo:**
Gerar cenários negativos para /usuarios

---

**Contexto fornecido:**
Based on the current ServeRest automated test report, the /usuarios module already covers:
- successful user creation
- duplicate email validation
- security/regression test for IDOR (user deletion)

The test suite uses:
- Robot Framework
- RequestsLibrary
- FakerLibrary for dynamic data

The goal is to improve coverage focusing on:
- negative scenarios
- contract validation
- business rules
- test quality and traceability

Known rules:
- email must be unique
- name is required
- password is required
- request payload must follow API contract
- responses must be validated using status code and essential fields

---

**Prompt final:**
(cola exatamente o prompt que você enviou no Amazon Q)

---

**Resposta da IA (resumo):**
A IA gerou cenários negativos adicionais cobrindo:
- ausência de campos obrigatórios (nome, email, password)
- valores vazios
- formato inválido de email
- payload vazio
- valor inválido para o campo administrador
- validação de contrato de resposta (sucesso e erro)
- entradas com whitespace
- envio de campos extras não reconhecidos

---

**Validação/Ajustes manuais:**
- removi o cenário TC-U-12 por se tratar de um caso positivo (não negativo)
- refinei descrições de resultados esperados que estavam genéricas (ex: "validation error")
- mantive cenários de contrato, mas marquei necessidade de validação com a API real
- validei que os campos utilizados (nome, email, password, administrador) existem no endpoint
- mantive cenários de robustez (campos extras), pois agregam valor de teste
- identifiquei que o comportamento do campo "administrador" precisa ser confirmado no contrato real
- mantive cenários com comportamento incerto (whitespace, campos extras), destacando necessidade de validação prática

---

**Critérios de validação:**
- conferência com o relatório de testes existente
- verificação de consistência com os testes automatizados atuais
- validação dos campos com base no contrato da API ServeRest
- eliminação de cenários duplicados ou já cobertos
- análise de viabilidade de automação com Robot Framework



## Context
Based on the current ServeRest automated test report, the `/usuarios` module already covers:
- successful user creation
- duplicate email validation
- security/regression test for IDOR (user deletion)

The test suite uses:
- Robot Framework
- RequestsLibrary
- FakerLibrary for dynamic data

The goal for this challenge is to improve coverage for `/usuarios`, focusing on:
- positive scenarios
- test robustness
- input variation
- data validation

### Known rules:
- email must be unique
- name is required
- password is required
- request payload must follow API contract
- responses must be validated using status code and essential fields

---

## Task
Generate additional **positive test scenarios** for the endpoint `/usuarios` (user creation).

The goal is to identify valid variations of input data that are not yet covered and improve test robustness.

---

## Output format
Provide a table with the following columns:

ID | Scenario | Preconditions | Input | Expected Result | Test Type

---

## Constraints
- Do not invent endpoints
- Do not repeat the basic successful scenario already implemented
- Ensure scenarios are realistic and valid according to the API contract
- Focus on variations of valid inputs (not invalid cases)
- Ensure scenarios are automatable using Robot Framework


### Prompt 2

**Objetivo:**
Gerar cenários positivos para /usuarios

---

**Contexto fornecido:**
Based on the current ServeRest automated test report, the `/usuarios` module already covers:
- successful user creation
- duplicate email validation
- security/regression test for IDOR (user deletion)

The test suite uses:
- Robot Framework
- RequestsLibrary
- FakerLibrary for dynamic data

The goal is to improve coverage focusing on:
- positive scenarios
- test robustness
- input variation
- data validation

Known rules:
- email must be unique
- name is required
- password is required
- request payload must follow API contract
- responses must be validated using status code and essential fields

---

**Prompt final:**
(cole aqui o prompt que você enviou no Amazon Q)

---

**Resposta da IA (resumo):**
(preencha depois que executar — ex:)
- variações de dados válidos
- diferentes combinações de administrador
- inputs com tamanhos variados
- validação de dados consistentes

---

**Validação/Ajustes manuais:**
(exemplo — ajuste depois da resposta real)
- removi cenários duplicados do fluxo básico
- refinei inputs para garantir unicidade de email
- ajustei valores para manter consistência com regras da API
- validei que todos os cenários são executáveis no Robot Framework

---

**Critérios de validação:**
- consistência com o contrato da API
- não duplicação de cenários já existentes
- validade dos dados de entrada
- viabilidade de automação



### Prompt 2

**Objetivo:**
Gerar cenários positivos para /usuarios

---

**Contexto fornecido:**
Based on the current ServeRest automated test report, the `/usuarios` module already covers:
- successful user creation
- duplicate email validation
- security/regression test for IDOR (user deletion)

The test suite uses:
- Robot Framework
- RequestsLibrary
- FakerLibrary for dynamic data

The goal is to improve coverage focusing on:
- positive scenarios
- test robustness
- input variation
- data validation

Known rules:
- email must be unique
- name is required
- password is required
- request payload must follow API contract
- responses must be validated using status code and essential fields

---

**Prompt final:**
(cole o prompt que você usou)

---

**Resposta da IA (resumo):**
A IA gerou cenários positivos cobrindo:
- criação de usuário administrador (true)
- validação de contrato na resposta (_id e message)
- fluxo de autenticação após criação
- recuperação do usuário via GET
- variações de entrada (nome com caracteres especiais, senha com símbolos, email com subdomínio)
- testes de limite para nome
- validação de integridade (_id único)
- validação de regra de negócio (nome não precisa ser único)

---

**Validação/Ajustes manuais:**
- reclassifiquei cenários que são de contrato e integração, não apenas positivos
- mantive cenários de integração (login e GET), pois aumentam a cobertura end-to-end
- identifiquei que o endpoint GET /usuarios/{_id} precisa ser validado na API real
- mantive cenário de limite de nome (100 caracteres), mas marquei como hipótese a ser validada
- validei que os campos utilizados existem no contrato da API
- mantive cenários de variação de dados por aumentarem robustez dos testes
- confirmei que os cenários são automatizáveis com Robot Framework

---

**Critérios de validação:**
- consistência com o relatório de testes existente
- verificação de não duplicação de cenários já implementados
- validação dos campos com base no contrato da API ServeRest
- análise de viabilidade de automação
- avaliação de cobertura adicional gerada pelos cenários


### Prompt 4

**Objetivo:**
Identificar e gerar cenários de regras de negócio para /usuarios

---

**Contexto fornecido:**
Based on the current ServeRest automated test report, the `/usuarios` module already covers:
- successful user creation
- duplicate email validation
- security/regression test for IDOR (user deletion)

The test suite uses:
- Robot Framework
- RequestsLibrary
- FakerLibrary for dynamic data

Currently:
- GET endpoints are not tested
- DELETE is only used for teardown
- no validation of data persistence or retrieval

The goal is to identify and validate business rules.

Known rules:
- email must be unique
- name is required
- password is required
- request payload must follow API contract

---

**Prompt final:**
(cole o prompt que você enviou)

---

**Resposta da IA (resumo):**
A IA identificou regras de negócio importantes e lacunas de cobertura, incluindo:
- comportamento da unicidade do email (incluindo case sensitivity)
- persistência do campo administrador (true/false)
- integridade dos dados após criação (_id único, dados recuperáveis)
- possibilidade de reutilização de email após deleção
- comportamento ao deletar usuários inexistentes
- ausência de exposição da senha em respostas GET
- incremento da quantidade de usuários após criação
- validação de regras de segurança (IDOR já coberto)

Também identificou lacunas relevantes:
- endpoints GET não testados
- DELETE usado apenas em teardown
- ausência de validação de persistência e recuperação de dados

---

**Validação/Ajustes manuais:**
- mantive regras confirmadas (unicidade de email, integridade de dados, IDOR)
- classifiquei corretamente cenários entre regra de negócio, integridade e segurança
- marquei como "requires validation" cenários com comportamento não confirmado:
  - case sensitivity do email
  - reutilização de email após deleção
  - comportamento ao deletar usuário inexistente
  - incremento da quantidade de usuários
- validei que os endpoints utilizados (GET, DELETE) existem na API
- destaquei lacunas reais no plano de testes atual (GET não testado, persistência não validada)
- garanti que todos os cenários são automatizáveis com Robot Framework

---

**Critérios de validação:**
- consistência com comportamento observado na API
- alinhamento com testes existentes
- distinção entre regra de negócio, contrato e segurança
- validação de integridade e persistência de dados
- viabilidade de automação


### Prompt 5

**Objetivo:**
Melhorar a qualidade de um caso de teste para /usuarios

---

**Contexto fornecido:**
Based on the current ServeRest automated test suite, the `/usuarios` endpoint has basic test coverage.

The existing test:
- validates only status code (201)
- does not validate response body
- does not verify data persistence
- uses implicit test data inside keywords
- does not validate cleanup

The goal is to transform a simple test into a complete, high-quality test case.

---

**Prompt final:**
(cole o prompt que você enviou)

---

**Resposta da IA (resumo):**
A IA transformou um teste simples em um caso completo, incluindo:
- pré-condições explícitas
- definição detalhada de dados de teste
- passos estruturados
- validações completas (status code + response body)
- validação de persistência via GET /usuarios/{_id}
- verificação de regra de negócio (administrador=false)
- definição de pós-condições com cleanup

Também apresentou uma comparação clara entre o teste original e o melhorado.

---

**Validação/Ajustes manuais:**
- mantive validação de `_id` e `message` como campos obrigatórios
- refinei pós-condição para não assumir comportamento fixo após DELETE (200 vs 404)
- ajustei definição de senha para não assumir regra fixa de tamanho
- destaquei reutilização de keywords existentes (ex: Validar Chaves do JSON)
- validei compatibilidade com estrutura atual do Robot Framework
- garanti que o teste é executável e alinhado com o comportamento real da API

---

**Critérios de validação:**
- clareza e completude do caso de teste
- alinhamento com testes existentes
- reutilização de componentes (keywords)
- validação de contrato e persistência de dados
- viabilidade de automação

### Prompt 6

**Objetivo:**
Gerar teste automatizado em Robot Framework para /usuarios

---

**Contexto fornecido:**
Projeto com Robot Framework estruturado em:
- base_api.resource
- usuarios.resource
- data_factory.resource

Uso de:
- FakerLibrary
- keywords reutilizáveis
- teardown com limpeza de usuário

---

**Prompt final:**
(cole o prompt que você enviou)

---

**Resposta da IA (resumo):**
A IA gerou um teste completo em Robot Framework que:
- cria um usuário não administrador
- valida status code
- valida contrato (_id e message)
- armazena o ID do usuário
- valida persistência via GET
- compara dados retornados com payload original

---

**Validação/Ajustes manuais:**
- ajustei nomes de keywords para compatibilidade com o projeto
- validei estrutura do JSON retornado
- garanti uso correto de variáveis (${ID_USUARIO_CRIADO})
- confirmei que o teste é idempotente
- adaptei chamadas GET conforme implementação existente

---

**Critérios de validação:**
- compatibilidade com estrutura atual do projeto
- reutilização de keywords existentes
- validação de contrato e persistência
- execução sem conflitos de dados
- clareza e legibilidade do teste


### Prompt 7

**Objetivo:**
Refatorar automação Robot para reduzir duplicação e melhorar reutilização de código

**Contexto fornecido:**
Suite de testes Robot Framework com múltiplos cenários para POST /usuarios contendo repetição de validações de status code, JSON e extração de _id

**Prompt final:**
(cole o prompt que você usou)

**Resposta da IA (resumo):**
A IA identificou duplicação em validações de sucesso e erro, sugerindo a criação de keywords reutilizáveis para validação de resposta 201, validação de erros 400 e criação de usuário com validação integrada.

**Validação/Ajustes manuais:**
- implementei apenas as keywords principais sugeridas
- apliquei refatoração parcial em alguns testes
- mantive parte da estrutura original para evitar regressão

**Critérios de validação:**
- redução de duplicação
- legibilidade dos testes
- compatibilidade com estrutura atual

### Prompt 8

**Objetivo:**
Melhorar a qualidade dos casos de teste (clareza, pré-condições, dados e oráculos)

**Contexto fornecido:**
Plano de testes para /usuarios contendo cenários positivos e negativos, porém com:
- ausência de pré-condições explícitas
- validações limitadas ao status code
- ausência de oráculo detalhado
- ausência de pós-condições documentadas

**Prompt final:**
(cole o prompt que você usou)

**Resposta da IA (resumo):**
A IA identificou que o cenário de e-mail duplicado era fraco e gerou uma versão melhorada com:
- pré-condições explícitas
- dados de teste estruturados
- validações completas (status + body)
- oráculo claro (presença de message e ausência de _id)
- pós-condições com limpeza do ambiente

**Validação/Ajustes manuais:**
- validei coerência com comportamento real da API
- confirmei uso correto dos campos (nome, email, password, administrador)
- ajustei linguagem para alinhar com padrão do projeto
- optei por não alterar totalmente o código para evitar regressão

**Critérios de validação:**
- clareza do caso de teste
- completude (pré-condições, dados, passos, resultado)
- aderência ao contrato da API
- consistência com testes existentes



# Rota /login

### Prompt 1

**Objetivo:**
Gerar cenários negativos para /login

**Contexto fornecido:**
Endpoint POST /login já possui testes para:
- login válido
- senha inválida
- email inexistente

Payload esperado:
email, password

**Prompt final:**
(cole o prompt que você usou)

**Resposta da IA (resumo):**
A IA gerou cenários negativos adicionais cobrindo:
- campos obrigatórios ausentes
- body vazio
- valores vazios
- validação de contrato em respostas de erro
- ausência de token em falhas de autenticação

**Validação/Ajustes manuais:**
- removi cenários redundantes
- ignorei casos incertos (whitespace)
- selecionei cenários com maior valor de cobertura

**Critérios de validação:**
- não duplicar testes existentes
- aderência ao contrato da API
- consistência com comportamento esperado


### Prompt 2

**Objetivo:**
Gerar cenários positivos adicionais para o endpoint /login, focando em cobertura de contrato, integração e regras de negócio, evitando duplicação dos testes já existentes.

**Contexto fornecido:**
A suíte atual de testes de login cobre:

- login com sucesso (status 200 + presença da chave authorization)
- login com senha inválida (401)
- login com e-mail não cadastrado (401)
- teste de segurança com token malformado em endpoint protegido

Tecnologias utilizadas:
- Robot Framework
- RequestsLibrary

Regras conhecidas:
- login válido retorna status 200 e token de autorização
- login inválido retorna status 401
- resposta deve seguir contrato JSON da API

Limitações atuais:
- validação apenas da presença da chave authorization
- ausência de validação do conteúdo do token
- ausência de validação do corpo completo da resposta
- ausência de testes de integração com endpoints protegidos

**Prompt final:**
Context:
Based on the current automated test suite for the ServeRest API, the /login endpoint already covers:

- successful login (status 200 + authorization key)
- invalid password (401)
- unregistered email (401)
- malformed token test on protected endpoint

The test suite uses:
- Robot Framework
- RequestsLibrary

Known rules:
- valid login returns 200 with authorization token
- invalid credentials return 401
- response must follow API contract

Current gaps:
- no validation of token content
- no full response body validation
- no integration validation using real token
- no variation between admin and non-admin users

Task:
Generate additional positive test scenarios for POST /login that improve coverage without duplicating existing tests.

Output format:
Provide a table with the following columns:
ID | Scenario | Input | Expected Result | Test Type

Constraints:
- Do not duplicate existing tests
- Do not invent endpoints
- Use only valid fields (email, password)
- Ensure scenarios are realistic and automatable
- If unsure about exact response, indicate validation against API contract

**Resposta da IA (resumo):**
A IA gerou cenários positivos incluindo:

- validação de token como string não vazia
- validação completa do corpo da resposta (message + authorization)
- validação da mensagem de sucesso
- uso do token em endpoint protegido (/carrinhos)
- login com usuário admin e não-admin
- múltiplos logins sequenciais
- validação de comportamento de reemissão de token

**Validação/Ajustes manuais:**
- mantive todos os cenários pois estão coerentes com a API
- marquei cenários de comportamento de token (reuso/diferença) como "necessita validação"
- garanti que nenhum cenário duplicava os testes existentes
- refinei mentalmente a classificação entre contrato, integração e regra de negócio

**Critérios de validação:**
- verificação com comportamento real da API ServeRest
- consistência com testes já existentes no projeto
- validação do contrato JSON (presença e tipo dos campos)
- análise de viabilidade de automação com Robot Framework


### Prompt 3

**Objetivo:**
Gerar cenários de teste de contrato para o endpoint /login, cobrindo respostas de sucesso e erro.

**Contexto fornecido:**
Resposta de sucesso:
{
"authorization": "string"
}

Resposta de erro:
{
"message": "string"
}

Testes atuais já validam:
- presença de authorization em 200
- presença de message em 401
- ausência de authorization em 401
- validações básicas de campos em 400

Lacunas:
- tipos dos campos não validados
- estrutura completa da resposta não validada
- headers não validados

**Prompt final:**
Context:
I am testing the contract of the POST /login endpoint.

Task:
Generate contract validation scenarios for both success and error responses.

Focus on:
- required fields
- data types
- response structure

Output format:
Table:
ID | Scenario | Validation | Expected Result | Test Type

Constraints:
- Do not invent fields
- Use only "authorization" and "message"

**Resposta da IA (resumo):**
A IA gerou cenários cobrindo:
- validação de tipo do token (string)
- validação de ausência de campos indevidos
- validação de estrutura completa da resposta
- validação de headers (Content-Type)
- validação de consistência entre respostas 200, 400 e 401

**Validação/Ajustes manuais:**
- mantive cenários de tipo e estrutura
- marquei validação de estrutura exata como dependente da API real
- organizei mentalmente separação entre contrato e segurança

**Critérios de validação:**
- aderência ao contrato JSON da API
- consistência com testes existentes
- viabilidade de automação com Robot

### Prompt 4

**Objetivo:**
Identificar regras de negócio do endpoint /login.

**Contexto fornecido:**
O endpoint /login autentica usuários e retorna token.

Testes atuais:
- login válido
- senha inválida
- usuário inexistente
- token malformado

**Prompt final:**
Context:
The login endpoint authenticates a user and returns a token.

Task:
Identify business rules related to login behavior.

Focus on:
- authentication logic
- security constraints
- token behavior

Output format:
Table:
ID | Business Rule | Scenario | Expected Result | Test Type

Constraints:
- Do not invent endpoints
- Keep aligned with API behavior

**Resposta da IA (resumo):**
A IA identificou regras como:
- autenticação depende de credenciais corretas
- token é necessário para acessar endpoints protegidos
- token pode ser invalidado após exclusão do usuário
- admin e não-admin podem logar
- falha nunca retorna token

**Validação/Ajustes manuais:**
- classifiquei regras como confirmadas vs implícitas
- marquei cenários que precisam validação na API real
- relacionei regras com testes existentes (ex: IDOR)

**Critérios de validação:**
- consistência com comportamento observado na API
- alinhamento com testes automatizados existentes
- separação clara entre regra e contrato

### Prompt 5

**Objetivo:**
Melhorar a qualidade de um teste de login existente (senha inválida).

**Contexto fornecido:**
Cenário atual:
- valida apenas status code 401
- não valida corpo da resposta
- não possui teardown adequado

**Prompt final:**
Context:
The current login test only validates status code.

Task:
Improve the test case by:
- adding preconditions
- defining test data
- improving assertions

Output format:
Structured test case:
ID, Title, Preconditions, Steps, Expected Results

Constraints:
- Keep same endpoint
- Do not change test purpose

**Resposta da IA (resumo):**
A IA:
- adicionou pré-condições claras
- definiu dados de teste detalhados
- adicionou validação de message
- garantiu ausência de authorization
- corrigiu problema de cleanup (teardown)

**Validação/Ajustes manuais:**
- confirmei que o teste continua com o mesmo objetivo
- validei que o teardown agora funciona corretamente
- refinei a separação entre dado válido e inválido

**Critérios de validação:**
- clareza do teste (pré, passo, pós)
- completude das validações
- aderência ao comportamento da API

### Prompt 6

**Objetivo:**
Gerar teste automatizado em Robot Framework para o endpoint /login.

**Contexto fornecido:**
- uso de Robot Framework
- uso de RequestsLibrary
- existência de keyword Fazer Login Request

**Prompt final:**
Context:
I am using Robot Framework with RequestsLibrary to test POST /login.

Task:
Generate a Robot Framework test that:
- performs a successful login
- validates status code
- validates presence of authorization token

Output format:
Robot Framework test case ready to paste

Constraints:
- reuse existing keywords
- do not invent endpoints

**Resposta da IA (resumo):**
A IA gerou um teste que:
- cria usuário
- realiza login
- valida status 200
- valida authorization e message
- valida token não vazio
- usa token em endpoint protegido (/carrinhos)

**Validação/Ajustes manuais:**
- confirmei reutilização de keywords existentes
- validei que o teste cobre integração (token funcional)
- refinei assertions para evitar falsos positivos

**Critérios de validação:**
- execução real no Robot Framework
- clareza e legibilidade
- aderência ao padrão do projeto

### Prompt 7

**Objetivo:**
Refatorar testes de login para reduzir duplicação e melhorar organização.

**Contexto fornecido:**
Os testes possuem:
- repetição de validações (200, 400, 401)
- ausência de teardown
- ausência de keywords reutilizáveis

**Prompt final:**
Context:
Login tests repeat validation logic.

Task:
Suggest reusable keywords to reduce duplication.

Output format:
- problems
- suggested keywords
- example refactor

Constraints:
- keep compatibility

**Resposta da IA (resumo):**
A IA identificou:
- duplicação de validações de status
- falta de teardown
- falta de separação por domínio

E sugeriu:
- novos keywords reutilizáveis
- criação de login.resource
- refatoração completa do login.robot

**Validação/Ajustes manuais:**
- confirmei que keywords são reutilizáveis
- validei compatibilidade com estrutura atual
- analisei impacto na legibilidade e manutenção

**Critérios de validação:**
- redução de código duplicado
- melhoria na organização
- aderência a boas práticas de automação


# Rota Login 

### Prompt 1 — Negativos /produtos

**Objetivo:**  
Gerar cenários negativos adicionais para o endpoint POST /produtos.

**Contexto fornecido:**  
- Testes existentes cobrem:
  - cadastro com sucesso (admin)
  - bloqueio para usuário comum
  - nome duplicado
- Endpoint: POST /produtos

**Prompt final:**  
(GERADO ACIMA)

**Resposta da IA (resumo):**  
A IA sugeriu cenários negativos envolvendo:
- ausência de campos obrigatórios (nome, preco, descricao, quantidade)
- valores inválidos (preço negativo, string em campos numéricos)
- payload vazio
- campos vazios

**O que ajustei/validei manualmente:**  
- Removi cenários já existentes (nome duplicado, usuário comum)
- Mantive apenas cenários realmente novos
- Validei que todos os campos existem na API

**Critérios de validação usados:**  
- Conferir se endpoint existe
- Conferir se campos pertencem ao contrato real
- Evitar duplicação de cenários já testados

### Prompt 2 — Positivos /produtos

**Objetivo:**  
Expandir cenários positivos para POST /produtos.

**Contexto fornecido:**  
- Apenas sucesso básico (201) já testado

**Prompt final:**  
(GERADO ACIMA)

**Resposta da IA (resumo):**  
Foram gerados cenários com:
- valores limite (preço zero, quantidade zero)
- variações de dados válidos
- múltiplos cadastros

**O que ajustei/validei manualmente:**  
- Removi redundâncias
- Mantive cenários com valor real de negócio

**Critérios de validação usados:**  
- Validar coerência com regra de negócio
- Garantir inputs válidos

### Prompt 3 — Contrato /produtos

**Objetivo:**  
Validar estrutura de resposta e contrato da API.

**Contexto fornecido:**  
- Endpoint POST /produtos

**Resposta da IA (resumo):**  
- validação de _id
- tipos de dados
- ausência de campos indevidos

**O que ajustei:**  
- alinhei com comportamento real da API

**Critérios:**  
- validar campos obrigatórios
- validar tipo de dados

### Prompt 4 — Regras de Negócio /produtos

**Objetivo:**  
Identificar regras de negócio do endpoint.

**Resposta da IA (resumo):**  
- nome único
- apenas admin pode criar
- preço deve ser positivo
- quantidade não negativa

**Ajustes:**  
- removi regras duplicadas

**Critérios:**  
- coerência com comportamento observado

### Prompt 5 — Melhoria de Caso de Teste

**Objetivo:**  
Melhorar qualidade de um teste fraco existente.

**Escolha:**  
Cenário 01 (muito simples)

**Melhorias:**  
- adicionadas pré-condições
- validação de contrato
- validação de persistência

**Critérios:**  
- clareza
- rastreabilidade
- assertividade

### Prompt 5 — Melhoria de Caso de Teste

**Objetivo:**  
Melhorar qualidade de um teste fraco existente.

**Escolha:**  
Cenário 01 (muito simples)

**Melhorias:**  
- adicionadas pré-condições
- validação de contrato
- validação de persistência

**Critérios:**  
- clareza
- rastreabilidade
- assertividade

### Prompt 6 — Geração de Automação Robot (/produtos)

**Objetivo:**  
Gerar testes automatizados em Robot Framework para o endpoint /produtos com melhoria de qualidade e reutilização.

**Contexto fornecido:**  
- Testes existentes cobrem:
  - cadastro com sucesso
  - bloqueio para usuário comum
  - nome duplicado
- Uso de RequestsLibrary
- Keywords existentes: Criar Produto, Criar Usuario, Fazer Login

**Prompt final:**  
(GERADO ACIMA)

**Resposta da IA (resumo):**  
Foram gerados testes Robot Framework com:
- validação de status code
- validação de contrato (JSON)
- cenários positivos e negativos
- reutilização de keywords

**O que ajustei/validei manualmente:**  
- Adicionei padrão de validação reutilizável (201, 400, 403)
- Removi validações duplicadas
- Padronizei asserts
- Adicionei validação de persistência (GET após POST)
- Removi hardcode desnecessário de mensagens

**Critérios de validação usados:**  
- Reutilização de keywords
- Clareza e legibilidade
- Cobertura (positivo, negativo, contrato)
- Não inventar endpoints
- Aderência ao comportamento real da API


### Prompt 7 — Refatoração de Automação

**Objetivo:**  
Reduzir duplicação nos testes de produtos.

**Resultado:**  
- criação de keywords reutilizáveis
- padronização de validações

**Ajustes:**  
- adaptei para base_api.resource existente

**Critérios:**  
- evitar duplicação
- melhorar legibilidade

### Prompt 8 — Revisão Final /produtos

**Objetivo:**  
Revisar cobertura geral dos testes.

**Resultado:**  
- identificação de gaps restantes
- confirmação de cobertura:
  - positivos
  - negativos
  - contrato
  - regras

**Ajustes:**  
- priorização de cenários críticos

**Critérios:**  
- cobertura completa
- aderência ao desafio

# Rota carrinho

### Prompt 1 — Negativos /carrinhos

**Objetivo:**  
Gerar cenários negativos para POST /carrinhos.

**Contexto fornecido:**  
- Endpoint: POST /carrinhos
- Fluxo envolve usuário autenticado + produtos

**Resposta da IA (resumo):**  
- produtos inválidos
- quantidade inválida
- problemas de autenticação
- carrinho vazio

**O que ajustei/validei manualmente:**  
- Removi cenários irrelevantes
- Mantive apenas cenários aplicáveis à API

**Critérios de validação usados:**  
- Validar existência do endpoint
- Validar coerência com fluxo real

### Prompt 2 — Positivos /carrinhos

**Objetivo:**  
Gerar cenários positivos para carrinho.

**Resposta da IA (resumo):**  
- adicionar múltiplos produtos
- quantidade válida
- criação com sucesso

**Ajustes:**  
- mantidos cenários com valor de negócio

**Critérios:**  
- coerência com fluxo real

### Prompt 3 — Contrato /carrinhos

**Objetivo:**  
Validar estrutura da resposta.

**Resposta da IA:**  
- validar message
- validar campos do carrinho

**Critérios:**  
- validar estrutura JSON

### Prompt 4 — Regras de Negócio /carrinhos

**Objetivo:**  
Identificar regras do carrinho.

**Resposta:**  
- usuário só pode ter 1 carrinho
- quantidade > 0
- produto deve existir

**Critérios:**  
- coerência com comportamento da API

### Prompt 5 — Melhoria de Teste

**Objetivo:**  
Melhorar teste fraco existente.

**Melhorias:**  
- adicionar pré-condições
- validar resposta completa
- validar persistência

**Critérios:**  
- clareza
- cobertura

### Prompt 6 — Automação Robot /carrinhos

**Objetivo:**  
Gerar testes automatizados.

**Resultado:**  
- testes reutilizando keywords
- validação de contrato

**Critérios:**  
- não duplicar código
- reutilizar estrutura existente

### Prompt 7 — Refatoração /carrinhos

**Objetivo:**  
Reduzir duplicação.

**Resultado:**  
- criação de keywords
- padronização

**Critérios:**  
- legibilidade
- manutenção

### Prompt 8 — Revisão Final /carrinhos

**Objetivo:**  
Validar cobertura completa.

**Resultado:**  
- positivos
- negativos
- contrato
- regras

**Critérios:**  
- aderência ao desafio