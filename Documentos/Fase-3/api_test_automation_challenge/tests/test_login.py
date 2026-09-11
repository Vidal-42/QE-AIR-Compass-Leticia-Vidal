"""Testes de Login da API ServeRest."""


def test_ct_c01_login_cliente_valido(api_session, base_url, usuario_cliente):
    """CT-C01: Login com credenciais válidas de cliente.

    Entrada: usuario_cliente.
    Asserção: status 200 + presença de 'authorization'.
    """
    resp = api_session.post(
        f"{base_url}/login",
        json={
            "email": usuario_cliente["email"],
            "password": usuario_cliente["password"],
        },
    )
    assert resp.status_code == 200
    assert "authorization" in resp.json()


def test_ct_c08_login_invalido(api_session, base_url, usuario_cliente):
    """CT-C08: Login com e-mail ou senha inválidos.

    Entrada: usuario_cliente com senha incorreta.
    Asserção: status 401.
    """
    resp = api_session.post(
        f"{base_url}/login",
        json={
            "email": usuario_cliente["email"],
            "password": "senha_incorreta",
        },
    )
    assert resp.status_code == 401


def test_ct_a01_login_admin_valido(api_session, base_url, usuario_admin):
    """CT-A01: Login com credenciais válidas de administrador.

    Entrada: usuario_admin.
    Asserção: status 200 + 'authorization'.
    """
    resp = api_session.post(
        f"{base_url}/login",
        json={
            "email": usuario_admin["email"],
            "password": usuario_admin["password"],
        },
    )
    assert resp.status_code == 200
    assert "authorization" in resp.json()