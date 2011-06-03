# demonstrate between, within & marginal regressions

library(MASS)	# mvrnorm
library(car)  # needs car 2.0-11
if (packageVersion("car") < "2.0-11") { warning("car 2.0-11 is required" }
# need to override car::dataEllipse
#source("c:/R/functions/car-ellipse.R")

###########################################
# set up: Sigma, means
#
# NB: Each block is run twice, using alternative Sigma s

Sigma <- matrix(c(6,3,3,2),2,2)    # positive within-group relation
#Sigma <- matrix(c(6,-3,-3,2),2,2)  # negative within-group relation
s <- diag(1/sqrt(diag(Sigma)))
(R <- s %*% Sigma %*% s)

set.seed(12345)  # reproducability

# number of groups, and group means
x <- jitter(seq(2,10,by=2))
#y <- x + rnorm(length(x), 0, .5)
y <- x + rnorm(10, 0, .5)
means <- cbind(x,y)

#v <- lapply(1:nrow(means), function(j) mvrnorm(n, means[j, ], Sigma, empirical = TRUE))
#vals <- cbind(group = rep(1:nrow(means), each = n), do.call(rbind, v))


# simple function to show the slope of a line
show.beta <- function(model, x1, x2, label, col="black", ...) {
	abline(model, col=col, lwd=2)
	xs <- data.frame(x=c(x1, x2, x2))
	ys <- predict(model, xs)
	lines(cbind(xs,ys[c(1,1,2)]), col=col)
	text(x2, mean(ys[1:2]), label, col=col, ...)
}


cd("c:/sasuser/datavis/manova/ellipses/fig")
#eps(file="between-within1.eps", width=7, height=7)
png(file="between-within2.png", width=7, height=7, res=200, units="in")
#pdf(file="between-within2.pdf", width=7, height=7)

op <- par(mar=c(4, 4, 1, 1) + 0.1)
dataEllipse(means, xlim=c(-5,15), ylim=c(-5,15), levels = 0.68, add=FALSE, plot.points=FALSE, fill=TRUE, fill.alpha=0.1)
between <- lm(y~x, data=as.data.frame(means))
show.beta(between, -5, -3, expression(~beta[between]), col="red", cex=1.4, pos=4, offset=-.1)

values <- NULL
n<- 10
for (i in 1:length(x)) {
	val <- mvrnorm(n, means[i,], .5*Sigma, empirical=TRUE)
#	dataEllipse(val, levels=0.68, add=TRUE, col="black", plot.points=FALSE)
	ellipse(means[i,], Sigma, radius=1, col="black", center.cex=1.25, fill=TRUE, fill.alpha=0.1)
	values <- rbind(values, mvrnorm(n, means[i,], Sigma, empirical=TRUE))
#	values <- rbind(values, val)
}
group <- factor(rep(1:length(x), each=n))
#contrasts(group) <- contr.sum
contrasts(group) <- contr.treatment(n=length(x), base=3)

df <- data.frame(values, group)
within <- lm(y~x, data=df, subset=group==3)
show.beta(within, -5, -3, expression(~beta[within]), col="black", cex=1.4, pos=4, offset=-.1)

# show pooled-within covariance
ellipse(colMeans(means), Sigma, radius=1, lty=1, col="green", center.cex=0.5, fill=TRUE, fill.alpha=0.3)
 
dataEllipse(values, levels=0.68, col="blue", plot.points=FALSE)
marginal <- lm(y~x, data=as.data.frame(values))
show.beta(marginal, -5, -3, expression(~beta[marginal]), col="blue", cex=1.4, pos=4, offset=-.1)

par(op)

dev.off()

### multivariate model & heplot

library(heplots)
png(file="between-HE1.png", width=7, height=7, res=200, units="in")
#pdf(file="between-HE1.pdf", width=7, height=7)

mod <- lm(cbind(x,y) ~ group, data=df)

op <- par(mar=c(4, 4, 1, 1) + 0.1)
heplot(mod, size="effect", term.labels="between", err.label="within", col=c("green3", "red"), 
fill=TRUE, alpha=0.3, lty=1, cex=1.5, xlim=c(-2,12), ylim=c(-2,12))
abline(marginal, col="blue", lwd=2)
show.beta(marginal, -2, 0, expression(~beta[marginal]), col="blue", cex=1.4, pos=4, offset=-.1)

contrasts(group) <- contr.sum
within <- lm(y~x+group, data=df)
abline(coef(within)[1:2]-c(1.5,0), col="green3", lwd=2, lty=2)

between <- lm(y~x, data=as.data.frame(means[1:5,]))
abline(between, col="red", lwd=2, lty=2)
par(op)

dev.off()

