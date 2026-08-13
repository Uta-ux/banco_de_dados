-- =============================================================================
-- Tarefa 1 - Modelo Conceitual, Lógico e Físico
-- Laboratório Prático: SQL DML Avançado - Especial Copa do Mundo
--
-- CARGA DE DADOS - script DML (Data Manipulation Language)
-- Complemento da tarefa: popula o modelo físico para que ele possa ser testado
-- e para servir de base aos relatórios das próximas etapas do laboratório.
--
-- Pré-requisito: executar antes o 03-modelo-fisico.sql
-- Execução: psql -U <usuario> -d <banco> -f 04-carga-dados.sql
--
-- IMPORTANTE: os nomes de seleções, clubes e atletas são reais, mas os valores
-- de gols_marcados, valor_mercado e os vínculos jogador-clube são FICTÍCIOS,
-- criados apenas para o exercício. Não use estes dados como fonte estatística.
-- =============================================================================

BEGIN;

-- Limpa as tabelas preservando a estrutura. TRUNCATE ... CASCADE respeita a
-- ordem das dependências; RESTART IDENTITY reinicia os contadores das PKs.
TRUNCATE TABLE jogadores, clubes, selecoes RESTART IDENTITY CASCADE;

-- -----------------------------------------------------------------------------
-- Seleções participantes (8)
-- -----------------------------------------------------------------------------
INSERT INTO selecoes (id_selecao, pais, continente) VALUES
    (1, 'Brasil',          'América do Sul'),
    (2, 'Argentina',       'América do Sul'),
    (3, 'França',          'Europa'),
    (4, 'Inglaterra',      'Europa'),
    (5, 'Portugal',        'Europa'),
    (6, 'Marrocos',        'África'),
    (7, 'Japão',           'Ásia'),
    (8, 'Estados Unidos',  'América do Norte');

-- -----------------------------------------------------------------------------
-- Clubes de origem dos atletas (22)
-- -----------------------------------------------------------------------------
INSERT INTO clubes (id_clube, nome_clube, pais_sede) VALUES
    ( 1, 'Real Madrid',              'Espanha'),
    ( 2, 'FC Barcelona',             'Espanha'),
    ( 3, 'Atlético de Madrid',       'Espanha'),
    ( 4, 'Real Sociedad',            'Espanha'),
    ( 5, 'Manchester City',          'Inglaterra'),
    ( 6, 'Liverpool',                'Inglaterra'),
    ( 7, 'Arsenal',                  'Inglaterra'),
    ( 8, 'Chelsea',                  'Inglaterra'),
    ( 9, 'Aston Villa',              'Inglaterra'),
    (10, 'Brighton & Hove Albion',   'Inglaterra'),
    (11, 'Paris Saint-Germain',      'França'),
    (12, 'AS Monaco',                'França'),
    (13, 'Bayern de Munique',        'Alemanha'),
    (14, 'Bayer Leverkusen',         'Alemanha'),
    (15, 'Inter de Milão',           'Itália'),
    (16, 'AC Milan',                 'Itália'),
    (17, 'Juventus',                 'Itália'),
    (18, 'Al-Nassr',                 'Arábia Saudita'),
    (19, 'Al-Hilal',                 'Arábia Saudita'),
    (20, 'Flamengo',                 'Brasil'),
    (21, 'Palmeiras',                'Brasil'),
    (22, 'Inter Miami',              'Estados Unidos');

