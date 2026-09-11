import pytest
import requests
import uuid

BASE_URL = "https://compassuol.serverest.dev"


@pytest.fixture(scope="session")
def base_url():
    """URL base da API ServeRest."""
    return BASE_URL


@pytest.fixture(scope="session")
def api_session():
    """Sessão HTTP reutilizável para todos os testes."""
    session = requests.Session()
    session.headers.update({"Content-Type": "application/json"})
    yield session
    session.close()


def _unique_email(prefix: str) -> str:
    """Gera um e-mail único com o prefixo indicado."""
    return f"{prefix}_{uuid.uuid4().hex[:8]}@example.com"


def _create_user(session, base_url, administrador=False):
    """Cria um usuário via POST /usuarios e retorna seus dados."""
    nome = "Admin Teste" if administrador else "Cliente Teste"
    email = _unique_email("admin" if administrador else "cliente")
    password = "senha123"
    adm_str = "true" if administrador else "false"

    payload = {
        "nome": nome,
        "email": email,
        "password": password,
        "administrador": adm_str,
    }
    resp = session.post(f"{base_url}/usuarios", json=payload)
    assert resp.status_code == 201, f"Falha ao criar usuário: {resp.status_code} {resp.text}"
    data = resp.json()
    return {
        "id": data["_id"],
        "nome": nome,
        "email": email,
        "password": password,
        "administrador": adm_str,
    }


@pytest.fixture
def usuario_cliente(api_session, base_url):
    """Cria um usuário cliente válido."""
    return _create_user(api_session, base_url, administrador=False)


@pytest.fixture
def usuario_admin(api_session, base_url):
    """Cria um usuário administrador válido."""
    return _create_user(api_session, base_url, administrador=True)


def _login(session, base_url, email, password):
    """Realiza login e retorna o token de autorização."""
    resp = session.post(
        f"{base_url}/login",
        json={"email": email, "password": password},
    )
    assert resp.status_code == 200, f"Login falhou: {resp.status_code} {resp.text}"
    token = resp.json().get("authorization")
    assert token, "Token não retornado no login"
    return token


@pytest.fixture
def token_cliente(api_session, base_url, usuario_cliente):
    """Token de autenticação do usuário cliente."""
    return _login(api_session, base_url, usuario_cliente["email"], usuario_cliente["password"])


@pytest.fixture
def token_admin(api_session, base_url, usuario_admin):
    """Token de autenticação do usuário administrador."""
    return _login(api_session, base_url, usuario_admin["email"], usuario_admin["password"])


@pytest.fixture
def headers_cliente(token_cliente):
    """Headers com token do cliente."""
    return {"Authorization": token_cliente}


@pytest.fixture
def headers_admin(token_admin):
    """Headers com token do administrador."""
    return {"Authorization": token_admin}


@pytest.fixture
def produto_admin(api_session, base_url, headers_admin):
    """Cria um produto válido usando perfil administrador."""
    nome = f"Produto_{uuid.uuid4().hex[:8]}"
    payload = {
        "nome": nome,
        "preco": 100,
        "descricao": "Produto de teste",
        "quantidade": 10,
    }
    resp = api_session.post(f"{base_url}/produtos", json=payload, headers=headers_admin)
    assert resp.status_code == 201, f"Falha ao criar produto: {resp.status_code} {resp.text}"
    data = resp.json()
    return {
        "id": data["_id"],
        "nome": nome,
        "preco": 100,
        "descricao": "Produto de teste",
        "quantidade": 10,
    }


@pytest.fixture
def carrinho_cliente(api_session, base_url, headers_cliente, produto_admin):
    """Cria um carrinho válido para o cliente autenticado."""
    payload = {"produtos": [{"idProduto": produto_admin["id"], "quantidade": 1}]}
    resp = api_session.post(f"{base_url}/carrinhos", json=payload, headers=headers_cliente)
    assert resp.status_code == 201, f"Falha ao criar carrinho: {resp.status_code} {resp.text}"
    data = resp.json()
    return {"id": data["_id"]}