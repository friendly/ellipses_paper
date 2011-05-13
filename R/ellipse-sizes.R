# radii and sizes of an ellipse

setwd("c:/sasuser/datavis/manova/ellipses")
library(MASS)
library(spida)


# Principal components factorization

pca.fac <- function(x) {
    xx <- svd(x)
    ret <- t(xx$v) * sqrt(pmax( xx$d,0))
    ret 
}

figframe <- function(  xlim = c(-3,3), ylim = c(-3,3), xlab = '', ylab = '') {
    eqscplot( x=0,y=0, xlim = xlim, ylim = ylim, xlab = xlab, ylab = ylab, type = 'n')
    abline( v=0, col="gray")
    abline( h=0, col="gray")
}

# function to draw conjugate axes
conjugate.axes <- function (B, col="black", lwd=2, pch=16, cex=2) {
    b1 <- B[,1]
    b2 <- B[,2]
    arrows( 0,0, b1[1], b1[2], col=col, lwd=lwd, angle=6)
    points( rbind(b1), col = col, pch = pch, cex = cex)

    arrows( 0,0, b2[1], b2[2], col=col, lwd=lwd, angle=6)
    points( rbind(b2), col = col, pch = pch, cex = cex)
    lines( rbind( b1 + b2, b1 - b2, - b2 - b1, -b1 + b2, b1 + b2,
        NA, b1, -b1, NA, b2, -b2), col = col, lwd = 1.4)
}

 W <- matrix( c(9, 2, 2, 4), nrow=2 )
  B <- t(pca.fac(W))
  b1 <- B[,1] <- -B[,1]  # make first positive direction
  b2 <- B[,2]

 figframe(xlim=c(-2,3), ylim=c(-2,3))
 
 origin <- c(0,0)
    
 bbox <- ellplus(shape=W, fac=pca.fac, box=TRUE)
 # polygon for Wilks' Lambda
 bpoly <- rbind( origin, b2, bbox[2,], b1, origin)
 polygon(bpoly, col=gray(.95))

 # draw the ellipse
 lines( ell(center=c(0,0), shape = W ), col = 'blue', lwd=3)

conjugate.axes(B, col='brown')    
text( b1[1]/2, b1[2]/2, label = ~lambda[1], cex=1.5, pos=1) 
text( b2[1]/2, b2[2]/2, label = ~lambda[2], cex=1.5, pos=2)
lines(rbind(b1,b2), lwd=2)
# guess at perpendicular line from the origin to the line from b1 to b2, using locator()
lines(rbind(origin, c(.286, 1.53)), lwd=2)
 
