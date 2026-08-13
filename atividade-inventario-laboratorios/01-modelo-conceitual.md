# Parte 1.1 — Modelo Conceitual

> **Enunciado:** desenhe o Diagrama de Entidade-Relacionamento (DER) deste cenário.
> Mostre as duas entidades, seus atributos e a cardinalidade (relação) entre elas.

O modelo conceitual descreve **o que** precisa ser armazenado, do jeito que o usuário
enxerga o problema — sem tipos de dados e sem SGBD. Está na notação de **Peter Chen**:
retângulo = entidade, losango = relacionamento, elipse = atributo.

## Entidades

| Entidade | O que representa |
|---|---|
| **LABORATÓRIO** | A sala onde os equipamentos ficam guardados (ex.: "Lab. de Redes", no "Bloco A"). |
| **EQUIPAMENTO** | O item de informática que precisa ser localizado (ex.: "Roteador Cisco", patrimônio "PAT-1234"). |

## Atributos

| Entidade | Atributo | Observação |
|---|---|---|
| LABORATÓRIO | `id_laboratorio` | Número de identificação **único** — identificador da entidade. |
| LABORATÓRIO | `nome` | Nome descritivo do laboratório. |
| LABORATÓRIO | `bloco` | Bloco onde o laboratório está localizado. |
| EQUIPAMENTO | `id_equipamento` | Número de identificação **único** — identificador da entidade. |
| EQUIPAMENTO | `nome` | Nome do equipamento. |
| EQUIPAMENTO | `patrimonio` | Número de patrimônio, também **único** (atributo identificador alternativo). |

## Relacionamento e regra de negócio

O enunciado diz que todo equipamento está **obrigatoriamente associado a um (e apenas
um) laboratório**. Disso saem duas afirmações:

1. Um **EQUIPAMENTO** fica alocado em **exatamente um** LABORATÓRIO.
2. Um **LABORATÓRIO** abriga **vários** EQUIPAMENTOS.

Portanto a cardinalidade do relacionamento *aloca* é **1:N** (um para muitos), com o
lado "muitos" na entidade EQUIPAMENTO.

## Diagrama Entidade-Relacionamento (DER)

```mermaid
flowchart TB
    %% ================= ENTIDADES =================
    LAB["LABORATÓRIO"]
    EQU["EQUIPAMENTO"]

    %% ============== RELACIONAMENTO ===============
    ALO{"aloca"}

    %% ========= LIGAÇÕES COM CARDINALIDADE ========
    LAB ---|"(1,N)"| ALO
    ALO ---|"(1,1)"| EQU

    %% ========= ATRIBUTOS DO LABORATÓRIO ==========
    LA1(("id_laboratorio (PK)"))
    LA2(("nome"))
    LA3(("bloco"))
    LAB --- LA1
    LAB --- LA2
    LAB --- LA3

    %% ========= ATRIBUTOS DO EQUIPAMENTO ==========
    EA1(("id_equipamento (PK)"))
    EA2(("nome"))
    EA3(("patrimonio (único)"))
    EQU --- EA1
    EQU --- EA2
    EQU --- EA3

    classDef entidade fill:#bfdbfe,stroke:#1e40af,stroke-width:2px,color:#0b1020;
    classDef relacionamento fill:#fde68a,stroke:#b45309,stroke-width:2px,color:#0b1020;
    classDef atributo fill:#d9f99d,stroke:#4d7c0f,stroke-width:1px,color:#0b1020;

    class LAB,EQU entidade;
    class ALO relacionamento;
    class LA1,LA2,LA3,EA1,EA2,EA3 atributo;
```

## Leitura da cardinalidade

A notação `(mínimo, máximo)` é lida **do lado oposto** da ligação:

| Leitura | Cardinalidade | Significado |
|---|---|---|
| EQUIPAMENTO → LABORATÓRIO | **(1,1)** | Todo equipamento está em um laboratório, e só em um. A associação é obrigatória. |
| LABORATÓRIO → EQUIPAMENTO | **(1,N)** | Um laboratório abriga de um a N equipamentos. |

> Como não existe relacionamento N:N, **nenhuma tabela associativa** será criada no
> modelo lógico: basta uma chave estrangeira.
