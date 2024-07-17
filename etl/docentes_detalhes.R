library(data.table)
library(plyr)

dir <- "fontes/"

arquivos <- list.files(dir)
arquivos <- head(arquivos[arquivos %ilike% "docente"],1)

ate_2012 <- data.frame()

for(arquivo in arquivos){

  print(arquivo)
  dt <- fread(paste0(dir,arquivo), encoding = 'Latin-1')
  if(nrow(dt)>0){
    dt <- subset(dt,NM_AREA_AVALIACAO %like% "FILOSOFIA",select=c(AN_BASE,SG_UF_ENTIDADE_ENSINO,SG_ENTIDADE_ENSINO,CD_PROGRAMA_IES,NM_PROGRAMA_IES,NM_NIVEL_PROGRAMA,AN_NASCIMENTO_DOCENTE,NR_SEQUENCIAL_DOCENTE,NR_IDADE,NM_PAIS_ORIGEM_DOCENTE))
    ate_2012 <- rbind.fill(ate_2012,dt)
  }

}

arquivos <- list.files(dir)
arquivos <- tail(arquivos[arquivos %ilike% "docente"],10)

desde_2013 <- data.frame()

for(arquivo in arquivos){

  print(arquivo)
  dt <- fread(paste0(dir,arquivo), encoding = 'Latin-1')
  if(nrow(dt)>0){
    dt <- subset(dt,NM_AREA_AVALIACAO %like% "FILOSOFIA",select=c(AN_BASE,SG_UF_PROGRAMA,SG_ENTIDADE_ENSINO,CD_PROGRAMA_IES,NM_PROGRAMA_IES,NM_GRAU_PROGRAMA,ID_PESSOA,AN_NASCIMENTO_DOCENTE,NM_PAIS_NACIONALIDADE_DOCENTE))
    desde_2013 <- rbind.fill(desde_2013,dt)
  }

}

desde_2013$NR_IDADE <- desde_2013$AN_BASE-desde_2013$AN_NASCIMENTO_DOCENTE

base <- rbind.fill(
    setNames(
        subset(ate_2012,select=c(AN_BASE,SG_UF_ENTIDADE_ENSINO,SG_ENTIDADE_ENSINO,CD_PROGRAMA_IES,NM_PROGRAMA_IES,NM_NIVEL_PROGRAMA,NR_SEQUENCIAL_DOCENTE,NR_IDADE,NM_PAIS_ORIGEM_DOCENTE)),
        c("ano","uf_sg","ies_sg","programa_cd","programa","grau","pessoa_id","idade","pais_origem")
    ),
    setNames(
        subset(desde_2013,select=c(AN_BASE,SG_UF_PROGRAMA,SG_ENTIDADE_ENSINO,CD_PROGRAMA_IES,NM_PROGRAMA_IES,NM_GRAU_PROGRAMA,ID_PESSOA,NR_IDADE,NM_PAIS_NACIONALIDADE_DOCENTE)),
        c("ano","uf_sg","ies_sg","programa_cd","programa","grau","pessoa_id","idade","pais_origem")
    )
)

base$programa <- toupper(base$programa)

write.csv2(base,"tabelas/docentes_detalhes.csv",row.names=F,na="")
