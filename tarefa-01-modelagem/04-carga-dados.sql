-- =============================================================================
-- Tarefa 1 (continuação) - CARGA INICIAL DE DADOS / DATA ENTRY
-- Laboratório Prático: SQL DML Avançado - Especial Copa do Mundo
--
-- Contexto: o banco foi criado com sucesso, mas está completamente vazio.
-- A diretoria da FIFA enviou as planilhas oficiais com 10 Seleções, 10 Clubes
-- e 10 Jogadores. A missão é fazer a carga inicial no sistema.
--
-- Tarefas do aluno atendidas neste script:
--   1) INSERT INTO para registrar todas as 10 Seleções
--   2) INSERT INTO para registrar todos os 10 Clubes
--   3) INSERT INTO para registrar os 10 Jogadores, respeitando os IDs
--   4) Desafio Bônus: inserir a si mesmo como jogador
--
-- Pré-requisito: executar antes o 03-modelo-fisico.sql
-- Execução: psql -U <usuario> -d <banco> -f 04-carga-dados.sql
-- =============================================================================
--
-- ATENÇÃO À REGRA DE NEGÓCIO (INTEGRIDADE REFERENCIAL)
-- "Qual tabela deve ser preenchida primeiro para que o banco não apresente um
--  erro de relacionamento?"
--
-- RESPOSTA: primeiro as tabelas REFERENCIADAS (selecoes e clubes), só depois a
-- tabela que REFERENCIA (jogadores).
--
-- O motivo: cada linha de jogadores carrega as chaves estrangeiras id_selecao e
-- id_clube. No momento do INSERT, o SGBD verifica se o valor informado existe na
-- tabela de destino. Se os jogadores fossem inseridos primeiro, o Vini Jr
-- apontaria para a seleção 10 e o clube 1, que ainda não existiriam, e o banco
-- recusaria a operação com o erro:
--     ERROR: insert or update on table "jogadores" violates foreign key
--            constraint "fk_jogadores_selecao"
--
-- Entre selecoes e clubes a ordem é indiferente: as duas são independentes entre
-- si. O que não pode é qualquer uma delas vir depois de jogadores.
-- =============================================================================

BEGIN;

-- Limpa as tabelas preservando a estrutura, para o script poder ser reexecutado.
-- TRUNCATE ... CASCADE respeita a ordem das dependências.
TRUNCATE TABLE jogadores, clubes, selecoes RESTART IDENTITY CASCADE;


-- #############################################################################
-- TAREFA 1) Planilha 1: Seleções (10 registros)
-- Tabela referenciada - precisa ser carregada antes de jogadores.
-- #############################################################################

INSERT INTO selecoes (id_selecao, pais, continente) VALUES
    ( 10, 'Brasil',     'América do Sul'),
    ( 20, 'Argentina',  'América do Sul'),
    ( 30, 'Uruguai',    'América do Sul'),
    ( 40, 'França',     'Europa'),
    ( 50, 'Inglaterra', 'Europa'),
    ( 60, 'Espanha',    'Europa'),
    ( 70, 'Alemanha',   'Europa'),
    ( 80, 'Itália',     'Europa'),
    ( 90, 'Portugal',   'Europa'),
    (100, 'Holanda',    'Europa');


-- #############################################################################
-- TAREFA 2) Planilha 2: Clubes (10 registros)
-- Também é tabela referenciada - carregada antes de jogadores.
-- #############################################################################

INSERT INTO clubes (id_clube, nome_clube, pais_sede) VALUES
    ( 1, 'Real Madrid',         'Espanha'),
    ( 2, 'Barcelona',           'Espanha'),
    ( 3, 'Manchester City',     'Inglaterra'),
    ( 4, 'Arsenal',             'Inglaterra'),
    ( 5, 'Bayern de Munique',   'Alemanha'),
    ( 6, 'Inter de Milão',      'Itália'),
    ( 7, 'Juventus',            'Itália'),
    ( 8, 'Paris Saint-Germain', 'França'),
    ( 9, 'Flamengo',            'Brasil'),
    (10, 'Palmeiras',           'Brasil');


-- #############################################################################
-- TAREFA 3) Planilha 3: Jogadores Convocados (10 registros)
-- Tabela dependente - carregada POR ÚLTIMO, quando as duas FKs já têm destino.
-- Os IDs de seleção e de clube da planilha são respeitados exatamente.
-- #############################################################################

