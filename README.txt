Projet blockchain : 

- 4 smart contracts : 
	- Customer { addCustomer(), updateCustomerInformations(), submitAClaim(), defineTwoTemplate : ThirdParty & AllRisks }
	- ClaimHandlingDep { checkIdentity(), checkInsuranceValidity(isValid?), receiveAClaim(), sendClaimForProcessing() }
	- ClaimHandlingProc { receiveAClaim(), checkValidity(), emitNotification(), sendClaimForGarage(), makePayment(), makeADecision(), estimateAmountForThirdPartyType() }
	- Garage { receiveRequest(), estimateCost(), sendReceipt() }

Emit event for notification.