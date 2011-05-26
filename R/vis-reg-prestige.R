library(spida)
library(p3d)
library(MASS)


show.slope <- function(x, y, b, scale=1, label="b", unit=TRUE,  ...) {
	opar <- par(xpd=TRUE)
	if (b>0) {
		segments(x,	y, x+scale, y, ...)
		segments(x+scale, y, x+scale, y+b*scale, ...)
		if (unit) text(x+scale/2, y, "1", adj=c(0.5, 1), ...)
		text(x+scale+strwidth("A")/2, y+b*scale/2, label=label, adj=c(0, 0.5), ...)
	}
	else {
		segments(x,	y, x-scale, y, ...)
		segments(x-scale, y, x-scale, y-b*scale)
		if (unit) text(x-scale/2, y, "1", adj=c(0.5, 1))
		text(x-scale, y-b*scale/2, label=label, adj=c(1, 0.5), ...)
	}
	par(opar)
}

data(Prestige)
attach(Prestige)

fit.simple <- lm( prestige ~ education, Prestige)
center <- colMeans(cbind(education, prestige))
sigma <- summary(fit.simple)$sigma
int <- coef(fit.simple)[1]
slope <- coef(fit.simple)[2]
sx <- sd(education)
mx <- center[1]
my <- center[2]
n <- length(education)

################################################################
setwd("c:/sasuser/datavis/manova/ellipses/fig")

ssize=1.25  # cex for slope annotations
lsize=1.75  # cex for panel labels
opar <- par(mar=c(4,4,1,1)+0.1)

dataEllipse(education, prestige, level=0.40, col="blue", main="", cex=0.0, grid=FALSE,
	xlab="Education", ylab="Prestige", cex.lab=1.25)
abline(fit.simple, col="blue", lwd=2)

lines(bbox <- dellplus(education, prestige, box=TRUE))
lines(dellplus(education, prestige, diameter=TRUE, radius=2), col="gray")

# diagonal lines are bbox[c(1,3),] and bbox[c(2,4),]
abline2(bbox[1,], bbox[3,], col="red", lwd=2)
abline2(bbox[2,], bbox[4,], col="red", lwd=2)

# slopes, b +- se / sx
show.slope(x=14, y=int+14*slope, b=slope, cex=ssize)
bup <- slope + sigma / sx
int.up <- my - bup * mx
show.slope(x=14, y=75.343, b=bup, label=~b+frac(s[e],s[x]), unit=FALSE, cex=ssize)

blo <- slope - sigma / sx
show.slope(x=14, y=53.67304, b=blo, label=~b-frac(s[e],s[x]), unit=FALSE, cex=ssize)

lines(bse<-brace(x1=mx, y1=my, x2=mx, y2=my+sigma, right=FALSE, rad=0.15))
text(min(bse[,1]), my+sigma/2, label=~s[e], cex=ssize, adj=c(1,.5))

lines(bsx <- brace(x1=mx, y1=my-sigma, x2=bbox[1,1], y2=my-sigma, rad=0.15))
text(mx+sx/2, min(bsx[,2]), label=~s[x], adj=c(0.5, 1), cex=ssize)

text(7, 80, label=~b %+-% group("(", frac(s[e], s[x]),")"), cex=lsize, adj=c(0, 0.5))

dev.copy2eps(file="vis-reg-prestige1.eps")

################################################################

dataEllipse(education, prestige, level=0.40, col="blue", main="", cex=0.0, grid=FALSE,
	xlab="Education", ylab="Prestige", cex.lab=1.25)
abline(fit.simple, col="blue", lwd=2)

lines(bbox <- dellplus(education, prestige, box=TRUE))

bup <- slope + (2/sqrt(n))*sigma / sx
int.up <- my - bup * mx
abline(int.up, bup, col="red", lwd=2)

blo <- slope - (2/sqrt(n))*sigma / sx
int.lo <- my - blo * mx
abline(int.lo, blo, col="red", lwd=2)

text(7, 80, label=~b %+-% frac(2, sqrt(n)) * group("(", frac(s[e], s[x]),")"), cex=lsize, adj=c(0, 0.5))
abline(h= mean(prestige), col="darkgray")
dev.copy2eps(file="vis-reg-prestige2.eps")

par(opar)

detach(Prestige)

