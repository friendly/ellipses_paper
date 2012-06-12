# demo of points of osculation
# (allowing the radii of one set of ellipses to match the standard)

library(car)

m1 <- c(-2, 2)
A1 <- matrix(c(1, .5, .5, 1.5), 2, 2)
m2 <- c(2, 6)
A2 <- matrix(c(1.5, -.3, -.3, 1), 2, 2)

# make sure these are PD
#chol(A1)
#chol(A2)

cd("c:/sasuser/datavis/manova/ellipses/fig")
#eps(file="kiss-demo.eps", width=7, height=7)
png(file="kiss-demo.png", width=7, height=7, res=200, units="in")
#pdf(file="kiss-demo.pdf", width=7, height=7)

op <- par(mar=c(3, 3, 1, 1) + 0.1)

ellipse(m1, A1, radius=1, add=FALSE, xlim=c(-6, 6), ylim=c(-2, 10), asp=1, fill=TRUE)
ellipse(m1, A1, radius=2, col="red", fill=TRUE, fill.alpha=0.2)
ellipse(m1, A1, radius=3, col="red", fill=TRUE, fill.alpha=0.1)

# adjust the sizes of A2 ellipses so two will just kiss
ellipse(m2, A2, radius=1, col="blue", fill=TRUE)
ellipse(m2, A2, radius=1.74, col="blue", fill=TRUE, fill.alpha=0.2)
ellipse(m2, A2, radius=3.1, col="blue", fill=TRUE, fill.alpha=0.1)

text(m1[1], m1[2], labels=expression(m[1]), pos=1, cex=1.6)
text(m2[1], m2[2], labels=expression(m[2]), pos=3, cex=1.6)
text(-4.1, 4, labels=expression(A[1]), cex=1.75)
text(4.4, 8.4, labels=expression(A[2]), cex=1.75)

# find points of osculation manually
#osc <- locator(2)
osc <- 
structure(list(x = c(-0.548877453435949, 0.410182613051596), 
    y = c(4.26411038754042, 5.20841568377431)), .Names = c("x", "y"))

points(osc$x, osc$y, pch=15, cex=1.5)
    
# locus of osculation
XY <- rbind(m1, as.data.frame(osc), m2)
lines(spline(XY), lwd=3)
par(op)

dev.off()



