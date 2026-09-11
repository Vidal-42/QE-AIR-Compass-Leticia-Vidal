"""Testes de Produtos da API ServeRest."""

import uuid

import pytest


def test_ct_c04_listar_produtos(api_session, base_url, headers_cliente):
    """CT-C04: GET /produtos retorna 200 e lista."""
    resp = api_session.get(f"{base_url}/produtos", headers=headers_cliente)
    assert resp.status_code == 200
    assert "produtos" in resp.json()


def test_ct_c05_consultar_produto_existente(api_session, base_url, headers_cliente, produto_admin):
    """CT-C05: GET /produtos/{id} existente retorna 200."""
    resp = api_session.get(
        f"{base_url}/produtos/{produto_admin['id']}",
        headers=headers_cliente,
    )
    assert resp.status_code == 200
    assert resp.json()["nome"] == produto_admin["nome"]


def test_ct_a08_listar_produtos_admin(api_session, base_url, headers_admin):
    """CT-A08: GET /produtos como admin retorna 200."""
    resp = api_session.get(f"{base_url}/produtos", headers=headers_admin)
    assert resp.status_code == 200
    assert "produtos" in resp.json()


def test_ct_a09_cadastrar_produto_valido(api_session, base_url, headers_admin):
    """CT-A09: POST /produtos com dados válidos retorna 201."""
    nome = f"Produto_{uuid.uuid4().hex[:8]}"
    payload = {
        "nome": nome,
        "preco": 50,
        "descricao": "Teste",
        "quantidade": 5,
    }
    resp = api_session.post(f"{base_url}/produtos", json=payload, headers=headers_admin)
    assert resp.status_code == 201
    assert "_id" in resp.json()


def test_ct_a10_atualizar_produto_existente(api_session, base_url, headers_admin, produto_admin):
    """CT-A10: PUT /produtos/{id} retorna 200 e mudança confirmada via GET.

    Observação: o PUT retorna apenas mensagem de confirmação, não o recurso
    atualizado. Por isso a validação do novo valor é feita via GET em seguida.
    """
    payload = {
        "nome": produto_admin["nome"],
        "preco": 200,
        "descricao": produto_admin["descricao"],
        "quantidade": produto_admin["quantidade"],
    }
    resp = api_session.put(
        f"{base_url}/produtos/{produto_admin['id']}",
        json=payload,
        headers=headers_admin,
    )
    assert resp.status_code == 200

    # Confirmação via GET
    resp_get = api_session.get(
        f"{base_url}/produtos/{produto_admin['id']}",
        headers=headers_admin,
    )
    assert resp_get.status_code == 200
    assert resp_get.json()["preco"] == 200


def test_ct_a11_excluir_produto_sem_vinculo(api_session, base_url, headers_admin):
    """CT-A11: DELETE /produtos/{id} sem vínculo retorna 200."""
    nome = f"Produto_{uuid.uuid4().hex[:8]}"
    payload = {
        "nome": nome,
        "preco": 10,
        "descricao": "Excluir",
        "quantidade": 1,
    }
    resp = api_session.post(f"{base_url}/produtos", json=payload, headers=headers_admin)
    assert resp.status_code == 201
    produto_id = resp.json()["_id"]

    resp = api_session.delete(f"{base_url}/produtos/{produto_id}", headers=headers_admin)
    assert resp.status_code == 200


def test_ct_a15_consultar_produto_inexistente(api_session, base_url, headers_admin):
    """CT-A15: GET /produtos/{id} inexistente retorna 400."""
    resp = api_session.get(
        f"{base_url}/produtos/0000000000000000",
        headers=headers_admin,
    )
    assert resp.status_code == 400


def test_ct_a16_cadastrar_produto_nome_existente(api_session, base_url, headers_admin, produto_admin):
    """CT-A16: POST /produtos com nome já existente retorna 400."""
    payload = {
        "nome": produto_admin["nome"],
        "preco": 10,
        "descricao": "Duplicado",
        "quantidade": 1,
    }
    resp = api_session.post(f"{base_url}/produtos", json=payload, headers=headers_admin)
    assert resp.status_code == 400


def test_ct_a17_cadastrar_produto_sem_auth(api_session, base_url):
    """CT-A17: POST /produtos sem autenticação retorna 401."""
    payload = {
        "nome": "Sem Auth",
        "preco": 10,
        "descricao": "Teste",
        "quantidade": 1,
    }
    resp = api_session.post(f"{base_url}/produtos", json=payload)
    assert resp.status_code == 401


def test_ct_a18_cadastrar_produto_sem_admin(api_session, base_url, headers_cliente):
    """CT-A18: POST /produtos sem perfil admin retorna 403."""
    payload = {
        "nome": "Sem Admin",
        "preco": 10,
        "descricao": "Teste",
        "quantidade": 1,
    }
    resp = api_session.post(f"{base_url}/produtos", json=payload, headers=headers_cliente)
    assert resp.status_code == 403


