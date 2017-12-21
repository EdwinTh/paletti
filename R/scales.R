#' Create the _pal function for ramped colors
#'
#' This wil create a function, that makes the palette with ramped colours.
#'
#' @param hex_object Either a character vector with hex code, or a list that
#' contains the character vectors with hex codes. List elements should be
#' named.
#'
#' @return A function that will create the ramped colors from the color vector,
#' or of one of the vectors in the list. The function has the following
#' parameters:
#'
#' `palette`, a character that indicates which of the color vectors to use.
#'
#' `alpha`, the desired transparancy.
#'
#' `reverse`, if TRUE, the direction of the colours is reversed.
#'
#' @examples
#' # devtools::install_github("RopenScilabs/ochRe")
#' # devtools::install_github("EdwinTh/dutchmasters")
#'
#' # use get_pal on a single character vector
#' my_pal <- get_pal(c("#701B06", "#78A8D1", "#E3C78F"))
#' filled.contour(volcano,
#'                color.palette = my_pal(),
#'                asp=1)
#'
#' # or on a list with multiple vectors
#' ochRe_pal <- get_pal(ochRe::ochre_palettes)
#' dutchmasters_pal <- get_pal(dutchmasters::dutchmasters)
#'
#' filled.contour(volcano,
#'                color.palette = ochRe_pal(),
#'                asp=1)
#'
#' filled.contour(volcano,
#'                color.palette = dutchmasters_pal("anatomy", reverse = TRUE),
#'                asp=1)
#' @export
get_pal <- function(hex_object) {

  if (is.list(hex_object)) {
    check_valid_list(hex_object)
    check_valid_color_list(hex_object)

    f <- function(palette,
                  palette_list,
                  alpha   = 1,
                  reverse = FALSE) {
      pal <- palette_list[[palette]]
      if (reverse){
        pal <- rev(pal)
      }
      return(colorRampPalette(pal, alpha))
    }
    ret <- list(pal_func     = f,
                palette_list = hex_object)
    class(ret) <- "pal_list"
    ret

  } else if (is.character(hex_object)) {

    check_valid_color_vec(hex_object)

    f <- function(alpha   = 1,
                  reverse = FALSE) {
      if (reverse){
        hex_object <- rev(hex_object)
      }
      return(colorRampPalette(hex_object, alpha))
    }
    class(f) <- "pal_vec"
    f

  } else {

    stop("hex_object should be either a list or a character vector",
         call. = FALSE)
  }
}

#' Create the scale_color_ and scale_fill_ functions
#'
#' This wil create the `scale_color_` and `scale_fill_` functions, to be applied
#' in `ggplot2`. It sets up the color palettes.
#'
#' @param pal_object The output of the `get_pal` function.
#' @param palette_list The list that contains the character vectors with color
#' codes. List elements should be named.
#'
#' @return A function that can be used to create color scale in an object of
#'   class `ggplot2`. The function has the following parameters:
#'
#' `palette`, a character that indicates which of the color vectors to use.
#'
#' `alpha`, the desired transparancy.
#'
#' `reverse`, if TRUE, the direction of the colours is reversed.
#'
#' `discrete`, whether to use a discrete colour palette.
#'
#' `...`` additional arguments to pass to scale_color_gradientn
#'
#' @importFrom ggplot2 scale_colour_manual
#'
#' @examples
#' # devtools::install_github("RopenScilabs/ochRe")
#' # devtools::install_github("EdwinTh/dutchmasters")
#' library(ggplot2)
#'
#' ochRe_pal <- get_pal(ochRe::ochre_palettes)
#' scale_colour_ochRe <- get_scale_colour(ochRe::ochre_palettes,
#'                                       ochRe_pal)
#'
#' dutchmasters_pal <- get_pal(dutchmasters::dutchmasters)
#' scale_fill_dutchmasters <- get_fill_colour(dutchmasters::dutchmasters,
#'                                            dutchmasters_pal)
#'
#' ggplot(mtcars, aes(mpg, wt)) +
#'   geom_point(aes(colour = factor(cyl)), size = 4) +
#'   scale_colour_ochRe()
#' ggplot(mtcars, aes(mpg, wt)) +
#'   geom_point(aes(colour = hp)) +
#'   scale_colour_ochRe(palette = "lorikeet", discrete = FALSE)
#' ggplot(data = mpg) +
#'   geom_point(mapping = aes(x = displ, y = hwy, color = class)) +
#'   scale_colour_dutchmasters(palette="view_of_Delft")
#' ggplot(diamonds) + geom_bar(aes(x = cut, fill = clarity)) +
#'   scale_fill_dutchmasters(palette = "anatomy")
#' @export
#'
#' @importFrom ggplot2 discrete_scale scale_color_gradientn
get_scale_color <- function(pal_object) {

  if (inherits(pal_object, "pal_vec")) {
    get_scale_vec(pal_object)
  } else if (inherits(pal_object, "pal_list")) {
    get_scale_list(pal_object)
  } else {
    stop("`pal_object` should be of class 'pal_vec' or 'pal_list'")
  }
}

get_scale_vec <- function(pal_object,
                                scale_type = "colour") {

  function(discrete = TRUE,
           alpha    = 1,
           reverse  = FALSE,
           ...) {
    if (discrete) {
      discrete_scale(scale_type,
                     "thank_you_ochRe_team",
                     palette = pal_object(alpha   = alpha,
                                          reverse = reverse))
    } else {
      func <- ifelse(scale_type == "colour",
                     scale_color_gradientn,
                     scale_fill_gradientn)
      func(colours = pal_object(alpha   = alpha,
                                reverse = reverse,
                                ...)(256))
    }
  }
}

get_scale_list <- function(pal_object,
                           scale_type = "colour") {
  palette_func <- pal_object$pal_func
  palette_list <- pal_object$palette_list

  function(palette  = NULL,
           discrete = TRUE,
           alpha    = 1,
           reverse  = FALSE,
           ...) {
    if (is.null(palette)) palette <- names(palette_list)[1]


    if (discrete) {
      discrete_scale(scale_type,
                     "thank_you_ochRe_team",
                     palette = palette_func(palette      = palette,
                                            palette_list = palette_list,
                                            alpha   = alpha,
                                            reverse = reverse))
    } else {
      func <- ifelse(scale_type == "colour",
                     scale_color_gradientn,
                     scale_fill_gradientn)
      func(colours = pal_object(palette      = palette,
                                palette_list = palette_list,
                                alpha   = alpha,
                                reverse = reverse,
                                ...)(256))
    }
  }

}

get_scale_colour <- get_scale_color

#' @rdname get_scale_color
#' @export
get_scale_fill <- function(pal_object) {

  if (inherits(pal_object, "pal_vec")) {
    get_scale_vec(pal_object, "fill")
  } else if (inherits(pal_object, "pal_list")) {
    get_scale_list(pal_object, "fill")
  } else {
    stop("`pal_object` should be of class 'pal_vec' or 'pal_list'")
  }
}
