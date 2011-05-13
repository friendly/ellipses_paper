# demonstrate ellipses for the generalized eigenvalue problem

library(spida)
library(p3d)
library(MASS)

# http://wiki.math.yorku.ca/index.php/Statistics:_Ellipses

EH.fac <- function( 
           E,           #  non-neg. def. matrix to factor -- should be pos. def. if H is not missing
           H,           #  if not missing, factor of E will consist of axes conjugate relative to H also
           which = 1    #  which = 2 returns a factor of H
   )
   {            
       xx <- eigen(E,symmetric = T)
       Efac <- t(xx$vector) * sqrt( pmax( Re( xx$values ), 0 ))  # right factor of E  
       if ( missing(H) ) return(Efac)
       Efac.qr <- qr( t( Efac ) )
       H.star <- qr.coef( Efac.qr, t( qr.coef( Efac.qr, H))) # Efac^{-1} H Efac'^{-1}
       ev <- eigen( H.star, symmetric = T )
       ret <- t(ev$vectors) %*% Efac
       if ( which == 2 ) ret <- ret * ev$values        
       attr( ret, "lambda" ) <- ev$values
       ret
   }


rel.fac <- function( H, E ) {
         Bp <- fac(E)
         B.qr <- qr(t(Bp))
         H.star <-  qr.coef( B.qr, t( qr.coef( B.qr, H ) ))   # B^{-1} H B'^{-1}
         ev <- eigen( H.star , symmetric = T)
         ret <- t(ev$vectors) %*% Bp
         attr(ret,"lambda") <- ev$values
         ret 
}

H.star <- function( H, E ) {
         Bp <- fac(E)
         B.qr <- qr(t(Bp))
         H.star <-  qr.coef( B.qr, t( qr.coef( B.qr, H ) ))   # B^{-1} H B'^{-1}
         H.star 
}

# PCA factorization
pca.fac <- function(x) {
        xx <- svd(x)
        ret <- t(xx$v) * sqrt(pmax( xx$d,0))
        ret 
    }
label.ellipse <- function(ellipse, label, col, ...){
		if (cor(ellipse)[1,2] > 0){
			index <- which.max(ellipse[,2])
			x <- ellipse[index, 1] + 0.5 * strwidth(label)  # was: "A"
			y <- ellipse[index, 2] + 0.5 *strheight("A")
			adj <- c(1, 0) 
		}
		else {
			index <- which.min(ellipse[,2])
			x <- ellipse[index, 1] - 0.5 * strwidth(label)  # was: "A"
			y <- ellipse[index, 2] - 0.5 * strheight("A")
			adj <- c(0, 1) 
		}
		text(x, y, label, adj=adj, xpd=TRUE, col=col, ...)
	}

# function to draw conjugate axes
conjugate.axes <- function (B, col="black", lwd=2, pch=16, cex=2, lty=1) {
    b1 <- B[,1]
    b2 <- B[,2]
    arrows( 0,0, b1[1], b1[2], col=col, lwd=lwd, angle=6)
    points( rbind(b1), col = col, pch = pch, cex = cex)

    arrows( 0,0, b2[1], b2[2], col=col, lwd=lwd, angle=6)
    points( rbind(b2), col = col, pch = pch, cex = cex)
    lines( rbind( b1 + b2, b1 - b2, - b2 - b1, -b1 + b2, b1 + b2,
        NA, b1, -b1, NA, b2, -b2), col = col, lwd = 1.4, lty=lty)
}

### Example

setwd("c:/sasuser/datavis/manova/ellipses/fig")
H <- matrix(
	c(9, 3, 3, 4), 2, 2)

E <- matrix(c(2, -0.5, -0.5, 4), 2, 2)

E <- matrix(c(1, 0.5, 0.5, 2), 2, 2)

center <- c(0,0)

opar <- par(mar=c(4,4,3,1)+0.1)

eqscplot( x=0,y=0, xlim = c(-3,3), ylim = c(-3,3),
      xlab = '', ylab = '', type = 'n')
abline( v=0, col="gray")
abline( h=0, col="gray")

lines(ellH <- ell(center, H), col='blue', lwd=3)
lines(ellE <- ell(center, E), col='red', lwd=3)

#lines(ellplus(center, H, fac=pca.fac, box=TRUE, diameter=TRUE), col='blue', lwd=1, lty=2)
#lines(ellplus(center, E, fac=pca.fac, box=TRUE), col='red',  lwd=1, lty=2)
	# show eigenvectors of H, for reference
vec<-ellplus(center, H, fac=pca.fac, diameter=TRUE)[c(1,4),]
#vec[1,] <- -vec[1,]
#arrows(0,0,vec[,1],vec[,2], col="blue", lwd=2, angle=6, len=0.2)
text(-2.2, 2.6, "Data space", cex=1.5)
label.ellipse(ellH, "H", "blue", cex=1.5)
label.ellipse(ellE, "E", "red", cex=1.5)

#conjugate.axes(t(chol(E)), col="brown")
#conjugate.axes(rel.fac(H,E), col="brown")
conjugate.axes(EH.fac(E,H), col="red", lty=2, cex=0)
conjugate.axes(t(EH.fac(E,H,which=2)), col="blue", lty=2, cex=0)

dev.copy2eps(file="ellipse-geneig1.eps")


# transform to canonical space, 
Hstar <- H.star(H,E)

eqscplot( x=0,y=0, xlim = c(-3,3), ylim = c(-3,3),
      xlab = '', ylab = '', type = 'n')
abline( v=0, col="gray")
abline( h=0, col="gray")

lines(ellH <- ell(center, Hstar), col='blue', lwd=2)
lines(ellE <- ell(center, diag(2)), col='red', lwd=2)

lines(ellplus(center, Hstar, fac=pca.fac, box=TRUE, diameter=TRUE), col='blue', lwd=1, lty=2)
lines(ellplus(center, diag(2), fac=pca.fac, diameter=TRUE), col='red', lwd=1, lty=2)
	# show eigenvectors of Hstar, for reference
vec<-ellplus(center, Hstar, fac=pca.fac, diameter=TRUE)[c(1,4),]
arrows(0,0,vec[,1],vec[,2], col="blue", lwd=2, angle=6, len=0.2)
text(vec[1,1]/2, vec[1,2]/2, label=~lambda[1], adj=c(0,.5), cex=1.2)
text(vec[2,1]/2, vec[2,2]/2, label=~lambda[2], adj=c(.5,0), cex=1.2)

text(-2.2, 2.6, "Canonical space", cex=1.5)
label.ellipse(ellH, expression(paste("=", E^{-1/2} * H * E^{-1/2} )), "blue", cex=1.5)
label.ellipse(ellE, "E* =I", "red", cex=1.5)
# bit of a kludge, since I cant get H* to work in an expression
#text(0.5, 2.55, expression(paste("=", E^{-1/2} * H * E^{-1/2} )), col="blue", cex=1.5, , adj=c(0,.5))
#text(1.25, 3.0, expression(paste("=", E^{-1/2} * H * E^{-1/2} )), col="blue", cex=1.5, , adj=c(0,.5))

# show original coordinate axes in canonical space ???
#Can <- solve(pca.fac(E)) %*% eigen(Hstar)$vectors
#arrows(0,0, 4*Can[,1], 4*Can[,2], col="green", angle=6, len=0.2)

dev.copy2eps(file="ellipse-geneig2.eps")

#text(-1, -3, expression(H^{star} == E^{-1/2} * H * E^{-1/2} ))

par(opar)
