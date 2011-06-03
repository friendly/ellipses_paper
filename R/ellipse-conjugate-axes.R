  ###
  ###  Demonstrate conjugate axes of ellipses
  ###
# from--  http://wiki.math.yorku.ca/index.php/Statistics:_Ellipses_Figures_1_and_2.R

setwd("c:/sasuser/datavis/manova/ellipses/fig")
library(MASS)
#library(spida)
if (!require("spida")) install.packages("spida", repos="http://R-Forge.R-project.org", type = "source"); library("spida")

#####################################################################
# Functions
#####################################################################

eps <- function(file="Rplot.eps", horizontal=FALSE, paper="special", height=6, width=6, ...) {
    postscript(file=file, onefile=FALSE, horizontal=horizontal, paper=paper, height=height, width=width,...)
  }

# Principal components factorization

pca.fac <- function(x) {
    xx <- svd(x)
    ret <- t(xx$v) * sqrt(pmax( xx$d,0))
    ret 
}

# Figure frame
figframe <- function(  xlim = c(-3,3), ylim = c(-3,3), xlab = '', ylab = '') {
    eqscplot( x=0,y=0, xlim = xlim, ylim = ylim, xlab = xlab, ylab = ylab, type = 'n')
    abline( v=0, col="gray")
    abline( h=0, col="gray")
}

# function to draw conjugate axes of an ellipse
conjugate.axes <- function (B, col, lwd=2, pch=16, cex=2, lty=1) {
    b1 <- B[,1]
    b2 <- B[,2]
    arrows( 0,0, b1[1], b1[2], col=col, lwd=lwd, angle=6)
    points( rbind(b1), col = col, pch = pch, cex = cex)

    arrows( 0,0, b2[1], b2[2], col=col, lwd=lwd, angle=6)
    points( rbind(b2), col = col, pch = pch, cex = cex)
    lines( rbind( b1 + b2, b1 - b2, - b2 - b1, -b1 + b2, b1 + b2,
        NA, b1, -b1, NA, b2, -b2), col = col, lwd = lwd, lty=lty)
}

#####################################################################
# Conjugate axes examples
#####################################################################
  
a1 <- c( 1,2)
a2 <- c( 1.5, 1)
A <- cbind( a1, a2)
W <- A %*% t(A)    
    
##  png(filename="conjugate1.png" ) 
#eps(file="conjugate1.eps")
#op <- par(mar=c(3, 3, 1, 1) + 0.4)
#figframe()
#      
#	col = 'red'
##    lines( rbind( 0, a1), col = col, lwd = 2)
#  arrows( 0,0, a1[1], a1[2], col=col, lwd=2, angle=6)
#  points( rbind(a1), col = 'red', pch = 16, cex = 1.5)
#  text( 1,2.3, label = ~a[1], adj = 1, cex = 2)
#  
##    lines( rbind( 0, a2), col = col, lwd = 2)
#  arrows( 0,0, a2[1], a2[2], col=col, lwd=2, angle=6)
#  points( rbind(a2), col = col, pch = 16, cex = 1.5)
#  text( 1.5,.8, label = ~a[2], adj = -.1, cex = 2)
#
#  lines( rbind( a1 + a2, a1 - a2, - a2 - a1, -a1 + a2, a1 + a2,
#      NA, a1, -a1, NA, a2, -a2), col = col, lwd = 2)
#
#  lines( ell(center=c(0,0), shape = W ), col = 'blue', lwd=3)
#par(op)
#  dev.off ()
#    
#   ### Figure with other factorizations  
#    
#  png(filename="conjugate2.png" ) 
#	eps(file="conjugate2.eps")
#  figframe()
#    
#    lines( ell(center=c(0,0), shape = W ), col = 'blue', lwd=3)
#    
#    # Choleski
#    
#    B <- t(chol(W))
#    b1 <- B[,1]
#    b2 <- B[,2]
#    
#		col = 'green3'
##    lines( rbind( 0, b1), col = col, lwd = 2)
#    arrows( 0,0, b1[1], b1[2], col=col, lwd=2, angle=6)
#    points( rbind(b1), col = col, pch = 16, cex = 1.5)
#    text( b1[1],b1[2], label = ~b[1], adj = 0, cex = 2)
#    
##    lines( rbind( 0, b2), col = col, lwd = 2)
#    arrows( 0,0, b2[1], b2[2], col=col, lwd=2, angle=6)
#    points( rbind(b2), col = col, pch = 16, cex = 1.5)
#    text( b2[1],b2[2], label = ~b[2], pos=3, cex = 2)
#
#    lines( rbind( b1 + b2, b1 - b2, - b2 - b1, -b1 + b2, b1 + b2,
#        NA, b1, -b1, NA, b2, -b2), col = col, lwd = 1.5)
#
#
#    B <- t(pca.fac(W))
#    b1 <- B[,1]
#    b2 <- B[,2]
#    
#		col = 'brown'
##    lines( rbind( 0, b1), col = col, lwd = 2)
#    arrows( 0,0, b1[1], b1[2], col=col, lwd=2, angle=6)
#    points( rbind(b1), col = col, pch = 16, cex = 2)
#    text( b1[1],b1[2], label = ~c[1], pos=2, cex = 2)
#    
##    lines( rbind( 0, b2), col = col, lwd = 2)
#    arrows( 0,0, b2[1], b2[2], col=col, lwd=2, angle=6)
#    points( rbind(b2), col = col, pch = 16, cex = 2)
#    text( b2[1],b2[2], label = ~c[2], pos=2, cex = 2)
#
#    lines( rbind( b1 + b2, b1 - b2, - b2 - b1, -b1 + b2, b1 + b2,
#        NA, b1, -b1, NA, b2, -b2), col = col, lwd = 1.5)
#   
#    dev.off()
    

#####################################################################
# simplified versions, using conjugate.axes
#####################################################################

eps(file="conjugate1.eps")
op <- par(mar=c(3, 3, 1, 1) + 0.4)
figframe()  
lines( ell(center=c(0,0), shape = W ), col = 'blue', lwd=3)
conjugate.axes(A, col='red')    
text( 1,2.3, label = ~a[1], adj = 1, cex = 2)
text( 1.5,.8, label = ~a[2], adj = -.1, cex = 2)
par(op)
dev.off()


eps(file="conjugate2.eps")
op <- par(mar=c(3, 3, 1, 1) + 0.4)

figframe()  
lines( ell(center=c(0,0), shape = W ), col = 'blue', lwd=3)
  
  # Choleski    
B <- t(chol(W))
b1 <- B[,1]
b2 <- B[,2]
conjugate.axes(B, col='darkgreen')    
text( b1[1],b1[2], label = ~b[1], pos=4, cex = 2)
text( b2[1],b2[2], label = ~b[2], pos=3, cex = 2)

	# PCA
C <- t(pca.fac(W))
c1 <- C[,1]
c2 <- C[,2]
conjugate.axes(C, col='brown', lty=2)    
text( c1[1],c1[2], label = ~c[1], pos=2, cex = 2)
text( c2[1],c2[2], label = ~c[2], pos=2, cex = 2)
par(op)
dev.off()
