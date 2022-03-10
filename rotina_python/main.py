from inspect import Traceback

import idna
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
         Traceback(e)     
     
     return folha_dict

def set_folhadw(folha_dict : dict):

     folhadw_dict = {
          "dm_setores" : [],
          "dm_cargos" : [],
          "dm_rubricas" : [],
          "dm_faixas_etarias" : [],     
          "dm_tempos_folhas" : [],
          "dm_tempos_servicos" : [],
          "ft_lancamentos" : []
     }
     
     try:     
          # DM_Cargos
          for carreira in folha_dict["carreiras"]:
               for cargo in folha_dict["cargos"]: 
                    if carreira.cod_carreira == cargo.cod_carreira:
                         c = DM_cargos(cargo, carreira)
                         folhadw_dict["dm_cargos"].append(c)
                         session.add(c)
                    
          #DM_faixas_etarias
          session.add(DM_faixas_etarias("Até 21 anos",18,21,1))
          session.add(DM_faixas_etarias("De 21 até 30 anos",21,30,2))
          session.add(DM_faixas_etarias("De 31 até 45 anos",31,45,3))
          session.add(DM_faixas_etarias("Acima de 45 anos",45,99,4))
          
          #DM_rubricas 
          for grupo in folha_dict["grupos_rubricas"]:
               for rubrica in folha_dict["rubricas"]:
                    if grupo.cod_grupo == rubrica.cod_grupo:
                         r = DM_rubricas(rubrica, grupo)
                         folhadw_dict["dm_rubricas"].append(r)
                         session.add(r)
                         
          #DM_setores
          for und in folha_dict["unidades"]:
               for setor in folha_dict["setores"]:
                    if und.cod_und == setor.cod_und:
                         s = DM_setores(setor, und)
                         folhadw_dict["dm_setores"].append(s)
                         session.add(s)
                         
          #DM_tempos_folhas
          i = 0  
          for folha in folha_dict["folhas_pagamentos"]:
               i+=1
               tf = DM_tempos_folhas(folha,i)
               folhadw_dict["dm_tempos_folhas"].append(tf)
               session.add(tf)
               
          #DM_tempos_servicos
          i = 0
          for colab in folha_dict["colaboradores"]:
               i+=1
               col = DM_tempos_servicos(colab,i)
               folhadw_dict["dm_tempos_servicos"].append(col)
               session.add(col)
          
          #FT_lancamentos         
          l : Lancamentos
          for l in folha_dict["lancamentos"]:
               
               cod_rubrica = l.cod_rubrica
               
               cod_colab = l.cod_colab
               
               evo : Evolucoes_funcionais = session.query(Evolucoes_funcionais).filter_by(cod_colab=cod_colab).first()
               cod_setor = evo.cod_setor
               cod_cargo = evo.cod_cargo
               
               col : Colaboradores = session.query(Colaboradores).filter_by(cod_colab=cod_colab).first()
               dat = 2022 - col.dat_nasc.year
               d : DM_faixas_etarias
               
               cod_faixa = 1
               for d in folhadw_dict["dm_faixas_etarias"]:
                    if d.idade_inicial <= dat and d.idade_final >= dat:
                         cod_faixa = d.cod_faixa
               
               cod_tempo_serv = 1
               x : DM_tempos_servicos
               for x in folhadw_dict["dm_tempos_servicos"]:
                    if col.dat_admissao.year == x.ano_inicial:
                         cod_tempo_serv = x.cod_tempo_serv               
               
               id_ano_mes = 1
               am : DM_tempos_folhas
               for am in folhadw_dict["dm_tempos_folhas"]:
                    if am.ano == l.dat_lanc.year and am.mes == l.dat_lanc.month:
                         id_ano_mes = am.id_ano_mes
               
               total_lanc = l.val_lanc
               
               valor_bruto = 1000
               valor_liquido = 1000
               valor_desconto = 0
               
               folhadw_dict["ft_lancamentos"].append(FT_lancamentos(cod_rubrica, cod_setor, cod_cargo, cod_faixa, cod_tempo_serv, id_ano_mes, total_lanc, valor_bruto, valor_liquido, valor_desconto))
               session.add(FT_lancamentos(cod_rubrica, cod_setor, cod_cargo, cod_faixa, cod_tempo_serv, id_ano_mes, total_lanc, valor_bruto, valor_liquido, valor_desconto))

          session.commit()
          print([x.__getattribute__("dsc_cargo") for x in folhadw_dict["dm_cargos"]])

          
     except Exception as e:
          Traceback(e)
          
     print("foir")
     
def main():
     folha_dict = get_folha()
     # print(folha_dict)
     # print([x.__getattribute__("dsc_cargo") for x in folha_dict["cargos"]])
     set_folhadw(folha_dict)

if __name__ == '__main__':
     main()