INSERT INTO jogadores
    (id_jogador, nome, id_selecao, id_clube, posicao, gols_marcados, valor_mercado) VALUES
    (101, 'Vini Jr',          10,  1, 'Atacante',   5, 150.00),
    (102, 'Lionel Messi',     20,  8, 'Atacante',   7,  35.00),
    (103, 'Kylian Mbappé',    40,  1, 'Atacante',   8, 180.00),
    (104, 'Jude Bellingham',  50,  1, 'Meio-Campo', 4, 150.00),
    (105, 'Rodri',            60,  3, 'Meio-Campo', 2, 110.00),
    (106, 'Harry Kane',       50,  5, 'Atacante',   6, 110.00),
    (107, 'Arrascaeta',       30,  9, 'Meio-Campo', 1,  15.00),
    (108, 'Lautaro Martínez', 20,  6, 'Atacante',   3, 110.00),
    (109, 'Endrick',          10, 10, 'Atacante',   1,  55.00),
    (110, 'Rafael Leão',      90,  6, 'Atacante',   2,  90.00);


-- #############################################################################
-- TAREFA 4) DESAFIO BÔNUS: "Insira você mesmo no banco de dados!"
--
-- >>> PERSONALIZE A LINHA ABAIXO <<<
-- ID 111 está livre (a planilha vai até 110). Troque o nome, a seleção do
-- coração, o clube, a posição, os gols e o valor de mercado pelos seus.
--
--   id_selecao válidos: 10 Brasil | 20 Argentina | 30 Uruguai | 40 França
--                       50 Inglaterra | 60 Espanha | 70 Alemanha | 80 Itália
--                       90 Portugal | 100 Holanda
--   id_clube válidos:    1 Real Madrid | 2 Barcelona | 3 Manchester City
--                        4 Arsenal | 5 Bayern de Munique | 6 Inter de Milão
--                        7 Juventus | 8 Paris Saint-Germain | 9 Flamengo
--                       10 Palmeiras
--   posicao válidas:    Goleiro | Zagueiro | Lateral | Volante | Meio-Campo | Atacante
-- #############################################################################

INSERT INTO jogadores
    (id_jogador, nome, id_selecao, id_clube, posicao, gols_marcados, valor_mercado) VALUES
    (111, 'Seu Nome Aqui', 10, 9, 'Meio-Campo', 3, 250.00);


-- -----------------------------------------------------------------------------
-- Sincronização das sequências
-- Os ids vieram prontos da planilha, então os contadores das colunas IDENTITY
-- continuam em 1. Sem este ajuste, um futuro INSERT sem id explícito tentaria
-- usar o id 1 e violaria a chave primária.
-- -----------------------------------------------------------------------------
SELECT setval(pg_get_serial_sequence('selecoes',  'id_selecao'), MAX(id_selecao)) FROM selecoes;
SELECT setval(pg_get_serial_sequence('clubes',    'id_clube'),   MAX(id_clube))   FROM clubes;
SELECT setval(pg_get_serial_sequence('jogadores', 'id_jogador'), MAX(id_jogador)) FROM jogadores;

COMMIT;


-- -----------------------------------------------------------------------------
-- Conferência da carga
-- -----------------------------------------------------------------------------
\echo ''
\echo '### Registros carregados ###'

SELECT 'selecoes'   AS tabela, COUNT(*) AS registros FROM selecoes
UNION ALL
SELECT 'clubes',    COUNT(*) FROM clubes
UNION ALL
SELECT 'jogadores', COUNT(*) FROM jogadores;

\echo ''
\echo '### Elenco convocado (as três tabelas ligadas por JOIN) ###'

SELECT j.id_jogador                      AS "ID",
       j.nome                            AS "Jogador",
       s.pais                            AS "Seleção",
       c.nome_clube                      AS "Clube",
       j.posicao                         AS "Posição",
       j.gols_marcados                   AS "Gols",
       TO_CHAR(j.valor_mercado, 'FM999G990D00') AS "Valor (Mi €)"
FROM jogadores j
    INNER JOIN selecoes s ON s.id_selecao = j.id_selecao
    INNER JOIN clubes   c ON c.id_clube   = j.id_clube
ORDER BY j.id_jogador;
