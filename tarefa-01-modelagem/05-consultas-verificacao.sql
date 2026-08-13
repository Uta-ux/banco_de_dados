-- =============================================================================
-- Tarefa 1 - Modelo Conceitual, Lógico e Físico
-- Laboratório Prático: SQL DML Avançado - Especial Copa do Mundo
--
-- CONSULTAS DE VERIFICAÇÃO
-- Provam que o modelo físico foi criado corretamente e que as restrições de
-- integridade realmente funcionam.
--
-- Pré-requisito: 03-modelo-fisico.sql e 04-carga-dados.sql já executados
-- Execução: psql -U <usuario> -d <banco> -f 05-consultas-verificacao.sql
-- =============================================================================

\echo '=== 1) Volume de registros carregados ==='
SELECT 'selecoes'  AS tabela, COUNT(*) AS registros FROM selecoes
UNION ALL
SELECT 'clubes',   COUNT(*) FROM clubes
UNION ALL
SELECT 'jogadores', COUNT(*) FROM jogadores;

\echo '=== 2) Junção das três tabelas (elenco completo, amostra) ==='
SELECT j.nome        AS jogador,
       s.pais        AS selecao,
       s.continente,
       c.nome_clube  AS clube,
       c.pais_sede,
       j.posicao,
       j.gols_marcados
FROM jogadores j
    INNER JOIN selecoes s ON s.id_selecao = j.id_selecao
    INNER JOIN clubes   c ON c.id_clube   = j.id_clube
ORDER BY s.pais, j.nome
LIMIT 10;

\echo '=== 3) Agregação por seleção (o relacionamento 1:N funciona) ==='
SELECT s.pais,
       s.continente,
       COUNT(j.id_jogador)              AS total_jogadores,
       SUM(j.gols_marcados)             AS gols_da_selecao,
       ROUND(AVG(j.valor_mercado), 2)   AS valor_medio_elenco
FROM selecoes s
    LEFT JOIN jogadores j ON j.id_selecao = s.id_selecao
GROUP BY s.id_selecao, s.pais, s.continente
ORDER BY gols_da_selecao DESC, s.pais;

\echo '=== 4) Agregação por clube (clubes que mais cederam atletas) ==='
SELECT c.nome_clube,
       c.pais_sede,
       COUNT(j.id_jogador) AS atletas_cedidos
FROM clubes c
    INNER JOIN jogadores j ON j.id_clube = c.id_clube
GROUP BY c.id_clube, c.nome_clube, c.pais_sede
HAVING COUNT(j.id_jogador) > 1
ORDER BY atletas_cedidos DESC, c.nome_clube;

\echo '=== 5) Integridade referencial: nenhum jogador órfão (deve retornar 0) ==='
SELECT COUNT(*) AS jogadores_orfaos
FROM jogadores j
WHERE NOT EXISTS (SELECT 1 FROM selecoes s WHERE s.id_selecao = j.id_selecao)
   OR NOT EXISTS (SELECT 1 FROM clubes   c WHERE c.id_clube   = j.id_clube);

\echo '=== 6) Teste das restrições: cada tentativa abaixo DEVE ser rejeitada ==='
DO $$
DECLARE
    v_erro TEXT;
BEGIN
    -- 6.1 FK inexistente
    BEGIN
        INSERT INTO jogadores (nome, id_selecao, id_clube, posicao)
        VALUES ('Jogador Fantasma', 999, 1, 'Atacante');
        RAISE WARNING 'FALHOU: a FK de seleção aceitou um id inexistente!';
    EXCEPTION WHEN foreign_key_violation THEN
        RAISE NOTICE 'OK - fk_jogadores_selecao bloqueou seleção inexistente.';
    END;

    -- 6.2 Posição fora do domínio
    BEGIN
        INSERT INTO jogadores (nome, id_selecao, id_clube, posicao)
        VALUES ('Jogador Fantasma', 10, 1, 'Técnico');
        RAISE WARNING 'FALHOU: o CHECK de posição aceitou um valor inválido!';
    EXCEPTION WHEN check_violation THEN
        RAISE NOTICE 'OK - ck_jogadores_posicao bloqueou posição inválida.';
    END;

    -- 6.3 Gols negativos
    BEGIN
        INSERT INTO jogadores (nome, id_selecao, id_clube, posicao, gols_marcados)
        VALUES ('Jogador Fantasma', 10, 1, 'Atacante', -3);
        RAISE WARNING 'FALHOU: o CHECK de gols aceitou valor negativo!';
    EXCEPTION WHEN check_violation THEN
        RAISE NOTICE 'OK - ck_jogadores_gols bloqueou gols negativos.';
    END;

    -- 6.4 País de seleção duplicado
    BEGIN
        INSERT INTO selecoes (pais, continente) VALUES ('Brasil', 'América do Sul');
        RAISE WARNING 'FALHOU: o UNIQUE de país aceitou duplicata!';
    EXCEPTION WHEN unique_violation THEN
        RAISE NOTICE 'OK - uq_selecoes_pais bloqueou país duplicado.';
    END;

    -- 6.5 Exclusão de seleção que ainda possui jogadores
    BEGIN
        DELETE FROM selecoes WHERE id_selecao = 10;   -- Brasil, que tem jogadores
        RAISE WARNING 'FALHOU: apagou uma seleção que ainda tem jogadores!';
    EXCEPTION WHEN foreign_key_violation THEN
        RAISE NOTICE 'OK - ON DELETE RESTRICT protegeu a seleção com jogadores.';
    END;

    -- Desfaz qualquer efeito colateral dos testes acima.
    RAISE EXCEPTION 'ROLLBACK_DOS_TESTES'
        USING ERRCODE = 'raise_exception';
EXCEPTION WHEN raise_exception THEN
    GET STACKED DIAGNOSTICS v_erro = MESSAGE_TEXT;
    IF v_erro <> 'ROLLBACK_DOS_TESTES' THEN
        RAISE;
    END IF;
    RAISE NOTICE 'Testes concluídos: nenhuma alteração foi persistida.';
END $$;

\echo '=== 7) Contagem final (inalterada em relação ao item 1) ==='
SELECT COUNT(*) AS jogadores_apos_testes FROM jogadores;
