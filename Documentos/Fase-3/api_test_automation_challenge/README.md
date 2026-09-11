# Testes Automatizados de API — ServeRest

## Escopo

- API ServeRest: `https://compassuol.serverest.dev`
- Módulos: Login, Usuários, Produtos e Carrinhos
- Apenas testes de API. Cenários Web foram ignorados.

## Estrutura do projeto

```
API_Test_Automation/
├── tests/
│   ├── conftest.py        # fixtures: sessão HTTP, usuários/produto/carrinho de apoio, tokens
│   ├── test_login.py
│   ├── test_users.py
│   ├── test_products.py
│   └── test_carts.py
├── pytest.ini
├── requirements.txt
├── .gitignore
└── README.md
```

## Instalação

```bash
python -m venv .venv
source .venv/bin/activate    # Linux/macOS
.venv\Scripts\activate       # Windows

pip install -r requirements.txt
```

## Execução

```bash
# rodar tudo
pytest

# gerar relatório de execução em um único arquivo HTML (evidência de execução)
pytest --html=report.html --self-contained-html

# rodar só um módulo
pytest tests/test_login.py -v
```

## Organização dos testes (rastreabilidade com o plano)

| Arquivo | Módulo | Casos cobertos |
|---|---|---|
| `tests/test_login.py` | Login | CT-C01, CT-C08, CT-A01 |
| `tests/test_users.py` | Usuários | CT-C02, CT-C03, CT-C09, CT-A02 a CT-A07, CT-A12 a CT-A14, EC-A01, EC-A02 |
| `tests/test_products.py` | Produtos | CT-C04, CT-C05, CT-A08 a CT-A11, CT-A15 a CT-A22, EC-A03 a EC-A05 |
| `tests/test_carts.py` | Carrinhos | CT-C06, CT-C07, CT-C10 a CT-C14, EC-C01 a EC-C04 |

## Registro de ajustes

- **`conftest.py`**: faltava `import pytest` no topo do arquivo. Como toda fixture
  usa o decorator `@pytest.fixture`, a ausência do import quebrava a coleta de
  **todos** os testes com `NameError`. Corrigido.
- **Coverage removido**: o `pytest.ini` rodava `pytest-cov` (`--cov=. --cov-report=html`)
  em toda execução, gerando uma pasta `htmlcov/` com 13 arquivos a cada `pytest`.
  Como não há código de aplicação sendo testado (a API roda fora do projeto),
  coverage de código não agrega neste contexto — foi substituído por
  `pytest-html`, que gera um único arquivo de relatório de execução (passou/falhou),
  que é a evidência que o desafio pede.
- **Dependências atualizadas**: `pytest` 7.4.0 → 8.3.3 e `requests` 2.31.0 → 2.32.3,
  para compatibilidade com Python 3.14.
- Nenhum cenário de teste foi alterado — todas as funções em `tests/test_*.py`
  permanecem com a mesma lógica e asserções originais.

## Ajustes pós-execução real (1ª rodada: 43 passed, 2 failed)

Rodando a suíte pela primeira vez contra a API real, 43/45 testes passaram de
primeira. Duas falhas, mesma causa raiz:

- `test_ct_a10_atualizar_produto_existente` (`tests/test_products.py`) e
  `test_ct_a05_atualizar_usuario_existente` (`tests/test_users.py`) davam
  `KeyError: 'preco'` / `KeyError: 'nome'`.
- **Causa**: o `PUT /produtos/{id}` e o `PUT /usuarios/{id}` retornam
  `200` corretamente, mas o corpo da resposta traz só uma mensagem de
  confirmação — não o recurso atualizado. A asserção original assumia que
  dava pra ler `resp.json()["preco"]`/`resp.json()["nome"]` direto da
  resposta do PUT, o que nunca existiu nesse endpoint.
- **Correção**: depois do `PUT` (mantendo o `assert resp.status_code == 200`),
  foi adicionado um `GET` de confirmação no mesmo recurso, e a asserção do
  valor atualizado passou a ler desse `GET` — que é onde o recurso completo
  de fato é retornado. Nenhuma regra de negócio testada mudou; só a forma de
  verificar o resultado.
- Resultado após o ajuste: 45/45 passed.

## Testes extras de investigação de bug (não numerados no plano original)

Depois da 1ª execução real (45/45 passed), surgiu a dúvida: "é normal que
100% dos testes passem, se o instrutor comentou que existem bugs?" — e a
resposta é não necessariamente. Vários dos testes de edge case do plano
original usam asserções propositalmente amplas (`status_code in (200, 400)`),
porque o plano não define o comportamento exato esperado nesses casos —
então eles tendem a passar quase sempre, mesmo que exista um comportamento
questionável por trás.

Para investigar de forma mais direcionada, foram adicionados 3 testes com
asserção única e específica, mirando regras de negócio conhecidas (a partir
da seção 7 — Critérios de Aceitação — do plano e de comportamentos
comumente reportados nesta API pública):

- `test_bug_hunt_nao_permite_dois_carrinhos_abertos` (`test_carts.py`) —
  usuário não deveria conseguir ter 2 carrinhos abertos ao mesmo tempo.
- `test_bug_hunt_email_duplicado_case_insensitive` (`test_users.py`) —
  cadastro não deveria aceitar o mesmo e-mail com grafia em maiúsculas
  como se fosse diferente.
- `test_bug_hunt_produto_preco_negativo_rejeitado` (`test_products.py`) —
  produto não deveria aceitar preço negativo.

**Importante:** se algum desses 3 testes falhar ao rodar, **isso não é um
erro para corrigir escondendo a asserção** — é o comportamento que estamos
investigando. Uma falha aqui é uma descoberta real para registrar no
relatório final (é literalmente o tipo de achado que seu instrutor
mencionou existir). Ajuste a asserção só depois de confirmar com o
instrutor ou a documentação que o comportamento esperado é outro.

## Bugs confirmados manualmente, formalizados como testes (xfail)

Três bugs foram encontrados manualmente (fora desta suíte) e confirmados
antes de virarem testes automatizados. Como o comportamento incorreto já é
conhecido, esses testes usam `@pytest.mark.xfail` — o pytest reporta como
**XFAIL** (falha esperada/documentada) em vez de FAILED, e se um dia a API
for corrigida, reporta **XPASS** (avisando que o bug sumiu e a marcação
pode ser removida). É assim que se documenta um bug conhecido dentro da
própria suíte, sem contaminar a métrica de "quantos testes passaram".

| ID | Endpoint | Arquivo | Comportamento observado | Esperado |
|---|---|---|---|---|
| BUG-01 | `POST /produtos` | `test_products.py::test_bug01_token_malformado_deveria_ser_rejeitado` | Token de autorização inválido/corrompido é aceito (200/201) | 401 Unauthorized |
| BUG-02 | `DELETE /usuarios/{id}` | `test_users.py::test_bug02_usuario_comum_nao_deveria_excluir_outro_usuario` | Usuário comum exclui conta de outro usuário via ID (IDOR) | 403 Forbidden |
| BUG-03 | `DELETE /carrinhos/concluir-compra` | `test_carts.py::test_bug03_concluir_compra_sem_carrinho_ativo` | Conclui compra mesmo sem carrinho ativo | 400 Bad Request |

Nenhum desses 3 cenários existia no plano de testes original nem nos 48
testes anteriores — foram adicionados exclusivamente a partir da sua
investigação manual.