-- -----------------------------------------------------------------------------
-- Jogadores (32) - 4 por seleção
-- Colunas: nome, seleção, clube, posição, gols na competição, valor de mercado
-- -----------------------------------------------------------------------------
INSERT INTO jogadores
    (id_jogador, nome, id_selecao, id_clube, posicao, gols_marcados, valor_mercado) VALUES
    -- Brasil
    ( 1, 'Alisson Becker',          1,  6, 'Goleiro',  0,  35000000.00),
    ( 2, 'Marquinhos',              1, 11, 'Zagueiro', 1,  45000000.00),
    ( 3, 'Vinícius Júnior',         1,  1, 'Atacante', 5, 180000000.00),
    ( 4, 'Raphinha',                1,  2, 'Atacante', 4,  90000000.00),
    -- Argentina
    ( 5, 'Emiliano Martínez',       2,  9, 'Goleiro',  0,  28000000.00),
    ( 6, 'Lionel Messi',            2, 22, 'Atacante', 6,  30000000.00),
    ( 7, 'Lautaro Martínez',        2, 15, 'Atacante', 3, 100000000.00),
    ( 8, 'Enzo Fernández',          2,  8, 'Meia',     2,  75000000.00),
    -- França
    ( 9, 'Kylian Mbappé',           3,  1, 'Atacante', 7, 175000000.00),
    (10, 'Ousmane Dembélé',         3, 11, 'Atacante', 3,  70000000.00),
    (11, 'Aurélien Tchouaméni',     3,  1, 'Volante',  1,  80000000.00),
    (12, 'William Saliba',          3,  7, 'Zagueiro', 0,  80000000.00),
    -- Inglaterra
    (13, 'Harry Kane',              4, 13, 'Atacante', 6, 100000000.00),
    (14, 'Jude Bellingham',         4,  1, 'Meia',     4, 180000000.00),
    (15, 'Declan Rice',             4,  7, 'Volante',  1, 110000000.00),
    (16, 'Trent Alexander-Arnold',  4,  1, 'Lateral',  0,  70000000.00),
    -- Portugal
    (17, 'Cristiano Ronaldo',       5, 18, 'Atacante', 2,  15000000.00),
    (18, 'Vitinha',                 5, 11, 'Meia',     2,  70000000.00),
    (19, 'Nuno Mendes',             5, 11, 'Lateral',  1,  65000000.00),
    (20, 'Rúben Dias',              5,  5, 'Zagueiro', 0,  75000000.00),
    -- Marrocos
    (21, 'Yassine Bounou',          6, 19, 'Goleiro',  0,  12000000.00),
    (22, 'Achraf Hakimi',           6, 11, 'Lateral',  2,  60000000.00),
    (23, 'Brahim Díaz',             6,  1, 'Meia',     3,  55000000.00),
    (24, 'Amine Adli',              6, 14, 'Atacante', 1,  25000000.00),
    -- Japão
    (25, 'Wataru Endo',             7,  6, 'Volante',  0,   8000000.00),
    (26, 'Takefusa Kubo',           7,  4, 'Meia',     2,  60000000.00),
    (27, 'Kaoru Mitoma',            7, 10, 'Atacante', 3,  45000000.00),
    (28, 'Takumi Minamino',         7, 12, 'Meia',     1,  18000000.00),
    -- Estados Unidos
    (29, 'Christian Pulisic',       8, 16, 'Atacante', 4,  55000000.00),
    (30, 'Weston McKennie',         8, 17, 'Volante',  1,  22000000.00),
    (31, 'Matt Turner',             8,  7, 'Goleiro',  0,   6000000.00),
    (32, 'Yunus Musah',             8, 16, 'Meia',     0,  25000000.00);

-- -----------------------------------------------------------------------------
-- Sincronização das sequências
-- Como os ids foram informados manualmente (para deixar as FKs legíveis), os
-- contadores das colunas IDENTITY continuam em 1. Sem este ajuste, o próximo
-- INSERT sem id explícito violaria a chave primária.
-- -----------------------------------------------------------------------------
SELECT setval(pg_get_serial_sequence('selecoes',  'id_selecao'), MAX(id_selecao))  FROM selecoes;
SELECT setval(pg_get_serial_sequence('clubes',    'id_clube'),   MAX(id_clube))    FROM clubes;
SELECT setval(pg_get_serial_sequence('jogadores', 'id_jogador'), MAX(id_jogador))  FROM jogadores;

COMMIT;
