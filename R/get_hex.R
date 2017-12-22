#' Create a function that returns hex codes
#'
#' Will return a function that returns the hex codes from the character vector
#' provided. The names of the character vectors can be queried.
#' @param hex_object A named character vector with hex codes.
#'
#' @return A function from which the hex codes can be queried by typing their
#' bare, unquoted name.
#' @export
#' @examples
#' milkmaid_hex <- get_hex(dutchmasters::dutchmasters$milkmaid)
#' milkmaid_hex(blue(skirt), yellow(buste))
#' library(ggplot2)
#' some_plot <- ggplot(data.frame(x = rnorm(100),
#'                                y = rexp(100),
#'                                z = rep(letters[1:2], 50)),
#'                     aes(x, y, col = z)) +
#'  geom_point(size = 3)
#'  some_plot +
#'    scale_color_manual(values = milkmaid_hex(blue(skirt), yellow(buste)))
#'
#' dutchmasters_hex <- get_hex(dutchmasters)
#' some_plot +
#'   scale_color_manual(values = dutchmasters_hex("staalmeesters",
#'                                                red(tablecloth), black(cloak)))
#'

get_hex <- function(hex_object) {
  if (is.list(hex_object)) {
    get_hex_list(hex_object)
  } else if (is.character(hex_object)) {
    get_hex_vec(hex_object)
  } else {
    stop("hex_object of invalid type")
  }
}


get_hex_vec <- function(color_vec) {
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

get_hex_list <- function(color_list) {
  check_valid_list(color_list)
  check_valid_color_list(color_list)

  function(palette, ...) {
    color_vec <- color_list[[palette]]
    check_valid_color_vec(color_vec)
    check_vec_has_names(color_vec)
    col_names <- as.character(substitute(list(...)))[-1]

    colors_miss <- col_names[!col_names %in% names(color_vec)]
    if (length(colors_miss > 0))
      stop("Names not present: ", paste(colors_miss, collapse = ", "))

    ret <- color_vec[col_names]
    names(ret) <- NULL
    ret
  }
}
