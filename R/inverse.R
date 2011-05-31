# ellipses and inverses
# demonstrate orthogonality of ellipses for A and A^{-1}

#source("c:/R/functions/car-ellipse.R")
m <- c(0,0)
A <- matrix(c(1, .5, .5, 1), 2, 2)
A2 <- 2*A
Ainv <- solve(A)
Ainv2 <- solve(A2)

## from heplot.R

label.ellipse <- function(ellipse, label, col, adj, ...){
	if (cor(ellipse)[1,2] >= 0){
		index <- which.max(ellipse[,2])
		x <- ellipse[index, 1] + 0.5 * strwidth(label)  # was: "A"
		y <- ellipse[index, 2] + 0.5 *strheight("A")
		if (missing(adj)) adj <- c(1, 0) 
	}
	else {
		index <- which.min(ellipse[,2])
		x <- ellipse[index, 1] - 0.5 * strwidth(label)  # was: "A"
		y <- ellipse[index, 2] - 0.5 * strheight("A")
		if (missing(adj)) adj <- c(0, 1) 
	}
	text(x, y, label, adj=adj, xpd=TRUE, col=col, ...)
}

#library(car)

cd("c:/sasuser/datavis/manova/ellipses/fig")
#pdf(file="inverse.pdf", width=7, height=7)
png(file="inverse.png", width=7, height=7, res=200, units="in")


op <- par(mar=c(3, 3, 1, 1) + 0.1)
E11 <- ellipse(m, A, radius=1, add=FALSE, asp=1, xlim=c(-2,2), ylim=c(-2,2), fill=TRUE)
E12 <- ellipse(m, A2, radius=1, fill=TRUE, fill.alpha=0.2)

r <- 1.4
lines(matrix(c(-r, r, -r, r), 2, 2), col="black")
lines(matrix(c(-r, r, r, -r), 2, 2), col="black")

E21 <- ellipse(m, Ainv, radius=1, col="blue")
E22 <- ellipse(m, Ainv2, radius=1, col="blue", fill=TRUE, fill.alpha=0.2)
#E23 <- ellipse(m, Ainv, radius=0.5, col="blue")


label.ellipse(E11, "C", "red", cex=1.3)
label.ellipse(E12, "2C", "red", cex=1.5)
label.ellipse(E21, expression(C^-1), "blue", cex=1.5, adj=c(-1,0.5))
label.ellipse(E22, expression((2 * C)^-1), "blue", cex=1.3, adj=c(-0.5,0.5))
par(op)

dev.off()

