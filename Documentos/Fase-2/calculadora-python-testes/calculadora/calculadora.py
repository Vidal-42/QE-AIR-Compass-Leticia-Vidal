class Calculadora:

    @staticmethod
    def _validar_numeros(*numeros):
        # Centralizei a validação para evitar repetição nas operações.
        # Se a regra mudar no futuro, altero apenas aqui.
        for numero in numeros:

            # bool é subclasse de int em Python.
            # Se não bloquear, True vira 1 silenciosamente.
            if isinstance(numero, bool):
                raise TypeError("Valores booleanos (True ou False) não são permitidos.")

            if not isinstance(numero, (int, float)):
                raise TypeError("Todos os valores devem ser numéricos.")

    def somar(self, a, b):
        self._validar_numeros(a, b)
        return a + b

    def subtrair(self, a, b):
        # Mantive padrão binário por consistência.
        self._validar_numeros(a, b)
        return a - b

    def multiplicar(self, a, b):
        self._validar_numeros(a, b)
        return a * b

    def divisao(self, a, b):
        self._validar_numeros(a, b)

        if b == 0:
            raise ValueError("Divisão por zero não é permitida.")

        return a / b

    def potencia(self, a, b):
        self._validar_numeros(a, b)

        # Evita caso matematicamente inválido: 0 elevado a negativo
        if a == 0 and b < 0:
            raise ValueError("Zero não pode ter expoente negativo.")

        return a ** b

    def raiz_quadrada(self, a):
        self._validar_numeros(a)

        if a < 0:
            raise ValueError("Não é possível calcular raiz de número negativo.")

        # Raiz quadrada correta é potência 1/2
        return a ** 0.5