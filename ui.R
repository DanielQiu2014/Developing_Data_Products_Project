
library(shiny)

p(em("Documentation:",a("MortgageCalculator",href="index.html")))

## Specify layout pageWithSidebar
shinyUI(pageWithSidebar(
	
  titlePanel(h1("Simple Mortgage Calculator")),
	
	sidebarPanel(
		
		h4("Mortgage parameters"),
		
		## Loan amount
		numericInput("principal", "Amount borrowed", 100000, min=10000),
		helpText("The amount you will borrow. This is the loan's principal. Minimum $10,000."),
		
		## Interest rate
		numericInput("interest", "Yearly interest rate (in %)", 3.50, min=0.01, max=100, step=0.01),
		helpText("The yearly interest rate (in %) should be a number between 0.01 and 100."),
		
		## Loan duration
		numericInput("duration", "Loan duration (in years)", 15, min=1, max=100, step=1),
		helpText("The total duration of the loan in years should be a number between 1 and 100."),
    
    p(),
    p("================================"),
    p(strong("Documentation:",a("README",href="index.html")))
	),
		
	mainPanel(
  		tabsetPanel(
        tabPanel("Results",
          # Summary
				  h4("Summary"),
				  verbatimTextOutput("payment"),
        
          # Amortization table
          h4("Amortization table"),
  			  p("The following table shows how much you pay (and when), the total amount you have paid and the remaining balance due."),
				  dataTableOutput("amort")	
        ),
        
        tabPanel("Plot",
          h4("Amount paid and remaining balance"),
          plotOutput("plot")
        )
			)	
	)
	
))
