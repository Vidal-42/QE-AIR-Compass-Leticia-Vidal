"""Testes de Carrinhos da API ServeRest."""

import pytest


def test_ct_c06_listar_carrinhos(api_session, base_url, headers_cliente):
    """CT-C06: GET /carrinhos retorna 200."""
    resp = api_session.get(f"{base_url}/carrinhos", headers=headers_cliente)
    assert resp.status_code == 200


def test_ct_c07_consultar_carrinho_existente(
    api_session, base_url, headers_cliente, carrinho_cliente
):
    """CT-C07: GET /carrinhos/{id} existente retorna 200."""
    resp = api_session.get(
        f"{base_url}/carrinhos/{carrinho_cliente['id']}",
        headers=headers_cliente,
    )
    assert resp.status_code == 200


def test_ct_c10_consultar_carrinho_inexistente(api_session, base_url, headers_cliente):
    """CT-C10: GET /carrinhos/{id} inexistente retorna 400."""
    resp = api_session.get(
        f"{base_url}/carrinhos/0000000000000000",
        headers=headers_cliente,
    )
    assert resp.status_code == 400


def test_ct_c11_criar_carrinho_dados_invalidos(api_session, base_url, headers_cliente):
    """CT-C11: POST /carrinhos com dados inválidos retorna 400."""
    resp = api_session.post(
        f"{base_url}/carrinhos",
        json={"produtos": "invalido"},
        headers=headers_cliente,
    )
    assert resp.status_code == 400


def test_ct_c12_criar_carrinho_sem_auth(api_session, base_url):
    """CT-C12: POST /carrinhos sem autenticação retorna 401."""
    resp = api_session.post(
        f"{base_url}/carrinhos",
        json={"produtos": []},
    )
    assert resp.status_code == 401


def test_ct_c13_concluir_compra_sem_auth(api_session, base_url):
    """CT-C13: DELETE /carrinhos/concluir-compra sem autenticação retorna 401."""
    resp = api_session.delete(f"{base_url}/carrinhos/concluir-compra")
    assert resp.status_code == 401


def test_ct_c14_cancelar_compra_sem_auth(api_session, base_url):
    """CT-C14: DELETE /carrinhos/cancelar-compra sem autenticação retorna 401."""
    resp = api_session.delete(f"{base_url}/carrinhos/cancelar-compra")
    assert resp.status_code == 401


def test_ec_c01_consultar_usuario_id_limite(api_session, base_url, headers_cliente):
    """EC-C01: GET /usuarios/{id} com ID no limite/formato incomum."""
    resp = api_session.get(f"{base_url}/usuarios/0", headers=headers_cliente)
    assert resp.status_code in (200, 400)
    assert resp.status_code != 500


def test_ec_c02_consultar_produto_id_limite(api_session, base_url, headers_cliente):
    """EC-C02: GET /produtos/{id} com ID de valor limite."""
    resp = api_session.get(f"{base_url}/produtos/0", headers=headers_cliente)
    assert resp.status_code in (200, 400)
    assert resp.status_code != 500


def test_ec_c03_consultar_carrinho_id_limite(api_session, base_url, headers_cliente):
    """EC-C03: GET /carrinhos/{id} com ID de valor limite."""
    resp = api_session.get(f"{base_url}/carrinhos/0", headers=headers_cliente)
    assert resp.status_code in (200, 400)
    assert resp.status_code != 500


def test_ec_c04_criar_carrinho_quantidade_minima(
    api_session, base_url, headers_cliente, produto_admin
):
    """EC-C04: POST /carrinhos com quantidade mínima aplicável."""
    payload = {"produtos": [{"idProduto": produto_admin["id"], "quantidade": 1}]}
    resp = api_session.post(
        f"{base_url}/carrinhos",
        json=payload,
        headers=headers_cliente,
    )
    assert resp.status_code in (201, 400)
    assert resp.status_code != 500


def test_bug_hunt_nao_permite_dois_carrinhos_abertos(
    api_session, base_url, headers_cliente, produto_admin
):
    """Investigação: usuário não deveria conseguir ter 2 carrinhos abertos.

    Regra implícita de negócio: um usuário só pode ter um carrinho ativo
    por vez. Este teste cria um carrinho, depois tenta criar outro com o
    mesmo usuário. Esperado: o segundo POST retorna 400.
    """
    payload = {"produtos": [{"idProduto": produto_admin["id"], "quantidade": 1}]}

    resp1 = api_session.post(f"{base_url}/carrinhos", json=payload, headers=headers_cliente)
    assert resp1.status_code == 201

    resp2 = api_session.post(f"{base_url}/carrinhos", json=payload, headers=headers_cliente)

    assert resp2.status_code == 400, (
        f"Esperado 400 (usuário já tem carrinho aberto), "
        f"obtido {resp2.status_code}: {resp2.text}"
    )


@pytest.mark.xfail(
    reason="BUG-03 (confirmado manualmente): sistema permite concluir compra "
    "sem carrinho ativo, retornando 200 em vez de 400.",
    strict=False,
)
def test_bug03_concluir_compra_sem_carrinho_ativo(api_session, base_url, headers_cliente):
    """BUG-03: Erro de lógica ao concluir compra inexistente.

    Comportamento observado: o sistema permite concluir a compra mesmo
    quando não há carrinho ativo para o usuário.
    Resultado observado: 200 OK quando o esperado era 400 Bad Request.
    """
    resp = api_session.delete(f"{base_url}/carrinhos/concluir-compra", headers=headers_cliente)

    assert resp.status_code == 400, (
        f"Esperado 400 (não deveria ser possível concluir compra sem carrinho ativo), "
        f"obtido {resp.status_code}: {resp.text}"
    )