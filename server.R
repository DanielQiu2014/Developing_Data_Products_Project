
library("shiny")

## Calculate payment
pay <- function(principal, interest, duration) {
	
	r <- interest / 100 
	
	payment <- principal * r / ( 1 - ( 1 + r)^(-duration) ) / 12
	res <- list(r=r, payment=payment, principal=principal)
	return(res)
}

## Amortization table , payfreq, firstpay, compoundfreq
amort <- function(principal, interest, duration) {
  pay <- pay(principal, interest, duration)
  data <- data.frame(month = seq(0, duration * 12))
	data$payment <- 0
	data$payment[ (data$month - 1) >= 0 ] <- pay$payment         # & (data$month - 1) %% 1 == 0 
	data$totalPaid <- cumsum(data$payment)
	
	data$balance <- NA
	data$balance <- data$payment * (duration * 12) - data$totalPaid
  	
	return(data)
}


## Main shiny function
shinyServer(function(input, output) {
	
	## Display payment
	output$payment  <- renderPrint({
		payment <- pay(input$principal, input$interest, input$duration)$payment
		cat("Your monthly payment will be $")		
		cat(round(payment, 2))
		cat(".\nAt the end of the loan you will have paid a total of $")
		total <- payment * (input$duration * 12)
		cat(round(total, 2))
		cat(".\nThat is, a total of $")
		cat(round(total - input$principal, 2))
		cat(" in interests.")
	})
	
  # get amortization data as reactive expression
  data <- reactive({  
      data <- amort(input$principal, input$interest, input$duration)
  })
  
  # Display amortization table
  output$amort <- renderDataTable({
		data()[-1, ]
	}, options = list(iDisplayLength = 10))
	
  # Plot amortization data
  output$plot <- renderPlot({
    plot(data()$month, data()$totalPaid, type = "n", 
         main = "Total paid and remaining balance", 
          xlab = "Month", ylab = "Amount $", xaxp = c(0, max(data()$month), max(data()$month)/12), yaxp = c(0, round(max(data()$totalPaid), digits = 2), 5))
    legend("top", legend = c("Total paid", "Remaining balance"), col = c(6, 3), lwd=1)
    abline(coef(line(data()$month, data()$totalPaid)), col = "blue")
    abline(coef(line(data()$month, data()$balance)), col = "red")
  })    
	
})
