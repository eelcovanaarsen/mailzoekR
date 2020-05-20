#' Haalt organisaties.csv uit wekelijkse DUO data
basisgegevens_instellingen <- function(){
url <- "https://www.duo.nl/open_onderwijsdata/images/basisgegevens-instellingen.zip"
tmp <- tempfile()
curl::curl_download(url, tmp)
ORGANISATIES <- read.csv(unz(tmp, zip::zip_list(tmp)[which(startsWith(zip::zip_list(tmp)$filename,"ORGA")),1]),stringsAsFactors = F) #bepaal welk bestand de organisatie info bevat, pak die uit en lees die in
}

#' Haalt e-mailadressen uit actieve organisaties
extract_email <- function(){
  mailadressen <- basisgegevens_instellingen()%>%
    filter(CODE_STAND_RECORD=="A") %>% #Actuele organisaties
    select(NR_ADMINISTRATIE=?..NR_ADMINISTRATIE,E_MAIL)
}

#' Importeert meerdere csv's en plakt aan elkaar
csv_import <- function(csv_files){
  df <- lapply(csv_files, function(i){ read.csv2(i, header=TRUE, stringsAsFactors = F)}) %>%
    bind_rows()
    # mutate(jaar=as.numeric(substr(PEILDATUM,1,4)))%>%
    # mutate_at(if('PEILDATUM' %in% names(.)) 'PEILDATUM' else integer(0), jaar=as.numeric(substr(PEILDATUM,1,4)))
    # mutate(brinvest= paste0(BRIN_NUMMER,"0",VESTIGINGSNUMMER))
  }

