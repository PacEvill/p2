/*
   TRABALHO FINAL - BANCO DE DADOS
   Aluno: [Seu Nome Aqui]
   Tema: Sistema de Controle de Produção - TechMaricá Indústria Eletrônica S.A.
*/

/*Básico para lidar com databases*/

DROP DATABASE IF EXISTS TechMarica_DB; -- exclui a base se existir
CREATE DATABASE TechMarica_DB; -- Cria uma base de dados
USE TechMarica_DB; -- usa uma database para modificar e cria sua estrutura

SHOW DATABASES; -- mostra as bases de dados no sistema

/* Criação das Tabelas */

CREATE TABLE funcionarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cargo VARCHAR(50) NOT NULL,
    setor VARCHAR(50),
    ativo TINYINT(1) DEFAULT 1, -- 1 = Ativo, 0 = Inativo
    data_admissao DATE NOT NULL
);

DESCRIBE funcionarios; -- Descrever uma tabela

CREATE TABLE maquinas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    codigo_patrimonio VARCHAR(20) NOT NULL UNIQUE,
    nome VARCHAR(50) NOT NULL,
    modelo VARCHAR(50),
    status ENUM('OPERACIONAL', 'MANUTENCAO', 'DESATIVADA') DEFAULT 'OPERACIONAL'
);

CREATE TABLE produtos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    codigo_interno VARCHAR(20) NOT NULL UNIQUE,
    nome_comercial VARCHAR(100) NOT NULL,
    custo_producao DECIMAL(10, 2) NOT NULL,
    id_responsavel_tecnico INT,
    data_criacao DATE NOT NULL,
    FOREIGN KEY (id_responsavel_tecnico) REFERENCES funcionarios(id)
);

CREATE TABLE ordens_producao (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_produto INT NOT NULL,
    id_maquina INT NOT NULL,
    id_funcionario_autorizou INT NOT NULL,
    data_inicio DATETIME DEFAULT CURRENT_TIMESTAMP,
    data_conclusao DATETIME,
    status ENUM('AGUARDANDO', 'EM PRODUÇÃO', 'FINALIZADA', 'CANCELADA') DEFAULT 'AGUARDANDO',
    quantidade_lote INT NOT NULL DEFAULT 100,
    FOREIGN KEY (id_produto) REFERENCES produtos(id),
    FOREIGN KEY (id_maquina) REFERENCES maquinas(id),
    FOREIGN KEY (id_funcionario_autorizou) REFERENCES funcionarios(id)
);

SHOW TABLES; -- Mostra se eu tenho uma tabela dentro de uma database

-- Modificar a estrutura da tabela - adicionar e remover
ALTER TABLE funcionarios ADD COLUMN email_corporativo VARCHAR(100);
ALTER TABLE funcionarios DROP COLUMN email_corporativo;


/* ----------------------------------------------------------------------------------- */
-- Inserts

-- Funcionários
INSERT INTO funcionarios (nome, cargo, setor, ativo, data_admissao) VALUES
('Carlos Silva', 'Engenheiro Chefe', 'Engenharia', 1, '2020-03-15'),
('Mariana Souza', 'Supervisora de Produção', 'Produção', 1, '2021-05-10'),
('Roberto Alves', 'Técnico de Manutenção', 'Manutenção', 1, '2019-08-20'),
('Fernanda Lima', 'Operadora de Máquinas', 'Produção', 0, '2022-01-10'), -- Inativa
('João Mendes', 'Gerente de Qualidade', 'Qualidade', 1, '2018-11-01'),
('Patrícia Rocha', 'Engenheira de Projetos', 'Engenharia', 1, '2023-02-15');

-- Máquinas
INSERT INTO maquinas (codigo_patrimonio, nome, modelo, status) VALUES
('MQ-001', 'Injetora Plástica', 'Inj-2000X', 'OPERACIONAL'),
('MQ-002', 'Montadora SMD', 'SMD-FastPick', 'OPERACIONAL'),
('MQ-003', 'Soldadora de Onda', 'Solder-Wave-50', 'MANUTENCAO'),
('MQ-004', 'Impressora 3D Industrial', 'Print-3D-Pro', 'OPERACIONAL'),
('MQ-005', 'Bancada de Teste Manual', 'Test-Bench-V1', 'DESATIVADA');

-- Produtos
INSERT INTO produtos (codigo_interno, nome_comercial, custo_producao, id_responsavel_tecnico, data_criacao) VALUES
('PROD-001', 'Sensor de Presença Inteligente', 45.50, 1, '2021-01-10'),
('PROD-002', 'Módulo Wi-Fi IoT', 28.90, 1, '2021-06-20'),
('PROD-003', 'Placa Controladora Universal', 120.00, 6, '2022-03-15'),
('PROD-004', 'Display LED 7 Segmentos', 15.00, 1, '2020-11-05'),
('PROD-005', 'Fonte Chaveada 12V', 35.75, 6, '2023-08-01');

-- Ordens de Produção
INSERT INTO ordens_producao (id_produto, id_maquina, id_funcionario_autorizou, data_inicio, data_conclusao, status, quantidade_lote) VALUES
(1, 2, 2, '2024-10-01 08:00:00', '2024-10-01 16:00:00', 'FINALIZADA', 500),
(2, 2, 2, '2024-10-02 09:00:00', NULL, 'EM PRODUÇÃO', 1000),
(3, 4, 5, '2024-10-03 10:30:00', '2024-10-03 14:30:00', 'FINALIZADA', 50),
(4, 2, 2, '2024-10-04 08:00:00', NULL, 'AGUARDANDO', 2000),
(5, 1, 5, '2024-10-05 13:00:00', NULL, 'CANCELADA', 300);

