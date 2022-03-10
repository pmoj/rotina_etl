SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

CREATE SCHEMA folha;


ALTER SCHEMA folha OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

/*
    ➔ Unidades = @cod-und, dsc-und, cid-und, uf-und
    ➔ Setores = @cod-setor, dsc-setor, cod-und, cod-colab-chefe
    ➔ Carreiras = @cod-carreira, dsc-carreira
    ➔ Cargos = @cod-cargo, dsc-cargo, cod-carreira
    ➔ Colaboradores = @cod-colab, nom-colab, dat-nasc, dat-admissao
    ➔ Evolucoes-Funcionais = @cod-colab, @dat-ini, cod-setor, cod-cargo
    ➔ Folhas-de-Pagamento = @ano, @mes, @tpo-folha, dsc-folha 
    ➔ Grupos-Rubricas = @cod-grupo, dsc-grupo
    ➔ Rubricas = @cod-rubrica, dsc-rubrica, tpo-rubrica, @cod-grupo
    ➔ Lancamentos = @ano, @mes, @tpo_folha, @cod-rubrica, @cod-colab, dat-lanc, val-lanc
*/

-- CREATE TABLES

CREATE TABLE folha."unidades" (
    "cod_und" integer NOT NULL,
    "dsc_und" character varying(100) NOT NULL,
    "cid_und" character varying(40) NOT NULL,
    "uf_und" character(2) NOT NULL
);

CREATE TABLE folha."setores" (
    "cod_setor" integer NOT NULL,
    "dsc_setor" character varying(100) NOT NULL,
    "cod_und" integer NOT NULL,
    "cod_colab_chefe" integer NOT NULL
);

CREATE TABLE folha."colaboradores" (
    "cod_colab" integer NOT NULL,
    "nom_colab" character varying(100) NOT NULL,
    "dat_nasc" date NOT NULL,
    "dat_admissao" date NOT NULL
);

CREATE TABLE folha."carreiras" (
    "cod_carreira" integer NOT NULL,
    "dsc_carreira" character varying(100) NOT NULL
);

CREATE TABLE folha."cargos" (
    "cod_cargo" integer NOT NULL,
    "dsc_cargo" character varying(100) NOT NULL,
    "cod_carreira" integer NOT NULL
);

CREATE TABLE folha."evolucoes_funcionais" (
    "cod_colab" integer NOT NULL,
    "dat_ini" date NOT NULL,
    "cod_setor" integer NOT NULL,
    "cod_cargo" integer NOT NULL
);

CREATE TABLE folha."folhas_pagamentos" (
    "ano" integer NOT NULL,
    "mes" integer NOT NULL,
    "tpo_folha" character(1) NOT NULL,
    "dsc_folha" character varying(100) NOT NULL    
);

CREATE TABLE folha."grupos_rubricas" (
    "cod_grupo" integer NOT NULL,
    "dsc_grupo" character varying(100) NOT NULL
);

CREATE TABLE folha."rubricas" (
    "cod_rubrica" integer NOT NULL,
    "dsc_rubrica" character varying(100) NOT NULL,
    "tpo_rubrica" character(1) NOT NULL,
    "cod_grupo" integer NOT NULL
);

CREATE TABLE folha."lancamentos" (
    "ano" integer NOT NULL,
    "mes" integer NOT NULL,
    "tpo_folha" character(1) NOT NULL,
    "cod_rubrica" integer NOT NULL,
    "cod_colab" integer NOT NULL,
    "dat_lanc" date NOT NULL,
    "val_lanc" decimal NOT NULL    
);


-- GRANT POSTGRES

ALTER TABLE folha."unidades" OWNER TO postgres;
ALTER TABLE folha."setores" OWNER TO postgres;
ALTER TABLE folha."colaboradores" OWNER TO postgres;
ALTER TABLE folha."carreiras" OWNER TO postgres;
ALTER TABLE folha."cargos" OWNER TO postgres;
ALTER TABLE folha."evolucoes_funcionais" OWNER TO postgres;
ALTER TABLE folha."folhas_pagamentos" OWNER TO postgres;
ALTER TABLE folha."grupos_rubricas" OWNER TO postgres;
ALTER TABLE folha."rubricas" OWNER TO postgres;
ALTER TABLE folha."lancamentos" OWNER TO postgres;


