import pytest
from calculadora import Calculadora


@pytest.fixture
def calculadora():
    # Classe não mantém estado, mas uso fixture por padrão profissional.
    return Calculadora()


# =========================
# SOMA
# =========================

@pytest.mark.parametrize("a, b, resultado", [
    (1, 2, 3),
    (-1, 1, 0),
    (2.5, 2.5, 5.0),
])
def test_somar_casos_validos(calculadora, a, b, resultado):
    assert calculadora.somar(a, b) == resultado


@pytest.mark.parametrize("a, b", [
    (1, "2"),
    (None, 2),
    (True, 2),
])
def test_somar_type_error(calculadora, a, b):
    with pytest.raises(TypeError):
        calculadora.somar(a, b)


# =========================
# SUBTRAÇÃO
# =========================

@pytest.mark.parametrize("a, b, resultado", [
    (10, 5, 5),
    (5, 10, -5),
    (-5, -5, 0),
])
def test_subtrair_casos_validos(calculadora, a, b, resultado):
    assert calculadora.subtrair(a, b) == resultado


@pytest.mark.parametrize("a, b", [
    ("10", 5),
    (None, 5),
    (False, 3),
])
def test_subtrair_type_error(calculadora, a, b):
    with pytest.raises(TypeError):
        calculadora.subtrair(a, b)


# =========================
# MULTIPLICAÇÃO
# =========================

@pytest.mark.parametrize("a, b, resultado", [
    (2, 3, 6),
    (10, 0, 0),
    (1.5, 2, 3.0),
])
def test_multiplicar_casos_validos(calculadora, a, b, resultado):
    assert calculadora.multiplicar(a, b) == resultado


@pytest.mark.parametrize("a, b", [
    (2, "3"),
    (None, 4),
    (True, 5),
])
def test_multiplicar_type_error(calculadora, a, b):
    with pytest.raises(TypeError):
        calculadora.multiplicar(a, b)


# =========================
# DIVISÃO
# =========================

@pytest.mark.parametrize("a, b, resultado", [
    (10, 2, 5),
    (13, 2, 6.5),
    (-10, 2, -5),
])
def test_divisao_casos_validos(calculadora, a, b, resultado):
    assert calculadora.divisao(a, b) == resultado


def test_divisao_precisao_float(calculadora):
    resultado = calculadora.divisao(1, 3)
    assert resultado == pytest.approx(0.333333333, rel=1e-9)


@pytest.mark.parametrize("a, b", [
    (10, "2"),
    (None, 2),
    (False, 2),
])
def test_divisao_type_error(calculadora, a, b):
    with pytest.raises(TypeError):
        calculadora.divisao(a, b)


def test_divisao_por_zero(calculadora):
    with pytest.raises(ValueError):
        calculadora.divisao(10, 0)


# =========================
# POTÊNCIA
# =========================

@pytest.mark.parametrize("a, b, resultado", [
    (2, 3, 8),
    (5, 0, 1),
    (4, 0.5, 2.0),
])
def test_potencia_casos_validos(calculadora, a, b, resultado):
    assert calculadora.potencia(a, b) == resultado


@pytest.mark.parametrize("a, b", [
    (2, "3"),
    (None, 2),
    (True, 3),
])
def test_potencia_type_error(calculadora, a, b):
    with pytest.raises(TypeError):
        calculadora.potencia(a, b)


def test_potencia_zero_expoente_negativo(calculadora):
    with pytest.raises(ValueError):
        calculadora.potencia(0, -1)


# =========================
# RAIZ QUADRADA
# =========================

@pytest.mark.parametrize("a, resultado", [
    (4, 2),
    (9, 3),
    (2.25, 1.5),
])
def test_raiz_quadrada_casos_validos(calculadora, a, resultado):
    assert calculadora.raiz_quadrada(a) == pytest.approx(resultado)


@pytest.mark.parametrize("a", [
    -4,
    "9",
    True,
])
def test_raiz_quadrada_erros(calculadora, a):
    if isinstance(a, (int, float)) and a < 0:
        with pytest.raises(ValueError):
            calculadora.raiz_quadrada(a)
    else:
        with pytest.raises(TypeError):
            calculadora.raiz_quadrada(a)