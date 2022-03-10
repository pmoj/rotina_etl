from models import (Colaboradores, 
                    Evolucoes_funcionais, 
                    Folhas_pagamentos, 
                    Grupos_rubricas, 
                    Lancamentos, 
                    Rubricas, 
                    Setores, 
                    Unidades, 
                    Cargos, 
                    Carreiras,
                    DM_cargos,
                    DM_faixas_etarias,
                    DM_rubricas,
                    DM_setores,
                    DM_tempos_folhas,
                    DM_tempos_servicos,
                    FT_lancamentos, 
                    Base, engine, session)
import traceback

def get_folha():    
    
     from models import session
     try:
          folha_dict = {
               "unidades" : [x for x in session.query(Unidades).all()],
               "setores" : [x for x in session.query(Setores).all()],
               "carreiras" : [x for x in session.query(Carreiras).all()],
               "cargos" : [x for x in session.query(Cargos).all()],
               "rubricas" : [x for x in session.query(Rubricas).all()],
               "grupos_rubricas" : [x for x in session.query(Grupos_rubricas).all()],
               "colaboradores" : [x for x in session.query(Colaboradores).all()],
               "evolucoes_funcionais" : [x for x in session.query(Evolucoes_funcionais).all()],
               "lancamentos" : [x for x in session.query(Lancamentos).all()],
               "folhas_pagamentos" : [x for x in session.query(Folhas_pagamentos).all()]
          }
     except Exception as e:
         traceback(e)     
     
     return folha_dict

def set_folhadw(folha_dict : dict):

     print(folha_dict)
     
     folha_dict = {
          "dm_setores" : [x for x in session.query(Setores).all()],
          "dm_cargos" : [x for x in session.query(Cargos).all()],
          "dm_rubricas" : [x for x in session.query(Rubricas).all()],
          
          "ft_lancamentos" : [x for x in session.query(Lancamentos).all()],

     }
     
     
def main():
     folha_dict = get_folha()
     print(folha_dict)
     # print([x.__getattribute__("dsc_cargo") for x in folha_dict["cargos"]])
     # set_folhadw(folha_dict)

if __name__ == '__main__':
     main()