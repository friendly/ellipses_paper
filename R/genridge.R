## 
# generalized ridge trace plots, with the confidence ellipse for parameters
##

ridge <- function(y, X, lambda=0){
	#dimensions	
    n <- nrow(X)
    p <- ncol(X)
	#center X and y
    Xm <- colMeans(X)
    ym <- mean(y)
    X <- X - rep(Xm, rep(n, p))
    y <- y - ym
	#scale X, as in MASS::lm.ridge 
    Xscale <- drop(rep(1/n, n) %*% X^2)^0.5
    X <- as.matrix(X/rep(Xscale, rep(n, p)))

    XPX <- crossprod(X)
    XPy <- crossprod(X,y)
    I <- diag(p)
    lmfit <- lm.fit(X, y)
    MSE <- sum(lmfit$residuals^2) / (n-p)

	# prepare output    
		coef <- matrix(0, length(lambda), p)
		cov <- as.list(rep(0, length(lambda)))
		mse <- rep(0, length(lambda))

	# loop over lambdas
    for(i in seq(length(lambda))) {
    	lam <- lambda[i]
    	XPXr <- XPX + lam * I
    	XPXI <- solve(XPXr)
    	coef[i,] <- XPXI %*% XPy
    	cov[[i]] <- MSE * XPXI %*% XPX %*% XPXI
    	res <- y - X %*% coef[i,]
    	mse[i] <- sum(res^2) / (n-p) 
    	dimnames(cov[[i]]) <- list(colnames(X), colnames(X))
    }
    dimnames(coef) <- list(format(lambda), colnames(X))
    result <- list(lambda=lambda, coef=coef, cov=cov, mse=mse, scales=Xscale)
    class(result) <- "ridge"
    result
} 

# plot a bivariate ridge trace for two variables from a biridge object

plot.ridge <- function(x, variables=1:2, radius=1, col=palette(), lwd=2, lty=1, xlim, ylim,
			center.pch = 16, center.cex=1.5,
			fill=FALSE, fill.alpha=0.3, ...) {

	ell <- function(center, shape, radius, segments=60) {
		angles <- (0:segments)*2*pi/segments
		circle <- radius * cbind( cos(angles), sin(angles))
		warn <- options(warn=-1)
		on.exit(options(warn))
		Q <- chol(shape, pivot=TRUE)
		order <- order(attr(Q, "pivot"))
		t( c(center) + t( circle %*% Q[,order]))
	}

	vnames <- dimnames(x$coef)[[2]]
	if (!is.numeric(variables)) {
		vars <- variables
		variables <- match(vars, vnames)
		check <- is.na(variables)
		if (any(check)) stop(paste(vars[check], collapse=", "), 
					" not among the predictor variables.") 
	}
	else {
		if (any (variables > length(vnames))) stop("There are only ", 
					length(vnames), " predictor variables.")
		vars <- vnames[variables]
	}

  lambda <- x$lambda
	coef <- x$coef[,variables]
	cov <- x$cov
	n.ell <- length(lambda)

	ells <- as.list(rep(0, n.ell))
# generate the ellipses for each lambda, to get xlim & ylim
	for (i in 1:n.ell) {
		ells[[i]] <- ell(center=coef[i,], shape=(cov[[i]])[variables,variables], radius=radius)
	}
	max <- apply(sapply(ells, function(X) apply(X, 2, max)), 1, max)
	min <- apply(sapply(ells, function(X) apply(X, 2, min)), 1, min)
	xlim <- if(missing(xlim)) c(min[1], max[1]) else xlim
	ylim <- if(missing(ylim)) c(min[2], max[2]) else ylim

	col <- rep(col, n.ell)		
	lwd <- rep(lwd, n.ell)		
	lty <- rep(lty, n.ell)		
	# handle filled ellipses
	fill <- rep(fill, n.ell)
	fill.alpha <- rep(fill.alpha, n.ell)
	fill.col <- trans.colors(col, fill.alpha)
	fill.col <- ifelse(fill, fill.col, NA)

	plot(coef, type='b', pch=center.pch, cex=center.cex, col=col, xlim=xlim, ylim=ylim, ...)
	for (i in 1:n.ell) {
#		lines(ells[[i]], col=col[i], lwd=lwd[i], lty=lty[i])
		polygon(ells[[i]], col=fill.col[i], border=col[i],  lty=lty[i], lwd=lwd[i])
	}
}

pairs.ridge <- function(x, variables, radius=1, col=palette(), lwd=1, lty=1,
		center.pch = 16, center.cex=1.25, digits=getOption("digits") - 3,
		diag.panel = panel.label,
		fill=FALSE, fill.alpha=0.3, ...) {

	panel.label <- function(x, ...) {
		plot(c(min, max),c(min, max), type="n", axes=FALSE)
		text(0.5, 0.5, vars[i], cex=2)
		text(1, 0, signif(range[1, i], digits=digits), adj=c(1, 0))
		text(0, 1, signif(range[2, i], digits=digits), adj=c(0, 1)) 
		box()
	}	

#	why doesn't this work??
#	panel.barplot <- function(x, ...) {
#		barplot(x$coef[,i], axes=FALSE, col=col, ...)
#		box()
#	}

	vars <- dimnames(x$coef)[[2]]
  if (!missing(variables)){
      if (is.numeric(variables)) {
          vars <- vars[variables]
          if (any(is.na(vars))) stop("Bad variable selection.")
          }
      else {
          check <- !(variables %in% vars)
          if (any(check)) stop(paste("The following", 
              if (sum(check) > 1) "variables are" else "variable is",
              "not in the model:", paste(variables[check], collapse=", ")))
          vars <- variables
          }
      }
  else variables <- vars
	nvar <- length(vars)

  range <- apply(x$coef, 2, range)
	min=0
	max=1	
  old.par <- par(mfrow=c(nvar, nvar), mar=rep(0,4))
  on.exit(par(old.par))

#	browser()
	for (i in 1:nvar){
    for (j in 1:nvar){
      if (i == j)
				diag.panel(x)
      else {
        plot.ridge(x, variables=c(vars[j], vars[i]), radius=radius,
        	col=col, lwd=lwd, lty=lty, 
        	axes=FALSE,
          fill=fill, fill.alpha=fill.alpha, ...)
        box()
            }
        }
    }

}

# from heplots
trans.colors <- function(col, alpha=0.5, names=NULL) {
  nc <- length(col)
  na <- length(alpha)
  # make lengths conform, filling out to the longest
  if (nc != na) {
  	col <- rep(col, length.out=max(nc,na))
  	alpha <- rep(alpha, length.out=max(nc,na))
  	}
  clr <-rbind(col2rgb(col)/255, alpha=alpha)
  col <- rgb(clr[1,], clr[2,], clr[3,], clr[4,], names=names)
  col
}

# coefficient method
coef.ridge <- function(x, ...) {
	x$coef
}

print.ridge <- function(x, digits = max(5, getOption("digits") - 5),...) {
  if (length(coef(x))) {
      cat("Ridge Coefficients:\n")
      print.default(format(coef(x), digits = digits), print.gap = 2, 
          quote = FALSE)
  }
  invisible(x)

}
