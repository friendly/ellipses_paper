library(candisc)


# iris data
iris.mod <- lm(cbind(Petal.Length, Sepal.Length, Petal.Width, Sepal.Width) ~ Species, data=iris)
iris.can <- candisc(iris.mod, data=iris)


setwd("c:/sasuser/datavis/manova/ellipses/fig")

colors <- c("red", "blue")

op <-par(xpd=TRUE)
#heplot(iris.can, size="effect", scale=7, col=colors, var.col="black",
#	prefix="Canonical Dimension")

heplot(iris.can, size="effect", scale=10, col=colors, var.col="black",
	prefix="Canonical Dimension", xlim=c(-12, 12), ylim=c(-10,5), yaxs="i",
	var.lwd=2, cex=1.2, var.cex=1.1)

dev.copy2eps(file="HE-can-iris.eps")
par(op)



# show contrasts -- need to refit for this parameterization

contrasts(iris$Species) <-matrix(c(0,-1,1, 2, -1, -1), 3,2)
contrasts(iris$Species)

iris.mod <- lm(cbind(Petal.Length, Sepal.Length, Petal.Width, Sepal.Width) ~ Species, data=iris)
iris.can <- candisc(iris.mod, data=iris)

hyp <- list("V:V"="Species1","S:VV"="Species2")

heplot(iris.can, size="effect", scale=6, col=colors, var.col="black", hypotheses=hyp)

