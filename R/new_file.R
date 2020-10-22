#' Function for writing a tibble as a table the database
#' This function will: i) connect to database, ii) write table; append if desired, iii) exit connection
#' @param x column use to compare the old and new data; only new data unique in this column will be added (eg. use date or a key/id)
#' @keywords database
#' @examples New example, test online
#' @export
add_1_to_x <- function(x){
  return(x+1)
}