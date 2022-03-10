import traceback
from sqlalchemy import create_engine
from sqlalchemy_utils import create_database, database_exists

def get_engine(user, psswd, host, port, db):
    
    url = f"postgresql://{user}:{psswd}@{host}:{port}/{db}"
    if not database_exists(url):
        create_database(url)
    
    engine = create_engine(url, pool_size=50, echo=False)
    return engine

def create_my_engine(settings):
    return get_engine(settings['user'], settings['psswd'], settings['host'], settings['port'], settings['db'])

    
def get_folha():    
    
    from models import session
    try:
        folha_dict = {
            "unidades" : [],
            "setores" : [],
            "carreiras" : [],
            "cargos" : [],
            "rubricas" : [],
            "grupos_rubricas" : [],
            "colaboradores" : [],
            "evolucoes_funcionais" : [],
            "lancamentos" : [],
            "folhas_pagamentos" : []
        }
    except Exception as e:
        traceback(e)