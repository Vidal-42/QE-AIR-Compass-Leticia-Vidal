"""Testes de Usuários da API ServeRest."""

import uuid

import pytest


def test_ct_c02_listar_usuarios(api_session, base_url, headers_cliente):
    """CT-C02: GET /usuarios retorna 200 e lista de usuários."""
    resp = api_session.get(f"{base_url}/usuarios", headers=headers_cliente)
    assert resp.status_code == 200
    assert "usuarios" in resp.json()


def test_ct_c03_consultar_usuario_existente(api_session, base_url, headers_cliente, usuario_cliente):
    """CT-C03: GET /usuarios/{id} de usuário existente retorna 200."""
    resp = api_session.get(
        f"{base_url}/usuarios/{usuario_cliente['id']}",
        headers=headers_cliente,
    )
    assert resp.status_code == 200
    assert resp.json()["email"] == usuario_cliente["email"]


def test_ct_c09_consultar_usuario_inexistente(api_session, base_url, headers_cliente):
    """CT-C09: GET /usuarios/{id} inexistente retorna 400."""
    resp = api_session.get(
        f"{base_url}/usuarios/0000000000000000",
        headers=headers_cliente,
    )
    assert resp.status_code == 400


def test_ct_a02_listar_usuarios_admin(api_session, base_url, headers_admin):
    """CT-A02: GET /usuarios como admin retorna 200."""
    resp = api_session.get(f"{base_url}/usuarios", headers=headers_admin)
    assert resp.status_code == 200
    assert "usuarios" in resp.json()


def test_ct_a03_consultar_usuario_existente_admin(api_session, base_url, headers_admin, usuario_cliente):
    """CT-A03: GET /usuarios/{id} como admin retorna 200."""
    resp = api_session.get(
        f"{base_url}/usuarios/{usuario_cliente['id']}",
        headers=headers_admin,
    )
    assert resp.status_code == 200


def test_ct_a04_cadastrar_usuario_valido(api_session, base_url, headers_admin):
    """CT-A04: POST /usuarios com dados válidos retorna 201."""
    email = f"user_{uuid.uuid4().hex[:8]}@example.com"
    payload = {
        "nome": "Novo Usuario",
        "email": email,
        "password": "senha123",
        "administrador": "false",
    }
    resp = api_session.post(f"{base_url}/usuarios", json=payload, headers=headers_admin)
    assert resp.status_code == 201
    assert "_id" in resp.json()


def test_ct_a05_atualizar_usuario_existente(api_session, base_url, headers_admin, usuario_cliente):
    """CT-A05: PUT /usuarios/{id} retorna 200 e a mudança pode ser confirmada via GET.

    Observação: o PUT retorna apenas mensagem de confirmação, não o recurso
    atualizado. Por isso a validação do novo valor é feita via GET em seguida.
    """
    payload = {
        "nome": "Nome Atualizado",
        "email": usuario_cliente["email"],
        "password": usuario_cliente["password"],
        "administrador": usuario_cliente["administrador"],
    }
    resp = api_session.put(
        f"{base_url}/usuarios/{usuario_cliente['id']}",
        json=payload,
        headers=headers_admin,
    )
    assert resp.status_code == 200

    # Confirmação via GET
    resp_get = api_session.get(
        f"{base_url}/usuarios/{usuario_cliente['id']}",
        headers=headers_admin,
    )
    assert resp_get.status_code == 200
    assert resp_get.json()["nome"] == "Nome Atualizado"


def test_ct_a06_criar_usuario_via_put(api_session, base_url, headers_admin):
    """CT-A06: PUT /usuarios/{id} com id inexistente cria usuário (201)."""
    novo_id = uuid.uuid4().hex[:16]
    email = f"put_{uuid.uuid4().hex[:8]}@example.com"
    payload = {
        "nome": "Criado via PUT",
        "email": email,
        "password": "senha123",
        "administrador": "false",
    }
    resp = api_session.put(
        f"{base_url}/usuarios/{novo_id}",
        json=payload,
        headers=headers_admin,
    )
    assert resp.status_code == 201


def test_ct_a07_excluir_usuario_sem_carrinho(api_session, base_url, headers_admin, usuario_cliente):
    """CT-A07: DELETE /usuarios/{id} sem carrinho retorna 200."""
    resp = api_session.delete(
        f"{base_url}/usuarios/{usuario_cliente['id']}",
        headers=headers_admin,
    )
    assert resp.status_code == 200