-- PRIMARY KEY

ALTER TABLE ONLY folha."unidades"
    ADD CONSTRAINT "unidades_pk" PRIMARY KEY ("cod_und");

ALTER TABLE ONLY folha."setores"
    ADD CONSTRAINT "setores_pk" PRIMARY KEY ("cod_setor");

ALTER TABLE ONLY folha."colaboradores"
    ADD CONSTRAINT "colaboradores_pk" PRIMARY KEY ("cod_colab");

ALTER TABLE ONLY folha."carreiras"
    ADD CONSTRAINT "carreiras_pk" PRIMARY KEY ("cod_carreira");

ALTER TABLE ONLY folha."cargos"
    ADD CONSTRAINT "cargos_pk" PRIMARY KEY ("cod_cargo");

ALTER TABLE ONLY folha."evolucoes_funcionais"
    ADD CONSTRAINT "evolucoes_funcionais_pk" PRIMARY KEY ("cod_colab","dat_ini");

ALTER TABLE ONLY folha."folhas_pagamentos"
    ADD CONSTRAINT "fol_pgto_pk" PRIMARY KEY ("ano","mes","tpo_folha");

ALTER TABLE ONLY folha."grupos_rubricas"
    ADD CONSTRAINT "grupos_rubricas_pk" PRIMARY KEY ("cod_grupo");

ALTER TABLE ONLY folha."rubricas"
    ADD CONSTRAINT "rubricas_pk" PRIMARY KEY ("cod_rubrica");

ALTER TABLE ONLY folha."lancamentos"
    ADD CONSTRAINT "lancamentos_pk" PRIMARY KEY ("ano", "mes", "tpo_folha", "cod_rubrica", "cod_colab");



-- FOREIGN KEY

ALTER TABLE ONLY folha."setores"
    ADD CONSTRAINT "setores_unidades_fk" FOREIGN KEY ("cod_und") REFERENCES folha."unidades"("cod_und") ON DELETE RESTRICT;

ALTER TABLE ONLY folha."setores"
    ADD CONSTRAINT "setores_colab_fk" FOREIGN KEY ("cod_colab_chefe") REFERENCES folha."colaboradores"("cod_colab") ON DELETE RESTRICT;

ALTER TABLE ONLY folha."cargos"
    ADD CONSTRAINT "cargos_carreiras_fk" FOREIGN KEY ("cod_carreira") REFERENCES folha."carreiras"("cod_carreira") ON DELETE RESTRICT;

ALTER TABLE ONLY folha."evolucoes_funcionais"
    ADD CONSTRAINT "evo_setores_fk" FOREIGN KEY ("cod_setor") REFERENCES folha."setores"("cod_setor") ON DELETE RESTRICT;

ALTER TABLE ONLY folha."evolucoes_funcionais"
    ADD CONSTRAINT "evo_cargos_fk" FOREIGN KEY ("cod_cargo") REFERENCES folha."cargos"("cod_cargo") ON DELETE RESTRICT;

ALTER TABLE ONLY folha."evolucoes_funcionais"
    ADD CONSTRAINT "evo_colab_fk" FOREIGN KEY ("cod_colab") REFERENCES folha."colaboradores"("cod_colab") ON DELETE RESTRICT;

ALTER TABLE ONLY folha."rubricas"
    ADD CONSTRAINT "rub_grupo_fk" FOREIGN KEY ("cod_grupo") REFERENCES folha."grupos_rubricas"("cod_grupo") ON DELETE RESTRICT;

ALTER TABLE ONLY folha."lancamentos"
    ADD CONSTRAINT "lanc_folha_fk" FOREIGN KEY ("ano", "mes", "tpo_folha") REFERENCES folha."folhas_pagamentos"("ano", "mes", "tpo_folha") ON DELETE RESTRICT;

