library(mvmeta)
library(car)

berkey98
### MULTIVARIATE META-ANALYSIS

# Fixed effects model
model0 <- mvmeta(cbind(PD,AL),S=berkey98[6:8],data=berkey98,lab=list(mlab=trial), method="fixed")

# Random effects model (using REML)
model <- mvmeta(cbind(PD,AL),S=berkey98[6:8],data=berkey98,lab=list(mlab=trial))
summary(model)
# AIC VALUE
AIC(model)
Cochran Q test for heterogeneity
qtest(model)
# BLUP ESTIMATES AND 90% PREDICTION INTERVALS, AGGREGATED BY OUTCOME
blup(model,pi=TRUE,aggregate="y",pi.level=0.90)

# extract beta_i and Sigma_i for one study from data frame in form of berkey98
musigma <- function(x, var=c("PD", "AL")) {
	mu <- x[var]
	var <-x[paste("var", c("PD", "AL"), sep="_")]
	cov <-x[paste("cov", "PD", "AL", sep="_")]
	sigma <- matrix(as.numeric(c(var[1], cov, cov, var[2])), 2,2)
	list(mu=as.numeric(mu), sigma=sigma)
	}

# extract all betas and Sigmas
indiv <- apply(berkey98, 1, musigma)
names(indiv) <- berkey98[,"trial"]
str(indiv)

beta0 <- model0$beta
vcov0 <- model0$vcov
#Psi <- model0$Psi

setwd("c:/sasuser/datavis/manova/ellipses/fig")
png(file="mvmeta2a.png", width=7, height=7, res=200, units="in")
#eps(file="mvmeta2a.eps")

op <- par(mar=c(4,4,0.5,0.5)+0.2)
with(berkey98, {
	plot(PD, AL, xlim=c(.1, .7), ylim=c(-.7,.1),
#		main = "Multivariate meta analysis, Berkey (1998)",
		xlab="Probing Depth Effect [surgical - non-surgical]",
		ylab="Attachment Level Effect [surgical - non-surgical]", cex.lab=1.25, asp=1)
#	text(PD, AL, trial, pos=3, cex=1.15)
	})

# between study covariance
#ellipse(beta0, Psi, 1, col="green", lty=1)
# meta analysis estimate
ellipse(beta0, vcov0, 1, col="blue", lwd=3)
# individual studies
null <- lapply(indiv, function(x) ellipse(x[[1]], x[[2]],  1, lty=2))
with(berkey98, {
	text(PD, AL, trial, pos=3, cex=1.15)
	})

text(.325, -.36, "Pooled (FE)", col="blue", cex=1.2)
#text(.481, -.15, "Between", col="green3", cex=1.2)
text(0, 0.05, "Fixed effects", cex=1.5, pos=4)
par(op)
dev.off()

beta <- model$beta
vcov <- model$vcov
Psi <- model$Psi

png(file="mvmeta2b.png", width=7, height=7, res=200, units="in")
#eps(file="mvmeta2b.eps")
op <- par(mar=c(4,4,0.5,0.5)+0.2)
with(berkey98, {
	plot(PD, AL, xlim=c(.1, .7), ylim=c(-.7,.1),
#		main = "Multivariate meta analysis, Berkey (1998)",
		xlab="Probing Depth Effect [surgical - non-surgical]",
		ylab="Attachment Level Effect [surgical - non-surgical]", cex.lab=1.25, asp=1)
#	text(PD, AL, trial, pos=3, cex=1.15)
	})

# between study covariance
ellipse(beta, Psi, 1, col="green4", lty=1)
# meta analysis estimate
ellipse(beta, vcov, 1, col="blue", lwd=3)
ellipse(beta0, vcov0, 1, col="blue", lty=2, center.cex=1)
arrows(beta0[1],beta0[2],beta[1],beta[2], angle=10, length=0.125, lwd=2, col="black")
# individual studies
null <- lapply(indiv, function(x) ellipse(x[[1]], x[[2]],  1, lty=2, center.cex=1))
with(berkey98, {
	text(PD, AL, trial, pos=3, cex=1.15)
	})

# show blup estimates
blups <- as.data.frame(blup(model))

# compute blup with associated (co)var matrix
blups1 <- blup(model,vcov=TRUE)
# blup
null <- lapply(blups1, function(x) ellipse(x[[1]], x[[2]],  1, col="red"))
arrows(berkey98$PD, berkey98$AL, blups$PD, blups$AL, angle=10, length=0.125, lwd=2)
text(.3775, -.235, "Pooled (RE)", col="blue", cex=1.2)
#text(.481, -.15, "Between", col="green4", cex=1.2)
text(.49, -.15, expression("Between(" * Delta * ")"), col="green4", cex=1.2)
text(0, 0.05, "Random effects and BLUPS", cex=1.5, pos=4)
par(op)
dev.off()

