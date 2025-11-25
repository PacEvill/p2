# TechMaricá - Sistema de Controle de Produção

Este repositório contém o script SQL para o banco de dados da **TechMaricá Indústria Eletrônica S.A.**, desenvolvido como parte do Trabalho Final de Banco de Dados.

## Estrutura do Banco de Dados

O script `TechMarica_Producao.sql` cria o banco de dados `TechMarica_DB` e as seguintes tabelas:

- **funcionarios**: Cadastro de funcionários, cargos e setores.
- **maquinas**: Registro de máquinas e status operacional.
- **produtos**: Catálogo de produtos e custos.
- **ordens_producao**: Controle de ordens de produção, relacionando produtos, máquinas e funcionários.

## Funcionalidades Incluídas

- Criação de tabelas com relacionamentos (Foreign Keys).
- Inserção de dados fictícios para testes.
- Consultas SQL (SELECT, JOINs, COUNT, AVG).
- Views (`vw_producao_detalhada`).
- Stored Procedures (`sp_registrar_ordem`).
- Triggers (`trg_atualiza_status_conclusao`).

## Como Usar

1. Importe o arquivo `TechMarica_Producao.sql` no seu SGBD (MySQL/MariaDB).
2. Execute o script para criar o banco e popular as tabelas.