ALTER TABLE ONLY folha."lancamentos"
    ADD CONSTRAINT "lanc_rub_fk" FOREIGN KEY ("cod_rubrica") REFERENCES folha."rubricas"("cod_rubrica") ON DELETE RESTRICT;

ALTER TABLE ONLY folha."lancamentos"
    ADD CONSTRAINT "lanc_colab_fk" FOREIGN KEY ("cod_colab") REFERENCES folha."colaboradores"("cod_colab") ON DELETE RESTRICT;


-- INDEXES

-- CREATE INDEX "unidades_cod_idx" ON folha."unidades" USING btree ("cod_und");


-- INSERTS

insert into folha.unidades (cod_und, dsc_und, cid_und, uf_und)
values (1, 'Campus Farolândia', 'Aracaju', 'SE');

insert into folha.unidades (cod_und, dsc_und, cid_und, uf_und)
values (2, 'Campus Centro', 'Aracaju', 'SE');

insert into folha.unidades (cod_und, dsc_und, cid_und, uf_und)
values (3, 'Clínica Odontológica', 'Aracaju', 'SE');

insert into folha.unidades (cod_und, dsc_und, cid_und, uf_und)
values (4, 'Polo Petrolina', 'Petrolina', 'PE');

insert into folha.unidades (cod_und, dsc_und, cid_und, uf_und)
values (5, 'Campus Zona Sul', 'Recife', 'PE');

insert into folha.colaboradores values (3837,'NADJA *****','1959-01-31','1984-01-31');
insert into folha.colaboradores values (3471,'ALTAIR *****','1952-06-02','1977-06-02');
insert into folha.colaboradores values (3544,'MARIA *****','1964-07-30','1989-07-30');
insert into folha.colaboradores values (3767,'CLAUDIO *****','1974-07-31','1999-07-31');
insert into folha.colaboradores values (3840,'DANIEL *****','1979-06-22','2004-06-22');
insert into folha.colaboradores values (3769,'ROSIVALDO *****','1956-06-04','1981-06-04');
insert into folha.colaboradores values (2741,'JURANDI *****','1960-05-21','1985-05-21');
insert into folha.colaboradores values (2614,'JULIO *****','1957-08-14','1982-08-14');
insert into folha.colaboradores values (2633,'TANIA *****','1965-07-07','1990-07-07');
insert into folha.colaboradores values (2635,'TEREZA *****','1966-12-24','1991-12-24');
insert into folha.colaboradores values (2658,'LUIZ *****','1952-05-13','1977-05-13');
insert into folha.colaboradores values (2670,'ADELMO *****','1956-10-10','1981-10-10');
insert into folha.colaboradores values (2774,'CANDIDA *****','1966-12-04','1991-12-04');
insert into folha.colaboradores values (2834,'PATRICIA *****','1973-02-10','1998-02-10');
insert into folha.colaboradores values (2783,'ANA *****','1954-03-31','1979-03-31');
insert into folha.colaboradores values (2784,'JOSE *****','1951-03-11','1976-03-11');
insert into folha.colaboradores values (2805,'MARIA *****','1959-09-21','1984-09-21');
insert into folha.colaboradores values (2827,'JORGE *****','1967-04-05','1992-04-05');
insert into folha.colaboradores values (2891,'ANTONIO *****','1969-01-26','1994-01-26');
insert into folha.colaboradores values (2893,'CHRISTIANE *****','1969-04-22','1994-04-22');
insert into folha.colaboradores values (2899,'MARCOS *****','1962-12-10','1987-12-10');
insert into folha.colaboradores values (2908,'JAILSON *****','1972-06-18','1997-06-18');
insert into folha.colaboradores values (2932,'MARIA *****','1969-01-25','1994-01-25');
insert into folha.colaboradores values (2933,'FREDERICO *****','1964-01-14','1989-01-14');
insert into folha.colaboradores values (2934,'ROSE *****','1964-01-01','1989-01-01');
insert into folha.colaboradores values (2935,'MARCELO *****','1972-07-28','1997-07-28');
insert into folha.colaboradores values (2938,'WILSON *****','1965-02-10','1990-02-10');
insert into folha.colaboradores values (2939,'JOSE *****','1960-12-03','1985-12-03');
insert into folha.colaboradores values (2941,'ROSANGELA *****','1974-10-13','1999-10-13');
insert into folha.colaboradores values (2952,'ANTONIO *****','1959-08-19','1984-08-19');
insert into folha.colaboradores values (2954,'MARCOS *****','1975-05-08','2000-05-08');
insert into folha.colaboradores values (2958,'MARCO *****','1965-01-31','1990-01-31');
insert into folha.colaboradores values (2916,'MARIA *****','1965-04-21','1990-04-21');
insert into folha.colaboradores values (5867,'CARLOS *****','1972-07-26','1997-07-26');
insert into folha.colaboradores values (5870,'NUBIA *****','1970-04-11','1995-04-11');
insert into folha.colaboradores values (6078,'EMANUELE *****','1977-12-06','2002-12-06');
insert into folha.colaboradores values (6081,'JOSE *****','1958-01-19','1983-01-19');
insert into folha.colaboradores values (6139,'FRANCINE *****','1975-03-25','2000-03-25');
insert into folha.colaboradores values (6141,'EVA *****','1979-04-12','2004-04-12');
insert into folha.colaboradores values (6188,'MARIA *****','1976-07-07','2001-07-07');


