setwd("c:/sasuser/datavis/manova/ellipses/")
source("genridge.R")

longley.y <- longley[, "Employed"]
longley.X <- data.matrix(longley[, c(2:6,1)])

lambda <- c(0, 0.005, 0.01, 0.02, 0.04, 0.08)
lambdaf <- c("", ".005", ".01", ".02", ".04", ".08")
lridge <- ridge(longley.y, longley.X, lambda=lambda)


pdf(file="ridge2.pdf", width=6, height=6)
#eps(file="ridge2.eps", width=7, height=7)
op <- par(mfrow=c(2,2), mar=c(4, 4, 1, 1)+ 0.1)

for (i in 2:5) {
	plot.ridge(lridge, variables=c(1,i), radius=0.5, cex.lab=1.5)
	text(lridge$coef[1,1], lridge$coef[1,i], expression(~widehat(beta)^OLS), cex=1.5, pos=4, offset=.1)
	if (i==2) text(lridge$coef[-1,1:2], lambdaf[-1], pos=3, cex=1.25)
}
par(op)
dev.off()
