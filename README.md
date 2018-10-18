# lur: A package for land use regression modelling in R

Land use regression modelling is commonly applied for spatial modelling of air 
pollution concentrations. The principle is that given a set of air pollution 
observations, that their surrounding land use conditions can be used to explain
the variation in concentrations. The statistical model that defines this 
relationship is often a linear regression model, but other regression techniques
area common. 

The process can be broken into XXX major steps that include:

1. Collection of air pollution observations.
2. Identify surronding land use conditions within buffers of the air pollution
  observations.
3. Fit a statisitcal model to explain the variation in air pollution 
  observations based on the land use conditions. Tradionally this has been a
  linear regresion model.
4. Cross-validation including spatial and/or temporal blocking
5. Produce a an air pollution surface.
    