def test_ct_a19_atualizar_produto_sem_auth(api_session, base_url, produto_admin):
    """CT-A19: PUT /produtos/{id} sem autenticação retorna 401."""
    payload = {
        "nome": produto_admin["nome"],
        "preco": 10,
        "descricao": "Teste",
        "quantidade": 1,
    }
    resp = api_session.put(
        f"{base_url}/produtos/{produto_admin['id']}",
        json=payload,
    )
    assert resp.status_code == 401


def test_ct_a20_atualizar_produto_sem_admin(api_session, base_url, headers_cliente, produto_admin):
    """CT-A20: PUT /produtos/{id} sem perfil admin retorna 403."""
    payload = {
        "nome": produto_admin["nome"],
        "preco": 10,
        "descricao": "Teste",
        "quantidade": 1,
    }
    resp = api_session.put(
        f"{base_url}/produtos/{produto_admin['id']}",
        json=payload,
        headers=headers_cliente,
    )
    assert resp.status_code == 403


def test_ct_a21_excluir_produto_sem_auth(api_session, base_url, produto_admin):
    """CT-A21: DELETE /produtos/{id} sem autenticação retorna 401."""
    resp = api_session.delete(f"{base_url}/produtos/{produto_admin['id']}")
    assert resp.status_code == 401


def test_ct_a22_excluir_produto_sem_admin(api_session, base_url, headers_cliente, produto_admin):
    """CT-A22: DELETE /produtos/{id} sem perfil admin retorna 403."""
    resp = api_session.delete(
        f"{base_url}/produtos/{produto_admin['id']}",
        headers=headers_cliente,
    )
    assert resp.status_code == 403


def test_ec_a03_cadastrar_produto_fronteira(api_session, base_url, headers_admin):
    """EC-A03: POST /produtos com valores de fronteira."""
    nome = f"Fronteira_{uuid.uuid4().hex[:8]}"
    payload = {
        "nome": nome,
        "preco": 0,
        "descricao": "Fronteira",
        "quantidade": 0,
    }
    resp = api_session.post(f"{base_url}/produtos", json=payload, headers=headers_admin)
    assert resp.status_code in (201, 400)
    assert resp.status_code != 500


def test_ec_a04_atualizar_produto_fronteira(api_session, base_url, headers_admin, produto_admin):
    """EC-A04: PUT /produtos/{id} com valores de fronteira."""
    payload = {
        "nome": produto_admin["nome"],
        "preco": 0,
        "descricao": "Fronteira",
        "quantidade": 0,
    }
    resp = api_session.put(
        f"{base_url}/produtos/{produto_admin['id']}",
        json=payload,
        headers=headers_admin,
    )
    assert resp.status_code in (200, 400)
    assert resp.status_code != 500


def test_ec_a05_excluir_produto_com_vinculo(
    api_session, base_url, headers_admin, headers_cliente, produto_admin
):
    """EC-A05: DELETE /produtos/{id} com vínculo em carrinho respeita integridade."""
    payload_cart = {"produtos": [{"idProduto": produto_admin["id"], "quantidade": 1}]}
    resp_cart = api_session.post(
        f"{base_url}/carrinhos",
        json=payload_cart,
        headers=headers_cliente,
    )
    assert resp_cart.status_code == 201

    resp = api_session.delete(
        f"{base_url}/produtos/{produto_admin['id']}",
        headers=headers_admin,
    )
    assert resp.status_code == 400


def test_bug_hunt_produto_preco_negativo_rejeitado(api_session, base_url, headers_admin):
    """Investigação: produto com preço negativo deveria ser rejeitado.

    Regra implícita de negócio: preços negativos não fazem sentido.
    Esperado: 400. Se a API aceitar (201), é comportamento incorreto a reportar.
    """
    nome = f"PrecoNegativo_{uuid.uuid4().hex[:8]}"
    payload = {
        "nome": nome,
        "preco": -10,
        "descricao": "Preço negativo",
        "quantidade": 1,
    }
    resp = api_session.post(f"{base_url}/produtos", json=payload, headers=headers_admin)

    assert resp.status_code == 400, (
        f"Esperado 400 (preço negativo rejeitado), "
        f"obtido {resp.status_code}: {resp.text}"
    )


@pytest.mark.xfail(
    reason="BUG-01 (confirmado manualmente): token de autorização inválido "
    "aceito em vez de retornar 401.",
    strict=False,
)
def test_bug01_token_malformado_deveria_ser_rejeitado(api_session, base_url):
    """BUG-01: Token malformado não é rejeitado.

    Comportamento observado: token corrompido é aceito e a rota responde
    como se o usuário estivesse autenticado.
    Resultado observado: 200/201 quando o esperado era 401 Unauthorized.
    """
    headers = {"Authorization": "Bearer token_invalido_e_corrompido"}
    payload = {
        "nome": "Token Malformado",
        "preco": 10,
        "descricao": "Teste",
        "quantidade": 1,
    }
    resp = api_session.post(f"{base_url}/produtos", json=payload, headers=headers)

    assert resp.status_code == 401, (
        f"Esperado 401 (token inválido deveria ser rejeitado), "
        f"obtido {resp.status_code}: {resp.text}"
    )