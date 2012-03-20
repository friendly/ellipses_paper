# radii and sizes of an ellipse

setwd("c:/sasuser/datavis/manova/ellipses/fig")
#library(MASS)
library(spida)


# Principal components factorization

pca.fac <- function(x) {
    xx <- svd(x)
    ret <- t(xx$v) * sqrt(pmax( xx$d,0))
    ret 
}

figframe <- function(  xlim = c(-3,3), ylim = c(-3,3), xlab = '', ylab = '') {
#    eqscplot( x=0,y=0, xlim = xlim, ylim = ylim, xlab = xlab, ylab = ylab, type = 'n')
  plot( x=0,y=0, xlim = xlim, ylim = ylim, xlab = xlab, ylab = ylab, type = 'n', asp=1)
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

# projection of point q on line between a, b
point2line <- function(a, b, q) {
	len <- sum((a-b)^2)
	r <- ((a[2]-q[2])*(a[2]-b[2])-(a[1]-q[1])*(b[1]-a[1])) / len
	p <- a + r*(b-a)
	p
}

# length of line between p1 and p2
len <- function(p1, p2) {
	sqrt(sum(p1-p2)^2)
 }


# Consider W to be the matrix (H+E)* in canonical space, where E* = I
 W <- matrix( c(9, 2, 2, 4), nrow=2 )
  B <- t(pca.fac(W))
  b1 <- B[,1] <- -B[,1]  # make first positive direction
  b2 <- B[,2]

png(file="mtests.png", width=7, height=7, res=200, units="in")
opar <- par(mar=c(3,3,1,1)+0.1)
 figframe(xlim=c(-2.5,3.5), ylim=c(-2.5,3.5))
 
 origin <- c(0,0)
    
 bbox <- ellplus(shape=W, fac=pca.fac, box=TRUE)
 # polygon for Wilks' Lambda
 bpoly <- rbind( origin, b2, bbox[2,], b1, origin)
 # clr <- trans.colors("lightgreen", alpha=0.3)
# "#90EE904C"
 polygon(bpoly, col="#90EE904C")

 # draw the ellipse
 lines( ell(center=origin, shape = W ), col = 'blue', lwd=3)
 lines( ell(center=origin, shape = diag(2) ), col = 'red', lwd=3)

cex=1.8
conjugate.axes(B, col='brown') 
lines(rbind(origin, b1), lwd=3)   
lines(rbind(origin, b2), lwd=3)   
text( b1[1]/2, b1[2]/2, label = "a", cex=cex, pos=1) 
text( .67*b2[1], .67*b2[2], label = "b", cex=cex, pos=2)
lines(rbind(b1,b2), lwd=3)

ppt <- point2line(b1, b2, origin)
lines(rbind(origin, ppt), lwd=3)

## labels
#text(b1[1], b1[2], "Roy", cex=cex, pos=4)
#text(bbox[2,1], bbox[2,2], "Wilks", cex=cex, pos=1, col="darkgreen")
#text(bbox[2,1], bbox[2,2], "Wilks", cex=cex, pos=1, offset=c(1, 2), col="darkgreen")

mid <- (b1+b2)/2
text(mid[1], mid[2], "c", cex=cex, pos=3)

text(.75*ppt[1], .75*ppt[2], "d", cex=cex, pos=4)

text(3, -.6, "(H+E)*", cex=cex, col="blue")
text(-.85, -.85, "E*", cex=cex, col="red")

# draw right-angle
d <- .08
p1 <- (1-d)*ppt
p3 <- ppt - d*(ppt-b2)*len(ppt,origin)
p2 <- p1 - d*(ppt-b2)*len(ppt,origin)
lines(rbind(p1,p2,p3))

par(opar)
dev.off()


 
