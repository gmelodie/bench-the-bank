# Bench The Bank
Site de banco utilizado em uma atividade de ataque e defesa da frente de WEB do Ganesh.

A ideia da atividade é que cada grupo desenvolva uma aplicação com funcionalidades semelhantes, e que o grupo tente encontrar vulnerabilidades nas aplicações dos demais grupos.

## Requisitos
- A tecnologia web empregada fica a critério do grupo.
- Os grupos terão o código fonte dos sistemas explorados, que ficarão no github.
- As funcionalidades definidas são o mínimo a ser implementadas, fica a critério do grupo adicionar mais.
- Durante a atividade, anote as vulnerabilidades encontradas e como explorá-las (se possível, sugestões para mitigar o problema) para que o grupo desenvolvedor possa enteder o que fizeram e possam melhorar sua aplicação.

## Funcionalidades
- login/cadastro
- transferencia de dinheiro entre contas
- deposito e retirada de dinehiro
- extrato
- contas começam com um valor minimo

- conta de usuário: 
  - Pode transferir seu dinheiro para outro usuario/conta
  - Pode retirar seu dinheiro (seria como se tivesse tirado num ATM, o dinheiro sai do sistema) conta adm/caixa
  - Pode depositar dinheiro na conta de um usuario
  - Pode retirar dinheiro da conta de um usuario

## Banco de dados
### Usuário
- Número da conta [name=PK]
- Nome completo [name=Not Null]
- CPF [name=Unique] [name=Not Null]
- Data de nascimento [name=Not Null]
- Telefone [name=Not Null]
- E-mail [name=Unique] [name=Not Null]
- Senha Web: [name=Constraints] [name=Not Null]
- Senha de operações (numérica): 6 números [name=Not Null]

### Conta
- Número [name=PK] [name=FK]
- Tipo de conta [name=PK]
    - Poupança
    - Corrente
    - Salário
- Saldo [name=Default = 0]

### Transação (transactions)
- Número conta origem [name=PK] [name=FK1]
- Tipo conta origem [name=FK1] [name=Not Null]
- Número conta destino [name=FK2]
- Tipo conta destino [name=FK2]
- Timestamp [name=PK]
- Tipo da transação [name=Not Null]
    - Depósito 0
    - Retirada 1
    - Transferência 2
    > [name=Constraints]
    > check tipo == 0 and dest is not null  
    > or tipo == 1 and dest is null
- Valor [name=Not Null]

### [MER](https://drive.google.com/file/d/1MDul5qTg7ZddBJvFk6RwvMLfQsnGimEa/view?usp=sharing)
![image](https://i.imgur.com/9WiDxof.png)

## Sugestões:  
- [ ] Todos os grupos utilizarem o mesmo banco de dados.  
- [ ] API para TED