def test_ct_a12_cadastrar_email_existente(api_session, base_url, headers_admin, usuario_cliente):
    """CT-A12: POST /usuarios com e-mail já cadastrado retorna 400."""
    payload = {
        "nome": "Duplicado",
        "email": usuario_cliente["email"],
        "password": "senha123",
        "administrador": "false",
    }
    resp = api_session.post(f"{base_url}/usuarios", json=payload, headers=headers_admin)
    assert resp.status_code == 400


def test_ct_a13_atualizar_email_existente(
    api_session, base_url, headers_admin, usuario_cliente, usuario_admin
):
    """CT-A13: PUT /usuarios/{id} com e-mail já cadastrado retorna 400."""
    payload = {
        "nome": usuario_cliente["nome"],
        "email": usuario_admin["email"],
        "password": usuario_cliente["password"],
        "administrador": usuario_cliente["administrador"],
    }
    resp = api_session.put(
        f"{base_url}/usuarios/{usuario_cliente['id']}",
        json=payload,
        headers=headers_admin,
    )
    assert resp.status_code == 400


def test_ct_a14_excluir_usuario_com_carrinho(
    api_session, base_url, headers_admin, usuario_cliente, carrinho_cliente
):
    """CT-A14: DELETE /usuarios/{id} com carrinho cadastrado retorna 400."""
    resp = api_session.delete(
        f"{base_url}/usuarios/{usuario_cliente['id']}",
        headers=headers_admin,
    )
    assert resp.status_code == 400


def test_ec_a01_cadastrar_usuario_limites(api_session, base_url, headers_admin):
    """EC-A01: POST /usuarios com dados nos limites definidos.

    Como o plano não especifica o status exato, validamos comportamento
    consistente (não pode dar 500).
    """
    email = f"limite_{uuid.uuid4().hex[:8]}@example.com"
    payload = {
        "nome": "A",
        "email": email,
        "password": "1",
        "administrador": "false",
    }
    resp = api_session.post(f"{base_url}/usuarios", json=payload, headers=headers_admin)
    assert resp.status_code in (201, 400)
    assert resp.status_code != 500


def test_ec_a02_consultar_usuario_id_extremo(api_session, base_url, headers_admin):
    """EC-A02: GET /usuarios/{id} com ID limite/extremo."""
    resp = api_session.get(f"{base_url}/usuarios/0", headers=headers_admin)
    assert resp.status_code in (200, 400)
    assert resp.status_code != 500


def test_bug_hunt_email_duplicado_case_insensitive(
    api_session, base_url, headers_admin, usuario_cliente
):
    """Investigação: e-mail duplicado ignorando caixa não deveria ser aceito.

    Regra do plano (seção 7): cadastro não deve permitir repetir e-mails
    já existentes. Este teste tenta cadastrar o mesmo e-mail de um usuário
    já existente, mas com grafia em MAIÚSCULAS. Esperado: 400 (conta como
    duplicado). Se a API aceitar (201), a validação de unicidade é
    case-sensitive quando não deveria ser — bug a reportar.
    """
    email_maiusculo = usuario_cliente["email"].upper()
    payload = {
        "nome": "Duplicado Case Insensitive",
        "email": email_maiusculo,
        "password": "senha123",
        "administrador": "false",
    }
    resp = api_session.post(f"{base_url}/usuarios", json=payload, headers=headers_admin)

    assert resp.status_code == 400, (
        f"Esperado 400 (e-mail duplicado ignorando caixa), "
        f"obtido {resp.status_code}: {resp.text}"
    )


@pytest.mark.xfail(
    reason="BUG-02 (confirmado manualmente): usuário comum consegue excluir "
    "registro de OUTRO usuário, retornando 200 em vez de 403 (IDOR).",
    strict=False,
)
def test_bug02_usuario_comum_nao_deveria_excluir_outro_usuario(
    api_session, base_url, headers_cliente, usuario_admin
):
    """BUG-02: Falha de autorização (IDOR) na exclusão de usuário.

    Comportamento observado: um usuário comum (não-admin) consegue excluir
    o registro de OUTRO usuário apenas informando o ID dele.
    Resultado observado: 200 OK quando o esperado era 403 Forbidden.
    """
    resp = api_session.delete(
        f"{base_url}/usuarios/{usuario_admin['id']}",
        headers=headers_cliente,
    )
    assert resp.status_code == 403, (
        f"Esperado 403 (usuário comum não deveria excluir conta de outro usuário), "
        f"obtido {resp.status_code}: {resp.text}"
    )