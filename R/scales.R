#' Create the _pal function for ramped colors
#'
#' This wil create a function, that makes the palette with ramped colours.
#'
#' @param palette_list The list that contains the character vectors with color
#' codes. List elements should be named.
#'
#' @return A function that will create the ramped colors from one color vector
#' in the list. The function has the following parameters:
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
get_pal <- function(palette_list) {
  check_valid_list(palette_list)
  check_valid_color_list(palette_list)

  function(palette = names(palette_list)[1],
           alpha   = 1,
           reverse = FALSE) {
    pal <- palette_list[[palette]]
    if (reverse){
      pal <- rev(pal)
    }
    return(colorRampPalette(pal, alpha))
  }

}

#' Create the scale_color_ function
#'
#' This wil create the `scale_color_` function, to be applied in `ggplot2`. It
#' sets up the color palette.
#'
#' @param palette_list The list that contains the character vectors with color
#' codes. List elements should be named.
#' @param pal_object The output of the `get_pal` function.
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
get_scale_color <- function(palette_list,
                            pal_object) {
  check_valid_list(palette_list)
  check_valid_color_list(palette_list)

  function(...,
           palette  = NULL,
           discrete = TRUE,
           alpha    = 1,
           reverse  = FALSE) {
    if (is.null(palette)) palette <- names(palette_list)[1]
    if (discrete) {
      discrete_scale("colour",
                     "thank_you_ochRe_team",
                     palette = pal_object(palette,
                                          alpha   = alpha,
                                          reverse = reverse))
    } else {
      scale_color_gradientn(colours = pal_object(palette,
                                                 alpha   = alpha,
                                                 reverse = reverse,
                                                 ...)(256))
    }
  }
}

get_scale_colour <- get_scale_color
#' @rdname scale_color_dutchmasters


#' Setup fill palette for ggplot2
#'
#' @param palette Choose from 'dutchmasters_palettes' list
#'
#' @inheritParams dutchmasters_pal
#'
#' @param discrete whether to use a discrete colour palette
#'
#' @param ... additional arguments to pass to scale_color_gradientn
#'
#' @importFrom ggplot2 scale_fill_manual discrete_scale scale_fill_gradientn
#' @export
get_scale_fill <- function(palette_list,
                           pal_object) {

  check_valid_list(palette_list)
  check_valid_color_list(palette_list)

  function(...,
           palette  = NULL,
           discrete = TRUE,
           alpha    = 1,
           reverse  = TRUE) {

    if (is.null(palette)) palette <- names(palette_list)[1]

    if (discrete) {
        discrete_scale("fill", "dutchmasters", palette=dutchmasters_pal(palette, alpha = alpha, reverse = reverse))
    }
    else {
        scale_fill_gradientn(colours = dutchmasters_pal(palette, alpha = alpha, reverse = reverse, ...)(256))
    }
}
}
