from sqlalchemy import Column, ForeignKey, Integer, String, Date, Float
from sqlalchemy.orm import sessionmaker
from sqlalchemy.ext.declarative import declarative_base
from settings import db_settings as settings
from utils import create_my_engine

engine = create_my_engine(settings)

Session = sessionmaker(bind=engine)

session = Session()

Base = declarative_base()

'''
Classes para o banco folha (operacional)
'''

class Cargos(Base):

    __tablename__ = 'cargos'
    __table_args__ = ({"schema": "folha"})

    cod_cargo = Column(Integer, primary_key=True)
    dsc_cargo = Column(String(100))
    cod_carreira = Column(Integer, ForeignKey("carreiras.cod_carreira"))
    
    def __getattribute__(self, __name: str):
        return super().__getattribute__(__name)

class Carreiras(Base):

    __tablename__ = 'carreiras'
    __table_args__ = ({"schema": "folha"})
    
    cod_carreira = Column(Integer, primary_key=True)
    dsc_carreira = Column(String(100))

    def __getattribute__(self, __name: str):
        return super().__getattribute__(__name)

class Colaboradores(Base):

    __tablename__ = 'colaboradores'
    __table_args__ = ({"schema": "folha"})   
    
    cod_colab = Column(Integer, primary_key=True)
    nom_colab = Column(String(100))
    dat_nasc = Column(Date)
    dat_admissao = Column(Date)

    def __getattribute__(self, __name: str):
        return super().__getattribute__(__name)
        
class Evolucoes_funcionais(Base):
    
    __tablename__ = 'evolucoes_funcionais'
    __table_args__ = ({"schema": "folha"})   

    cod_colab = Column(Integer, primary_key=True)
    dat_ini = Column(Date, primary_key=True)
    cod_setor = Column(Integer)
    cod_cargo = Column(Integer)

    def __getattribute__(self, __name: str):
        return super().__getattribute__(__name)
        
class Folhas_pagamentos(Base):
    
    __tablename__ = 'folhas_pagamentos'
    __table_args__ = ({"schema": "folha"})   

    ano = Column(Integer, primary_key=True)
    mes = Column(Integer, primary_key=True)
    tpo_folha = Column(String(1), primary_key=True)
    dsc_folha = Column(String(100))

    def __getattribute__(self, __name: str):
        return super().__getattribute__(__name)
    
class Lancamentos(Base):
    
    __tablename__ = 'lancamentos'
    __table_args__ = ({"schema": "folha"})   

    ano = Column(Integer, primary_key=True)
    mes = Column(Integer, primary_key=True)
    tpo_folha = Column(String(1), primary_key=True)
    cod_rubrica = Column(Integer, primary_key=True)
    cod_colab = Column(Integer, primary_key=True)
    dat_lanc = Column(Date)
    val_lanc = Column(Float)

    def __getattribute__(self, __name: str):
        return super().__getattribute__(__name)
    
class Grupos_rubricas(Base):
    
    __tablename__ = 'grupos_rubricas'
    __table_args__ = ({"schema": "folha"})   
                                                                                                                                      
    cod_grupo = Column(Integer, primary_key=True)
    dsc_grupo = Column(String(100))

    def __getattribute__(self, __name: str):
        return super().__getattribute__(__name)

class Rubricas(Base):
    
    __tablename__ = 'rubricas'
    __table_args__ = ({"schema": "folha"})   
    
    cod_rubrica = Column(Integer, primary_key=True)
    dsc_rubrica = Column(String(100))
    tpo_rubrica = Column(String(1))
    cod_grupo = Column(Integer)

    def __getattribute__(self, __name: str):
            return super().__getattribute__(__name)
    
class Setores(Base):

    __tablename__ = 'setores'
    __table_args__ = ({"schema": "folha"})
    cod_setor = Column(Integer, primary_key=True)
    dsc_setor = Column(String(100))
    cod_und = Column(Integer)
    cod_colab_chefe = Column(Integer)

    def __getattribute__(self, __name: str):
        return super().__getattribute__(__name)
    
class Unidades(Base):
    
    __tablename__ = 'unidades'
    __table_args__ = ({"schema": "folha"})

    cod_und = Column(Integer, primary_key=True)
    dsc_und = Column(String(100))
    cid_und = Column(String(40))
    uf_und = Column(String(2))

    def __getattribute__(self, __name: str):
        return super().__getattribute__(__name)

'''
Classes para o banco folhadw (Dimensional)
'''

class DM_cargos(Base):
    
    __tablename__ = 'dm_cargos'
    __table_args__ = ({"schema": "folhadw"})
    
    cod_cargo = Column(Integer, primary_key=True)
    dsc_carreira = Column(String(100))
    dsc_cargo = Column(String(100))

class DM_faixas_etarias(Base):

    __tablename__ = 'dm_faixas_etarias'
    __table_args__ = ({"schema": "folhadw"})

    cod_faixa = Column(Integer, primary_key=True)
    dsc_faixa = Column(String(100))
    idade_inicial = Column(Integer)
    idade_final = Column(Integer)

class DM_rubricas(Base):
    
    __tablename__ = 'dm_rubricas'
    __table_args__ = ({"schema": "folhadw"})
    
    cod_rubrica = Column(Integer, primary_key=True)
    dsc_grupo = Column(String(100))
    dsc_rubrica = Column(String(100))
    tipo_rubrica = Column(String(100))

class DM_setores(Base):
    
    __tablename__ = 'dm_setores'
    __table_args__ = ({"schema": "folhadw"})

    cod_setor = Column(Integer, primary_key=True)
    dsc_unidade = Column(String(100))
    cidade_unidade = Column(String(100))
    uf_unidade = Column(String(2))
    dsc_setor = Column(String(100))

class DM_tempos_folhas(Base):
    
    __tablename__ = 'dm_tempos_folhas'
    __table_args__ = ({"schema": "folhadw"})

    id_ano_mes = Column(Integer, primary_key=True)
    ano = Column(Integer)
    mes = Column(Integer)

class DM_tempos_servicos(Base):
    
    __tablename__ = 'dm_tempos_servicos'
    __table_args__ = ({"schema": "folhadw"})

    cod_tempo_servicos = Column(Integer, primary_key=True)
    dsc_tempo_servicos = Column(String(100))
    ano_inicial = Column(Integer)
    ano_final = Column(Integer)

class FT_lancamentos(Base):
    
    __tablename__ = 'ft_lancamentos'
    __table_args__ = ({"schema": "folhadw"})

    cod_rubrica = Column(Integer, primary_key=True)
    cod_setor = Column(Integer, primary_key=True)
    cod_cargo = Column(Integer, primary_key=True)
    cod_faixa = Column(Integer, primary_key=True)
    cod_tempo_serv = Column(Integer, primary_key=True)
    id_ano_mes = Column(Integer, primary_key=True)
    total_lanc = Column(Integer)
    valor_bruto = Column(Float)
    valor_desconto = Column(Float)
    valor_liquido = Column(Float)


    
