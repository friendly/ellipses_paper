library(sfsmisc)
library(MASS)
source("ellipse.R")

#windows(height=5, width=5)
#par(mar=rep(2, 4))

eps(file="ellipse-demo.eps", height=6, width=6)

set.seed(1234)
data <- mvrnorm(100, c(10,20), matrix(c(4, 0.75*2*3, 0.75*2*3, 9), 2, 2), empirical=TRUE)
colnames(data) <- c("x", "y")

el.col = "blue"
se.col = "red"

eqscplot(data, type="n", axes=FALSE)
#eqscplot(data, type="n")
points(10, 20, pch=16, cex=1.5)
abline(h=11.5)
abline(v=0.5)

center <- colMeans(data)
shape <- var(data)
el <- ellipse(center, shape, 1, col=el.col, segments=500)
polygon(el, col=gray(.92), lwd=2)
lines(el, col=el.col, lwd=2)
points(data, col="gray", pch=16)
points(data, col="black")

sd <- sqrt(diag(shape))

abline(h=c(20, 23), lty=3)
abline(v=c(8, 10, 12), lty=3)
abline(h=20 + 2*0.75*2*3/4, lty=2, col=el.col)

abline(mod <- lm(y ~ x, as.data.frame(data)), lwd=2, col=el.col)

b <- coef(mod)
asize = 0.6  # arrow head size

p.arrows(14, b[1] + b[2]*14, 16, b[1] + b[2]*14, fill=1, size=asize)
p.arrows(16, b[1] + b[2]*14, 16, b[1] + b[2]*16, fill=1, size=asize)
text(16.25, mean(b[1] + b[2]*14, b[1] + b[2]*16), 
	expression(b == r*~over(s[y], s[x])), adj=c(0, 0), xpd=TRUE, col=el.col)
text(15, b[1] + b[2]*14 - 0.5, "1")

# annotations for standard error 
abline(h=20 + 3*sqrt(1 - .75^2), lty=2, col=se.col)

p.arrows(7, 20, 7, 20 + 3*sqrt(1 - .75^2), fill=se.col, size=asize, col=se.col)
p.arrows(7, 20 + 3*sqrt(1 - .75^2), 7, 20, fill=se.col, size=asize, col=se.col)
lines(c(10, 10), c(20 + 3*sqrt(1 - .75^2), 20 - 3*sqrt(1 - .75^2)), lwd=2, col=se.col)
text(6.25, 21, expression(s[e]), col=se.col)

loc <-2
p.arrows(loc, 20, loc, 23, fill=1, size=0.6)
p.arrows(loc, 23, loc, 20, fill=1, size=0.6)
text(loc-0.5, 21.5, expression(s[y]))

loc <- 13
p.arrows(10, loc, 12, loc, fill=1, size=asize)
p.arrows(12, loc, 10, loc, fill=1, size=asize)
text(11, loc-0.5, expression(s[x]))

p.arrows(14, 20, 14, 20 + 2*0.75*2*3/4, fill=el.col, size=asize, col=el.col)
p.arrows(14, 20 + 2*0.75*2*3/4, 14, 20, fill=el.col, size=asize, col=el.col)
text(14.75, 21, expression(r*~s[y]), col=el.col)

#text(10, 10.5, expression(bar(x)), xpd=TRUE)
#text(-0.5, 20, expression(bar(y)), xpd=TRUE)

mtext(expression(bar(x)), side=1, at=10, line=0)
mtext(expression(bar(y)), side=2, at=20, line=0.5, las=1)

mtext("x", side=1, at=18, line=0)
mtext("y", side=2, at=29, line=0.5, las=1)

dev.off()