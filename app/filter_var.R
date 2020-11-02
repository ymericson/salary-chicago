filter_var <- function(x, val) {
  if (is.numeric(val)) {
    x >= val[1] & x <= val[2]
  } else if (length(val) != 0) {
    x %in% val
  } else {
    TRUE
  }
} 