insert into folha.setores values (5,'DAAF',4,6188);
insert into folha.setores values (6,'DAAF',2,6141);
insert into folha.setores values (7,'DFI',4,6188);
insert into folha.setores values (8,'DIM',4,6188);
insert into folha.setores values (9,'DNG',4,6188);
insert into folha.setores values (10,'DRH',3,5870);
insert into folha.setores values (11,'DMK',4,6188);
insert into folha.setores values (12,'ASSJUR',3,5870);
insert into folha.setores values (13,'COMPESE',3,5870);
insert into folha.setores values (14,'PÓS-GRADUAÇÃO',4,6188);
insert into folha.setores values (15,'ALMOXARIFADO',4,6188);
insert into folha.setores values (16,'CALL CENTER',4,6188);
insert into folha.setores values (17,'CENTRAL DE ESTAGIO',4,6188);
insert into folha.setores values (18,'CENTRO DE SAÚDE',4,6188);
insert into folha.setores values (19,'GERÊNCIA DE FIDELIZAÇÃO',3,5870);
insert into folha.setores values (20,'NEAD',4,6188);
insert into folha.setores values (21,'PAACE',4,6188);
insert into folha.setores values (22,'PATRIMONIO',4,6188);
insert into folha.setores values (23,'REITORIA',4,6188);
insert into folha.setores values (24,'ADMINISTRATIVO',3,5870);
insert into folha.setores values (29,'INTELIGENCIA COMPETITIVA',3,5870);
insert into folha.setores values (32,'CEAP',4,6188);
insert into folha.setores values (33,'DEPARTAMENTO MÉDICO',4,6188);
insert into folha.setores values (41,'SUPREAL',3,5870);
insert into folha.setores values (1,'DTI',3,5870);
insert into folha.setores values (2,'VICE-PRESIDENCIA ADM',4,6188);
insert into folha.setores values (3,'VICE-PRESIDENCIA ACADEMICA',4,6188);
insert into folha.setores values (4,'DIG',4,6188);
insert into folha.setores values (25,'ASSPLAN',3,5870);
insert into folha.setores values (27,'PÓS-GRADUAÇÃO',2,6141);
insert into folha.setores values (34,'ASSCOM',3,5870);
insert into folha.setores values (36,'ESTAGIO',4,6188);
insert into folha.setores values (28,'BIBLIOTECA',4,6188);
insert into folha.setores values (35,'CCS',4,6188);
insert into folha.setores values (40,'PRESIDÊNCIA',3,5870);
insert into folha.setores values (31,'DFI',2,6141);
insert into folha.setores values (37,'DAA',2,6141);
insert into folha.setores values (45,'PRONATEC',4,6188);
insert into folha.setores values (46,'DIRETORIA ADM',2,6141);
insert into folha.setores values (43,'CONTROLADORIA',3,5870);
insert into folha.setores values (44,'INTERNACIONALIZAÇÃO',4,6188);
insert into folha.setores values (54,'PAACE',2,6141);
insert into folha.setores values (49,'ITP',4,6188);
insert into folha.setores values (55,'PAACE',1,2952);
insert into folha.setores values (52,'DMK',2,6141);
insert into folha.setores values (53,'DMK',1,2952);
insert into folha.setores values (47,'IDIOMAS',3,5870);
insert into folha.setores values (48,'MESTRADO/DOUTRADO',4,6188);
insert into folha.setores values (50,'DRH',4,6188);
insert into folha.setores values (51,'DFI',1,2952);
insert into folha.setores values (56,'PÓS-GRADUAÇÃO',1,2952);
insert into folha.setores values (57,'COMPLIANCE',3,5870);
insert into folha.setores values (58,'FIEF',3,5870);