SELECT * FROM ordens_producao;

-- update
UPDATE funcionarios SET cargo = 'Gerente de Engenharia' WHERE id = 1;

-- Delete - > deletar dados da minha tabela
DELETE FROM ordens_producao WHERE id = 5;


/* ----------------------------------------------------------------------------------- */
-- Consultas

-- Filtragem de funcionários inativos
SELECT id, nome, cargo, setor 
FROM funcionarios 
WHERE ativo = 0;

-- LIKE
-- FILTRAR POR NOMES QUE COMECEM COM S
SELECT * 
FROM produtos 
WHERE nome_comercial LIKE 'S%';


/* JOINS
Os Joins Permitem unir dados de duas ou mais tabelas (relacionadas)
As chaves primárias(primary key) e estrangeiras(foreign key) são fundamentais para esse processo
*/

-- INNER JOIN
/* TRAZ APENAS OS REGISTROS QUE TÊM CORRESPONDÊNCIA EM AMBAS AS TABELAS */
SELECT 
    op.id AS 'ID Ordem',
    p.nome_comercial AS 'Produto',
    m.nome AS 'Máquina',
    f.nome AS 'Autorizado Por',
    op.data_inicio,
    op.status
FROM ordens_producao op
INNER JOIN produtos p ON op.id_produto = p.id
INNER JOIN maquinas m ON op.id_maquina = m.id
INNER JOIN funcionarios f ON op.id_funcionario_autorizou = f.id;

-- Left Join
/* Traz todos os registros da tabela da esquerda, e
os correspondentes da direita(se existirem)
*/
-- Máquinas que nunca foram usadas
SELECT 
    m.nome AS 'Máquina',
    m.status
FROM maquinas m
LEFT JOIN ordens_producao op ON m.id = op.id_maquina
WHERE op.id IS NULL;


/* ----------------------------------------------------------------------------------- */
/* Funções - Vão ajudar a fazer operações de forma simples e rápida */

-- COUNT -> Contar algo
-- Contagem de produtos por Responsável Técnico
SELECT 
    f.nome AS 'Responsável Técnico',
    COUNT(p.id) AS 'Qtd Produtos'
FROM funcionarios f
JOIN produtos p ON f.id = p.id_responsavel_tecnico
GROUP BY f.id, f.nome;

-- Média - AVG
SELECT AVG(custo_producao) AS 'Custo Médio de Produção' FROM produtos;

-- Funções de data
SELECT 
    nome_comercial,
    data_criacao,
    TIMESTAMPDIFF(YEAR, data_criacao, CURDATE()) AS 'Idade (Anos)'
FROM produtos;


/* ----------------------------------------------------------------------------------- */
/* Views */

CREATE OR REPLACE VIEW vw_producao_detalhada AS
SELECT 
    op.id AS id_ordem,
    p.nome_comercial AS produto,
    p.codigo_interno,
    m.nome AS maquina_utilizada,
    f.nome AS responsavel_autorizacao,
    op.status,
    op.data_inicio,
    op.quantidade_lote
FROM ordens_producao op
INNER JOIN produtos p ON op.id_produto = p.id
INNER JOIN maquinas m ON op.id_maquina = m.id
INNER JOIN funcionarios f ON op.id_funcionario_autorizou = f.id;

SELECT * FROM vw_producao_detalhada;


/* ----------------------------------------------------------------------------------- */
/*Stored Procedure*/

/* É um conjunto de comandos SQL
armazenados no servidor de banco de
dados.

Ela é criada uma vez e poder ser
executada várias vezes, facilitando
a automação.
*/

DELIMITER $$

CREATE PROCEDURE sp_registrar_ordem(
    IN p_id_produto INT,
    IN p_id_funcionario INT,
    IN p_id_maquina INT,
    IN p_quantidade INT
)
BEGIN
    INSERT INTO ordens_producao (id_produto, id_maquina, id_funcionario_autorizou, data_inicio, status, quantidade_lote)
    VALUES (p_id_produto, p_id_maquina, p_id_funcionario, NOW(), 'EM PRODUÇÃO', p_quantidade);
    
    SELECT 'Ordem de produção registrada com sucesso!' AS Mensagem;
END $$

DELIMITER ;

CALL sp_registrar_ordem(1, 2, 1, 100);


/* ----------------------------------------------------------------------------------- */
/*Trigger*/

/*
Um trigger é um bloco de código
SQL que é executado automaticamente
pelo banco de dados quando ocorre
um determinado evento(INSERT,
UPDATE ou DELETE) em uma tabela.
*/

DELIMITER $$

CREATE TRIGGER trg_atualiza_status_conclusao
BEFORE UPDATE ON ordens_producao
FOR EACH ROW
BEGIN
    -- Se a data de conclusão era NULL e agora está sendo preenchida
    IF OLD.data_conclusao IS NULL AND NEW.data_conclusao IS NOT NULL THEN
        SET NEW.status = 'FINALIZADA';
    END IF;
END $$

DELIMITER ;

SHOW TRIGGERS;

-- Testando o Trigger
UPDATE ordens_producao 
SET data_conclusao = NOW() 
WHERE id = (SELECT MAX(id) FROM (SELECT id FROM ordens_producao) AS temp);

SELECT * FROM ordens_producao ORDER BY id DESC LIMIT 1;
