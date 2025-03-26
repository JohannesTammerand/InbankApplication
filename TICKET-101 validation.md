# TICKET-101 Validation
Johannes Tammerand

## BACKEND
### Error handling
Error handling had one problem, mainly in the DecisionEngine.calculateApprovedLoan function. The function handled errors in two different ways for no explicit reason, one which threw the error and the other, which returned a Decision object with the error message. For simplicity's sake, I switched the Decision objects with a throw command.

### Tests
The DecisionEngineTest class was not annotated as a Test, which led to some problems with using DecisionEngineConstants' PostConstruct, which I used for initializing a map of countries and their life expectancies.

## Frontend
### Error handling
Did not find any problems.

### Tests
Frontend tests did not cover enough ground in testing the API. The tests were limited to whether an error occurs or not, not considering which error actually occurred and why it did (value too low/high).

## Requirements
The requirements set out by the contents of the ticket itself were properly met.