/*
➔ dm_tempos_folhas
   #id_ano_mes
   ano
   mes
➔ dm_rubricas
   #cod_rubrica
   dsc_grupo
   dsc_rubrica
   tipo_rubrica
➔ dm_setores
   #cod_setor
   dsc_unidade
   cidade_unidade
   uf_unidade
   dsc_setor
➔ dm_cargos
   #cod_cargo
   dsc_carreira
   dsc_cargo
➔ dm_faixas_etarias
   #cod_faixa
   dsc_faixa
   idade_inicial
   idade_final
➔ dm_tempos_servicos
   #cod_tempo_serv
   dsc_tempo_serv
   ano_inicial
   ano_final
➔ ft_lancamentos
   #cod_rubrica
   #cod_setor
   #cod_cargo
   #cod_faixa
   #cod_tempo_serv
   #id_ano_mes
   total_lanc
   valor_bruto
   valor_desconto
   valor_liquido
*/

-- DW

CREATE SCHEMA folhadw;

ALTER SCHEMA folhadw OWNER TO postgres;


-- TABLES

CREATE TABLE folhadw."dm_tempos_folhas" (
    "id_ano_mes" integer NOT NULL,
    "ano" integer NOT NULL,
    "mes" integer NOT NULL
);

CREATE TABLE folhadw."dm_rubricas" (
    "cod_rubrica" integer NOT NULL,
    "dsc_grupo" character varying(100) NOT NULL,
    "dsc_rubrica" character varying(100) NOT NULL,
    "tipo_rubrica" character varying(100) NOT NULL
);

CREATE TABLE folhadw."dm_setores" (
    "cod_setor" integer NOT NULL,
    "dsc_unidade" character varying(100) NOT NULL,
    "cidade_unidade" character varying(100) NOT NULL,
    "uf_unidade" character(1) NOT NULL,
    "dsc_setor" character varying(100) NOT NULL
);

CREATE TABLE folhadw."dm_cargos" (
    "cod_cargo" integer NOT NULL,
    "dsc_carreira" character varying(100) NOT NULL,
    "dsc_cargo" character varying(100) NOT NULL
);

CREATE TABLE folhadw."dm_faixas_etarias" (
    "cod_faixa" integer NOT NULL,
    "dsc_faixa" character varying(100) NOT NULL,
    "idade_inicial" integer NOT NULL,
    "idade_final" integer NOT NULL
);

CREATE TABLE folhadw."dm_tempos_servicos" (
    "cod_tempo_serv" integer NOT NULL,
    "dsc_tempo_serv" character varying(100) NOT NULL,
    "ano_inicial" integer NOT NULL,
    "ano_final" integer NOT NULL
);

CREATE TABLE folhadw."ft_lancamentos" (
    "cod_rubrica" integer NOT NULL,
    "cod_setor" integer NOT NULL,
    "cod_cargo" integer NOT NULL,
    "cod_faixa" integer NOT NULL,
    "cod_tempo_serv" integer NOT NULL,
    "id_ano_mes" integer NOT NULL,
    "total_lanc" integer NOT NULL,
    "valor_bruto" decimal NOT NULL,
    "valor_desconto" decimal NOT NULL,
    "valor_liquido" decimal NOT NULL
);


