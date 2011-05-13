ellipse <-
function (center, shape, radius, log = "", center.pch = 19, center.cex = 1.5, 
    segments = 51, add = TRUE, xlab = "", ylab = "", las = par("las"), 
    col = palette()[2], lwd = 2, lty = 1, eqscplot=FALSE, plot=TRUE, ...) 
{
    logged <- function(axis = c("x", "y")) {
        axis <- match.arg(axis)
        0 != length(grep(axis, log))
    }
    if (!(is.vector(center) && 2 == length(center))) 
        stop("center must be a vector of length 2")
    if (!(is.matrix(shape) && all(2 == dim(shape)))) 
        stop("shape must be a 2 by 2 matrix")
    angles <- (0:segments) * 2 * pi/segments
    unit.circle <- cbind(cos(angles), sin(angles))
    ellipse <- t(center + radius * t(unit.circle %*% chol(shape)))
    colnames(ellipse) <- c("x", "y")
    if (logged("x")) 
        ellipse[, "x"] <- exp(ellipse[, "x"])
    if (logged("y")) 
        ellipse[, "y"] <- exp(ellipse[, "y"])
    if (plot){
        if (add) 
            lines(ellipse, col = col, lwd = lwd, lty = lty, ...)
        else if (eqscplot == TRUE) eqscplot(ellipse, xlab = xlab, ylab = ylab, type = "l", 
            col = col, lwd = lwd, lty = lty, las = las, ...)
        else plot(ellipse, xlab = xlab, ylab = ylab, type = "l", 
            col = col, lwd = lwd, lty = lty, las = las, ...)
        if (center.pch) 
            points(center[1], center[2], pch = center.pch, cex = center.cex, 
                col = col)
    }
    return(invisible(ellipse))
}

dataEllipse <-
function (x, y, log = "", levels = c(0.5, 0.95), center.pch = 19, 
    center.cex = 1.5, plot.points = TRUE, add = !plot.points, 
    segments = 51, robust = FALSE, xlab = deparse(substitute(x)), 
    ylab = deparse(substitute(y)), las = par("las"), col = palette()[2], 
    pch = 1, lwd = 2, lty = 1, eqscplot=FALSE, ...) 
{
    if (length(col) == 1) 
        col <- rep(col, 2)
    if (missing(y)) {
        if (is.matrix(x) && ncol(x) == 2) {
            if (missing(xlab)) 
                xlab <- colnames(x)[1]
            if (missing(ylab)) 
                ylab <- colnames(x)[2]
            y <- x[, 2]
            x <- x[, 1]
        }
        else stop("x and y must be vectors, or x must be a 2 column matrix")
    }
    else if (!(is.vector(x) && is.vector(y) && length(x) == length(y))) 
        stop("x and y must be vectors of the same length")
    if (plot.points && !add) 
        if (eqscplot) eqscplot(x, y, xlab = xlab, ylab = ylab, col = col[1], pch = pch, 
            las = las, ...)
        else plot(x, y, xlab = xlab, ylab = ylab, col = col[1], pch = pch, 
            las = las, ...)
    if (plot.points && add) 
        points(x, y, col = col[1], pch = pch, ...)
    dfn <- 2
    dfd <- length(x) - 1
    if (robust) {
        v <- cov.trob(cbind(x, y))
        shape <- v$cov
        center <- v$center
    }
    else {
        shape <- var(cbind(x, y))
        center <- c(mean(x), mean(y))
    }
    els <- vector(mode="list", length=length(levels))
    names(els) <- levels
    for (level in levels) {
        radius <- sqrt(dfn * qf(level, dfn, dfd))
        els[[as.character(level)]] <- ellipse(center, shape, radius, log = log, center.pch = center.pch, 
            center.cex = center.cex, segments = segments, col = col[2], 
            lty = lty, lwd = lwd, eqscplot=eqscplot, ...)
    }
    if (length(els) == 1) els[[1]] else els
}