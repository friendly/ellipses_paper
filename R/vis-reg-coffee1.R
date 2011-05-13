# demo of data ellipse vs. beta ellipse

setwd("c:/R/georges")

     require( spida )
     require( p3d )

NB: using car2

###########
# fig 1
###########
# need to modify margin for tighter bounding boxes
opar <- par(mar=c(4,3,3,1)+0.1)


scatterplotMatrix(~Heart+Coffee+Stress, coffee, smooth=FALSE, ellipse=TRUE, levels=0.68, pch=19, col=rep("blue", 2), lwd=2)
dev.copy2eps(file="vis-reg-coffee11.eps")

fit.mult <- lm(( Heart ~ Coffee + Stress, coffee)
fit.simple <- lm( Heart ~ Coffee, coffee)
fit.stress <- lm( Stress ~ Coffee, coffee)

# data ellipse vs confidence ellipse

###########
# fig 2a
###########
par(mar=c(4,4,3,1)+0.1)


with(coffee, dataEllipse(Coffee, Stress, level=0.40, col="blue", main="Data space"))
abline(fit.stress)
dev.copy2eps(file="vis-reg-coffee12a.eps")


     # Confidence intervals, beta space
###########
# fig 2b     
###########
par(mar=c(4,4,3,1)+0.1)

plot( 0, 0, xlim = c( -2,2), ylim = c(-2,2)+1, type = 'n',
        xlab = list(~beta["Coffee"], cex = 1.5),
        ylab = list(~beta["Stress"], cex = 1.5),
        main= "Beta space")

abline( h = 0, lty="dashed")
abline( v = 0, lty="dashed" )

summary( fit.mult )
beta <- coef( fit.mult )[-1]
confint( fit.mult )  # confidence intervals

points( rbind(beta) , col = 'black', pch = 16, cex=1.5)

lines( y = c(0,0), x = confint(fit.mult)["Coffee",] , lwd = 5, col = 'red')
lines( x = c(0,0), y = confint(fit.mult)["Stress",] , lwd = 5, col = 'red')
points( diag( beta ), col = 'black', pch = 16, cex=1.3)

arrows(beta[1], beta[2], beta[1], 0, angle=15, len=0.2)
arrows(beta[1], beta[2], 0, beta[2], angle=15, len=0.2)

     # where do they come from? estimating two slopes simultaneously

lines( ce <-cell( fit.mult, dfn = 1 ), col = 'red' , lwd = 2)  # confidence ellipse
lines( cell( fit.mult, dfn = 2), col = 'green3' , lwd = 2)

text( -1.2, 1.9, "Joint 95% CE (d=2)", col = 'green4', adj = 0)
#text( -0.9, 1.7, "95% CI shadow ellipse (d=1)", col = 'red', adj = 0)
text( 0.2, .78, "95% CI shadow ellipse (d=1)", col = 'red', adj = 0)

cep <- attr(ce, 'parms')

# ell.conj generates lines for conjugate axes of an ellipse
#ell.conj(cep$center, cep$shape))


ax.down <- do.call( ell.conj, c( cep, list( dir = c(0,1), len=.5)))
abline2( ax.down$tan3, col = 'red', lty="dotted")
abline2( ax.down$tan4, col = 'red', lty="dotted")

dev.copy2eps(file="vis-reg-coffee12b.eps")


# What about marginal (simple regression) model

############
# fig3
############

     
library(MASS)
eqscplot( 0, 0, xlim = c( -2,2), ylim = c(-2,2)+1, type = 'n',
        xlab = list(~beta["Coffee"], cex = 1.5),
        ylab = list(~beta["Stress"], cex = 1.5),
        main= "Beta space")

abline( h = 0, lty="dashed")
abline( v = 0, lty="dashed" )

summary( fit.mult )
beta <- coef( fit.mult )[-1]
confint( fit.mult )  # confidence intervals

points( rbind(beta) , col = 'black', pch = 16, cex=1.5)

lines( y = c(0,0), x = confint(fit.mult)["Coffee",] , lwd = 5, col = 'red')
lines( x = c(0,0), y = confint(fit.mult)["Stress",] , lwd = 5, col = 'red')
points( diag( beta ), col = 'black', pch = 16, cex=1.3)


     # where do they come from? estimating two slopes simultaneously

lines( ce <-cell( fit.mult, dfn = 1 ), col = 'red' , lwd = 2)  # confidence ellipse
lines( cell( fit.mult, dfn = 2), col = 'green3' , lwd = 2)

#text( -1.2, 1.9, "Joint 95% CE (d=2)", col = 'green4', adj = 0)
#text( -0.9, 1.7, "95% CI shadow ellipse (d=1)", col = 'red', adj = 0)
text( 0.2, .78, "95% CI shadow ellipse (d=1)", col = 'red', adj = 0)

cep <- attr(ce, 'parms')


ax.down <- do.call( ell.conj, c( cep, list( dir = c(0,1), len=.5)))
abline2( ax.down$tan3, col = 'red', lty="dotted")
abline2( ax.down$tan4, col = 'red', lty="dotted")


lines ( y = c(0,0), x = confint( fit.simple )["Coffee",], lwd = 5, col = 'blue')
points( y =0, x = coef( fit.simple)[2], col = 'black', pch = 16, cex=1.3)
ax.oblique <- do.call( ell.conj, c( cep, list( dir = c(1,0))))
abline2( ax.oblique$v, col = 'blue')
#abline2( ax.oblique$tan4, col = 'blue')
abline2( ax.oblique$tan1, col = 'blue', lty=2)
abline2( ax.oblique$tan2, col = 'blue', lty=2)

text(1.2, .20, "95% marginal CI", col="blue", adj=c(0,.5))

# note relationship between data ellipse for coffee and stress and
# confidence intervals for coffee and stress

#visual test of b1=b2  ???

col <- "darkcyan"
x <- c(-1.5, .5)
lines(x=x, y=-x)
text(-1.8,1.6, expression(~beta["Stress"] - ~beta["Coffee"]), col=col)

# wald test
wf <-wald(fit.mult, c(0, -1, 1))[[1]]
str(wf)

lower <- wf$estimate$Lower /2
upper <- wf$estimate$Upper / 2
lines(-c(lower, upper), c(lower,upper), lwd=4, col=col)

bdiff <- beta %*% c(1, -1)/2
points(bdiff, -bdiff, pch=16, cex=1.3)
arrows(beta[1], beta[2], bdiff, -bdiff, angle=15, len=0.2, col=col)

dev.copy2eps(file="vis-reg-coffee13.eps")

