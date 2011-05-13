library(heplots)

pca.fac <- function(x) {
   xx <- svd(x)
   ret <- t(xx$v) * sqrt(pmax( xx$d,0))
   ret  #ret [ nrow(ret):1,]
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

# new version of ellplus, allowing fac to be a 2x2 matrix
ellplus <- function ( center = rep(0,2), shape = diag(2), radius = 1, n = 100,
               angles = (0:n)*2*pi/n,
               fac = chol ,
               ellipse = all,
               diameters = all,
               box = all,
               all = FALSE) {
        help <- "
        ellplus can produce, in addition to the points of an ellipse, the
        conjugate axes corresponding to a chol or other decomposition
        and the surrounding parallelogram.
        "
        rbindna <- function(x,...) {
            if ( nargs() == 0) return(NULL)
            if ( nargs() == 1) return(x)
            rbind( x, NA, rbindna(...))
        }
        if( missing(ellipse) && missing(diameters) && missing(box)) all <- TRUE
        circle <- function( angle) cbind( cos(angle), sin(angle))
        Tr <- if (is.function(fac)) fac(shape) else fac
        ret <- list (
            t( c(center) + t( radius * circle( angles) %*% Tr)),
            t( c(center) + t( radius * circle( c(0,pi)) %*% Tr)),
            t( c(center) + t( radius * circle( c(pi/2,3*pi/2)) %*% Tr)),
            t( c(center) + t( radius * rbind( c(1,1), c(-1,1),c(-1,-1), c(1,-1),c(1,1)) %*% Tr)))
        do.call( 'rbindna', ret[c(ellipse, diameters, diameters, box)])
    }


setwd("c:/sasuser/datavis/manova/ellipses/fig")

## iris data
contrasts(iris$Species) <- C <-matrix(c(0,-1,1, 2, -1, -1), 3,2)
contrasts(iris$Species)

iris.mod <- lm(cbind(Sepal.Length, Sepal.Width, Petal.Length, Petal.Width) ~
Species, data=iris)

hyp <- list("V:V"="Species1","S:VV"="Species2")
col <- c("red", "blue", rep("steelblue2", 2))
var<- 2:1

opar <- par(mar=c(4,4,3,1)+0.1)

hep <-heplot(iris.mod, hypotheses=hyp, var=var, asp=1, col=col, cex=1.2)

dev.copy2eps(file="HE-contrasts-iris.eps")

par(opar)

##############################################

# extract H & E matrices
amod <- Anova(iris.mod)
#names(amod)
H <- amod$SSP$Species[var,var]
E <- amod$SSPE[var,var]

H1 <- linear.hypothesis(iris.mod, "Species1")$SSPH[var,var]
H2 <- linear.hypothesis(iris.mod, "Species2")$SSPH[var,var]

# relation of H1, H2 in the metric of E^-1

HEH1 <- H1 %*% solve(E) %*% H1
lines(ellplus(hep$center, HEH1, fac=pca.fac, radius=.7, box=TRUE, diameters=TRUE ))
HEH2 <- H2 %*% solve(E) %*% H2
lines(ellplus(hep$center, HEH2, fac=pca.fac, radius=.7, box=TRUE, diameters=TRUE ))


##############################################
# trying other things ....

rel.fac(H,E)
center <- colMeans(iris[,var])
lines(ellplus(center, H, fac=pca.fac, radius=.48, box=TRUE, diameters=TRUE ))

lines(ellplus(center, H, fac=rel.fac(H,E), radius=.48, box=TRUE, diameters=TRUE ))
#lines(ellplus(center, H, fac=H.star(H,E), radius=.48, box=TRUE, diameters=TRUE ))

#lines(ellplus(center, H, fac=H.star(H1,E), radius=.48, box=TRUE, diameters=TRUE ))
#lines(ellplus(center, H, fac=H.star(H2,E), radius=.48, box=TRUE, diameters=TRUE ))




