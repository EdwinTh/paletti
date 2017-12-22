#' @importFrom glue glue
check_valid_list <- function(x) {
  stopifnot(is.list(x))
  x_names <- names(x)

  if (is.null(x_names)) {
    stop("All names are missing from the palette list")
  }

  x_names_missing <- sum(x_names == "")

  if (x_names_missing > 0) {
    stop(
      glue("{x_names_missing} out of the {length(x)} elements in the palette"),
      " list don't have names."
    )
  }
}

#' @importFrom grDevices col2rgb
check_valid_color <- function(x) {
  try_result <- try(col2rgb(x), silent = TRUE)
  if (inherits(try_result, "try-error")) {
    stop(glue("{x} is an invalid hex color"), call. = FALSE)
  }
}

check_valid_color_vec <- function(x) {
  for(col in x) check_valid_color(col)
}

check_valid_color_list <- function(x) {
  purrr::walk(x, check_valid_color_vec)
}

check_vec_has_names <- function(x) {
  vec_names <- names(x)
  if (is.null(vec_names) || any(vec_names == "")) {
    stop("All elements should have names", call. = FALSE)
  }
}

