#' Create a function that returns hex codes
#'
#' Will return a function that returns the hex codes from the character vector
#' provided. The names of the character vectors can be queried.
#' @param color_vec A named character vector with hex codes.
#'
#' @return A function from which the hex codes can be queried by typing their
#' bare, unquoted name.
#' @export
#' @examples
#' milkmaid_hex <- get_hex(dutchmasters::dutchmasters$milkmaid)
#' milkmaid_hex(blue(skirt), yellow(buste))
#'
#' library(ggplot2)
#' ggplot(data.frame(x = rnorm(100),
#'                   y = rexp(100),
#'                   z = rep(letters[1:2], 50)),
#'        aes(x, y, col = z)) +
#'  geom_point(size = 3) +
#'  scale_color_manual(values = milkmaid_hex(blue(skirt), yellow(buste)))
get_hex <- function(color_vec) {
  check_valid_color_vec(color_vec)
  check_vec_has_names(color_vec)

  function(...) {
    col_names <- as.character(substitute(list(...)))[-1]

    colors_miss <- col_names[!col_names %in% names(color_vec)]
    if (length(colors_miss > 0))
      stop("Names not present: ", paste(colors_miss, collapse = ", "))

    ret <- color_vec[col_names]
    names(ret) <- NULL
    ret
  }
}
