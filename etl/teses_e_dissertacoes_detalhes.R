library(data.table)
library(plyr)

dir <- "fontes/"

anos <- c(1987:2012)

ate_2012 <- data.frame()

for(ano in anos){

  dt <- fread(paste0(dir,"dados_",as.character(ano),'.gz'), encoding = 'Latin-1')
  if(nrow(dt)>0){
    dt <- subset(dt,AreaConhecimento=="FILOSOFIA",select=c(AnoBase,Uf,SiglaIes,CodigoPrograma,NomePrograma,Nivel,Autor,TituloTese,ResumoTese,LinhaPesquisa,DataDefesa,PalavrasChave,Orientador_1,NomeIes,URLTextoCompleto))
    ate_2012 <- rbind.fill(ate_2012,dt)
  }

}

arquivos <- c("br-capes-btd-2013a2016-2017-12-01_2013.gz",
"br-capes-btd-2013a2016-2017-12-01_2014.gz",
"br-capes-btd-2013a2016-2017-12-01_2015.gz",
"br-capes-btd-2013a2016-2017-12-01_2016.gz",
"br-capes-btd-2017a2020-2021-12-03_2017.gz",
"br-capes-btd-2017a2020-2021-12-03_2018.gz",
"br-capes-btd-2017a2020-2021-12-03_2019.gz",
"br-capes-btd-2017a2020-2021-12-03_2020.gz",
"br-capes-btd-2021-2023-10-31.gz",
"br-capes-btd-2022-2023-10-31.gz")

desde_2013 <- data.frame()

for(arquivo in arquivos){

  print(arquivo)
  dt <- fread(paste0(dir,arquivo), encoding = 'Latin-1')
  if(nrow(dt)>0){
    dt <- subset(dt,NM_AREA_CONHECIMENTO=="FILOSOFIA",select=c(AN_BASE,SG_UF_IES,SG_ENTIDADE_ENSINO,CD_PROGRAMA,NM_PROGRAMA,NM_GRAU_ACADEMICO,NM_DISCENTE,NM_PRODUCAO,DS_RESUMO,NM_LINHA_PESQUISA,DT_TITULACAO,DS_PALAVRA_CHAVE,NM_ORIENTADOR,NM_ENTIDADE_ENSINO,NM_ORIENTADOR,DS_URL_TEXTO_COMPLETO))
    desde_2013 <- rbind.fill(desde_2013,dt)
  }

}

base <- rbind.fill(
    setNames(
        subset(ate_2012,select=c(AnoBase,Uf,SiglaIes,CodigoPrograma,NomePrograma,Nivel,Autor,TituloTese,ResumoTese,LinhaPesquisa,DataDefesa,PalavrasChave,Orientador_1,NomeIes,URLTextoCompleto)),
        c("ano","uf_sg","ies_sg","programa_cd","programa","grau","autor","titulo","resumo","linha","defesa","palavras","orientador","ies_nome","url")
    ),
    setNames(
        subset(desde_2013,select=c(AN_BASE,SG_UF_IES,SG_ENTIDADE_ENSINO,CD_PROGRAMA,NM_PROGRAMA,NM_GRAU_ACADEMICO,NM_DISCENTE,NM_PRODUCAO,DS_RESUMO,NM_LINHA_PESQUISA,DT_TITULACAO,DS_PALAVRA_CHAVE,NM_ENTIDADE_ENSINO,NM_ORIENTADOR,DS_URL_TEXTO_COMPLETO)),
        c("ano","uf_sg","ies_sg","programa_cd","programa","grau","autor","titulo","resumo","linha","defesa","palavras","orientador","ies_nome","url")
    )
)

base$programa <- toupper(base$programa)
base$grau <- toupper(base$grau)

write.csv2(base,"tabelas/teses_e_dissertacoes_detalhes.csv",row.names=F,na="")
