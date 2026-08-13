-- =============================================================================
-- Exercício Prático: Banco de Dados - Controle de Inventário de Laboratórios
--
-- PARTE 3 - MANIPULAÇÃO DE DADOS (DML)
-- "Escreva e execute os seguintes comandos SQL em ordem."
--
-- Itens 4 a 8 do enunciado, na ordem pedida:
--   4) INSERT - 2 laboratórios
--   5) INSERT - 3 equipamentos
--   6) SELECT - o desafio: consulta com JOIN
--   7) UPDATE - transferir um equipamento de laboratório
--   8) DELETE - descartar um equipamento
--
-- Pré-requisito: executar antes o 03-modelo-fisico.sql
-- Execução: psql -U <usuario> -d <banco> -f 04-manipulacao-dados.sql
-- =============================================================================


-- #############################################################################
-- ITEM 4) INSERT: cadastre 2 laboratórios diferentes.
-- #############################################################################

INSERT INTO laboratorios (id_laboratorio, nome, bloco) VALUES
    (1, 'Lab. de Redes',    'Bloco A'),
    (2, 'Lab. de Hardware', 'Bloco B');


-- #############################################################################
-- ITEM 5) INSERT: cadastre 3 equipamentos, vinculando dois deles ao primeiro
--         laboratório e o terceiro equipamento ao segundo laboratório.
--
--         O vínculo é feito pela chave estrangeira id_laboratorio.
-- #############################################################################

INSERT INTO equipamentos (id_equipamento, nome, patrimonio, id_laboratorio) VALUES
    (1, 'Roteador Cisco 2901',        'PAT-1234', 1),  -- 1o laboratório
    (2, 'Switch Gerenciável 24P',     'PAT-1235', 1),  -- 1o laboratório
    (3, 'Osciloscópio Tektronix',     'PAT-2001', 2);  -- 2o laboratório

-- Sincroniza os contadores das colunas IDENTITY. Como os ids foram informados
-- manualmente (para deixar o vínculo da FK legível), as sequências continuam
-- em 1 e o próximo INSERT sem id explícito violaria a chave primária.
SELECT setval(pg_get_serial_sequence('laboratorios', 'id_laboratorio'), MAX(id_laboratorio)) FROM laboratorios;
SELECT setval(pg_get_serial_sequence('equipamentos', 'id_equipamento'), MAX(id_equipamento)) FROM equipamentos;


-- #############################################################################
-- ITEM 6) SELECT (O DESAFIO): consulta usando JOIN que retorne uma lista
--         mostrando o Nome do Equipamento, o seu Patrimônio e o Nome do
--         Laboratório onde ele está.
--
--         O JOIN liga a FK equipamentos.id_laboratorio à PK
--         laboratorios.id_laboratorio. É essa ligação que traz, para a mesma
--         linha, dados que estão fisicamente em duas tabelas diferentes.
-- #############################################################################

\echo ''
\echo '### ITEM 6 - Inventário completo (JOIN) ###'

SELECT e.nome        AS "Equipamento",
       e.patrimonio  AS "Patrimônio",
       l.nome        AS "Laboratório"
FROM equipamentos e
    INNER JOIN laboratorios l ON l.id_laboratorio = e.id_laboratorio
ORDER BY l.nome, e.nome;


-- #############################################################################
-- ITEM 7) UPDATE: houve uma mudança! Transfira um dos equipamentos do primeiro
--         laboratório para o segundo laboratório.
--
--         Transferir de sala = trocar o valor da chave estrangeira. Nenhum outro
--         dado do equipamento precisa ser alterado.
--         O WHERE é obrigatório: sem ele, TODOS os equipamentos seriam movidos.
-- #############################################################################

UPDATE equipamentos
SET    id_laboratorio = 2               -- destino: Lab. de Hardware
WHERE  id_equipamento = 2;              -- Switch Gerenciável 24P, que estava no Lab. de Redes

\echo ''
\echo '### ITEM 7 - Conferência: situação após a transferência ###'

SELECT e.nome        AS "Equipamento",
       e.patrimonio  AS "Patrimônio",
       l.nome        AS "Laboratório"
FROM equipamentos e
    INNER JOIN laboratorios l ON l.id_laboratorio = e.id_laboratorio
ORDER BY l.nome, e.nome;


-- #############################################################################
-- ITEM 8) DELETE: um equipamento quebrou e foi para o descarte. Apague o
--         registro de um equipamento do sistema.
--
--         Aqui também o WHERE é indispensável: um DELETE sem WHERE esvaziaria
--         a tabela inteira.
-- #############################################################################

DELETE FROM equipamentos
WHERE  id_equipamento = 3;              -- Osciloscópio Tektronix (PAT-2001), quebrado

\echo ''
\echo '### ITEM 8 - Inventário final, após o descarte ###'

SELECT e.nome        AS "Equipamento",
       e.patrimonio  AS "Patrimônio",
       l.nome        AS "Laboratório"
FROM equipamentos e
    INNER JOIN laboratorios l ON l.id_laboratorio = e.id_laboratorio
ORDER BY l.nome, e.nome;

\echo ''
\echo '### Extra: total de equipamentos por laboratório ###'

-- LEFT JOIN para o Lab. de Redes aparecer mesmo tendo ficado sem equipamentos.
SELECT l.nome                  AS "Laboratório",
       l.bloco                 AS "Bloco",
       COUNT(e.id_equipamento) AS "Qtd. equipamentos"
FROM laboratorios l
    LEFT JOIN equipamentos e ON e.id_laboratorio = l.id_laboratorio
GROUP BY l.id_laboratorio, l.nome, l.bloco
ORDER BY l.nome;