-- GRANT POSTGRES

ALTER TABLE folhadw."dm_tempos_folhas" OWNER TO postgres;
ALTER TABLE folhadw."dm_rubricas" OWNER TO postgres;
ALTER TABLE folhadw."dm_setores" OWNER TO postgres;
ALTER TABLE folhadw."dm_cargos" OWNER TO postgres;
ALTER TABLE folhadw."dm_faixas_etarias" OWNER TO postgres;
ALTER TABLE folhadw."dm_tempos_servicos" OWNER TO postgres;
ALTER TABLE folhadw."ft_lancamentos" OWNER TO postgres;

-- PRIMARY KEY

ALTER TABLE ONLY folhadw."dm_tempos_folhas"
    ADD CONSTRAINT "dm_tempos_folhas_pk" PRIMARY KEY ("id_ano_mes");

ALTER TABLE ONLY folhadw."dm_rubricas"
    ADD CONSTRAINT "dm_rubricas_pk" PRIMARY KEY ("cod_rubrica");

ALTER TABLE ONLY folhadw."dm_setores"
    ADD CONSTRAINT "dm_setores_pk" PRIMARY KEY ("cod_setor");

ALTER TABLE ONLY folhadw."dm_cargos"
    ADD CONSTRAINT "dm_cargos_pk" PRIMARY KEY ("cod_cargo");

ALTER TABLE ONLY folhadw."dm_faixas_etarias"
    ADD CONSTRAINT "dm_faixas_etarias_pk" PRIMARY KEY ("cod_faixa");

ALTER TABLE ONLY folhadw."dm_tempos_servicos"
    ADD CONSTRAINT "dm_tempos_servicos_pk" PRIMARY KEY ("cod_tempo_serv");

ALTER TABLE ONLY folhadw."ft_lancamentos"
    ADD CONSTRAINT "ft_lancamentos_pk" PRIMARY KEY ("cod_rubrica", "cod_setor", "cod_cargo", "cod_faixa",  "cod_tempo_serv", "id_ano_mes");


-- FOREIGN KEY

ALTER TABLE ONLY folhadw."ft_lancamentos"
    ADD CONSTRAINT "ft_lanc_rubrica_fk" FOREIGN KEY ("cod_rubrica") REFERENCES folhadw."dm_rubricas"("cod_rubrica") ON DELETE RESTRICT;

ALTER TABLE ONLY folhadw."ft_lancamentos"
    ADD CONSTRAINT "ft_lanc_setor_fk" FOREIGN KEY ("cod_setor") REFERENCES folhadw."dm_setores"("cod_setor") ON DELETE RESTRICT;

ALTER TABLE ONLY folhadw."ft_lancamentos"
    ADD CONSTRAINT "ft_lanc_cargo_fk" FOREIGN KEY ("cod_cargo") REFERENCES folhadw."dm_cargos"("cod_cargo") ON DELETE RESTRICT;

ALTER TABLE ONLY folhadw."ft_lancamentos"
    ADD CONSTRAINT "ft_lanc_faixa_fk" FOREIGN KEY ("cod_faixa") REFERENCES folhadw."dm_faixas_etarias"("cod_faixa") ON DELETE RESTRICT;

ALTER TABLE ONLY folhadw."ft_lancamentos"
    ADD CONSTRAINT "ft_lanc_tempo_serv_fk" FOREIGN KEY ("cod_tempo_serv") REFERENCES folhadw."dm_tempos_servicos"("cod_tempo_serv") ON DELETE RESTRICT;

ALTER TABLE ONLY folhadw."ft_lancamentos"
    ADD CONSTRAINT "ft_lanc_tempo_folha_fk" FOREIGN KEY ("id_ano_mes") REFERENCES folhadw."dm_tempos_folhas"("id_ano_mes") ON DELETE RESTRICT;
    
