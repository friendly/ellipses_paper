# demo of points of osculation
# (showing contours of the biquadratic form)

library(car)

m1 <- c(-2, 2)
A1 <- matrix(c(1, .5, .5, 1.5), 2, 2)
m2 <- c(2, 6)
A2 <- matrix(c(1.5, -.3, -.3, 1), 2, 2)

C <- matrix(c(0, -1, 1, 0), 2, 2)
ACA <- t(A2) %*% C %*% A1

# function for vector cross product of gradients of f(x1), f(x2)
cross <- function(x) { t(x-m2) %*% ACA %*% (x-m1) }

xvals <- seq(-6, 6, by=.5)
yvals <- seq(-2, 10, by=.5)
XY <- expand.grid( x=xvals, y=yvals)
Z <- apply(XY, 1, cross)

ZM <- t(matrix(Z, nrow=length(xvals), ncol=length(yvals)))

levs <- c(0, 5, 10, 20, 40, 60, 80, 100, 120)
levs <- c(-levs[-1], levs)

cd("c:/sasuser/datavis/manova/ellipses/fig")
#eps(file="kiss-demo2.eps", width=7, height=7)
#png(file="kiss-demo2.png", width=7, height=7, res=200, units="in")
pdf(file="kiss-demo2.pdf", width=7, height=7)

op <- par(mar=c(3, 3, 1, 1) + 0.1)
contour(xvals, yvals, ZM, xlim=c(-6, 6), ylim=c(-2, 10), asp=1,
#  vfont=c("sans serif", "bold"), 
  labcex=0.8,
	levels =levs)
contour(xvals, yvals, ZM, add=TRUE, levels =0, lwd=3, drawlabels=FALSE)

grid(lty=1)
ellipse(m1, A1, radius=1, col="red", fill=TRUE)
ellipse(m1, A1, radius=2, col="red", fill=TRUE, fill.alpha=0.2)
ellipse(m1, A1, radius=3, col="red", fill=TRUE, fill.alpha=0.1)

ellipse(m2, A2, radius=1, col="blue", fill=TRUE)
ellipse(m2, A2, radius=1.74, col="blue", fill=TRUE, fill.alpha=0.2)
ellipse(m2, A2, radius=3.1, col="blue", fill=TRUE, fill.alpha=0.1)
par(op)
dev.off()


