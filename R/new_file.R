
# functions needed for users:
# - display column names in a table
# - get first 10 rows of a table
# - quick filtering for micromet...
# - show table size

#' Function to query the postgres database from R
#' Returns the result of the query in dataframe format
#' @param query needs to be in postgres code
#' @examples queryDatabase("SELECT datetime, precip_tot FROM z_micromet WHERE datetime BETWEEN '01/01/2009 00:00' AND '01/01/2010 00:00'")
#' @export
queryDatabaseUser <- function(query){
  on.exit(dbDisconnect(con))
  con <- dbConnect(drv = dbDriver("PostgreSQL"),
                   dbname = "c7701050", host = "db06.intra.uibk.ac.at",
                   port = 5432, user = "c7701196",
                   password = "U2z29!1*")
  tmp <- dbGetQuery(con, query)
}

#' Function to show datasets currently in the database
#' @export
showDatasets <- function(){
  datasets = queryDatabaseUser("SELECT * FROM bahngroup.datasets")
  print(datasets[,3:8])
  return(datasets[,3:8])
}

#' Function to show the projects table
#' @export
showProjects <- function(){
  projects = queryDatabaseUser("SELECT * FROM bahngroup.projects")
  print(projects[,2:7])
  return(projects[,2:dim(projects)[2]])
}

#' Function to show the projects table
#' @export
showSites <- function(){
  sites = queryDatabaseUser("SELECT * FROM bahngroup.sites")
  print(sites[,2:dim(sites)[2]])
  return(sites[,2:dim(sites)[2]])
}

#' Function to show the projects table
#' @export
showPublications <- function(){
  pubs = queryDatabaseUser("SELECT * FROM bahngroup.publications")
  print("Selected columns of publications table:")
  print(pubs[,c(2,3,5,6,7,8)])
  return(pubs[,2:dim(pubs)[2]])
}

#' Function to show tables currently in the database
#' @export
showTables <- function(){
  tables = queryDatabaseUser("SELECT * FROM information_schema.tables WHERE table_schema ='bahngroup'")[,1:3]
  print(tables)
  return(tables)
}

#' Function to show columns in a table
#' @param tablename is the name of the table for which columns should be shown
#' @export
showColumns <- function(tablename){
  query = paste0("SELECT column_name FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = '",tablename,"';")
  columns = queryDatabaseUser(query)
  print(columns)
  return(columns)
}

#' Function to show the class and range of data in a column
#' @param tablename is the name of the table
#' @param colname is the name(s) of the columns
#' @export
showRange <- function(tablename,colnames){
  results = data.frame(matrix(nrow=length(colnames),ncol=4))
  colnames(results) = c("var","class","min","max")
  results$var = colnames
  for (n in seq_along(colnames)){
    query = paste0("SELECT ",colnames[n]," FROM bahngroup.",tablename,";")
    data = queryDatabaseUser(query)
    results[n,2] = class(data[[1]])[1]
    if (class(data[[1]])[1]=="POSIXct" | class(data[[1]])[1]=="numeric"){
      results[n,3] = min(data[[1]],na.rm = TRUE)
      results[n,4] = max(data[[1]],na.rm = TRUE)
    }
  }
  print(results)
  return(results)
}

#' Function to get the size of a table
#' @param tablename is the name of the table
#' @export
showSize <- function(tablename){
  query = paste0("SELECT column_name FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = '",tablename,"';")
  columns = queryDatabaseUser(query)
  rows = queryDatabaseUser(paste0("SELECT ",columns[[1]][2]," FROM ",tablename,";"))
  size = c(length(columns[[1]]),length(rows[[1]]))
  print(paste0(tablename," has ",size[1]," columns and ",size[2]," rows"))
  return(size)
}
