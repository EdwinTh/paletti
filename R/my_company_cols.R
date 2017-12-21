#' Made up character vector of company colours
#' @export
#' @examples
#' viz_pallette(my_company_cols)
#' my_company_hex <- get_hex(my_company_cols)
#'
#' ggplot(mtcars %>% dplyr::mutate(cyl = as.character(cyl)), aes(cyl)) +
#'   geom_bar(aes(fill = cyl)) +
#'   scale_fill_manual(values = my_company_hex(red, yellow, blue))
#'
#' my_comp_pal        <- get_pal(my_company_cols)
#' my_comp_scale_col  <- get_scale_color(my_company_cols)
#' my_comp_scale_fill <- get_scale_fill(my_company_cols)
#
my_company_cols <- c(
  red    = "#701B06",
  blue   = "#78A8D1",
  yellow = "#D5BF98"
)
