menu = '''
[d] Depositar
[s] Sacar
[e] Extrato
[q] Sair

=> '''

saldo = 0
limite = 500
extrato = ''
numero_saques = 0
LIMITE_SAQUES = 3

while True:
    opcao = input(menu)
    # Deposito
    if opcao == 'd':
        print('===== Depósito =====')
        valor = float(input('Valor do Depósito:'))
        if valor > 0:
            saldo += valor
            extrato += f'Depósito: R$ {valor:.2f}\n'
        else:
            print('Operação falhou! O valor informado é inválido!')
    # Saque
    elif opcao == 's':
        print('===== Saque =====')
        valor = float(input('Valor do Saque:'))
        if valor > 0:
            if valor < saldo:
                if valor <= limite:
                    if numero_saques < 3:
                        saldo -= valor
                        extrato += f'Saque - R$ {valor:.2f}\n'
                        numero_saques += 1
                    else:
                        print('Operação falhou! Número máximo de saques excedido.')
                else:
                    print('Operação falhou! O valor do saque excede o limite.')
            else:
                print('Operação falhou! Saldo Insuficiente!')
        else:
            print('Operação falhou! O valor informado é inválido!')
    # Extrato
    elif opcao == 'e':
        print('\n============= Extrato =============')
        print('Não foram realizadas movimentações.' if not extrato else extrato)
        print(f'\nSaldo: R$ {saldo:.2f}')
        print('===================================')
    # Sair
    elif opcao == 'q':
        break
    else:
        print('Operação falhou! Selecione uma operação.')
