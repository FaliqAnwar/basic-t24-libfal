SUBROUTINE GET.LAST.DUE.DATE(yArr, yDueDate)

* call routine to get last due date based on inputted account

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AA.ACCOUNT.DETAILS
    * add more if you need

main:
    GOSUB init
    GOSUB process

    RETURN

init:
    ffAaAccountDetails= "F.AA.ACCOUNT.DETAILS" ; fvAaAccountDetails + ""
    CALL OPF(ffAaAccountDetails, fvAaAccountDetails)

    yDueDate = "0"

    RETURN

process:
    CALL F.READ(ffAaAccountDetails, yArr, rAaAccountDetails, fvAaAccountDetails, "")
    IF NOT(rAaAccountDetails) THEN RETURN

    yBillPayDates       = rAaAccountDetails<PREFIX.BILL.PAY.DATE> ; * please replace PREFIX with the actual PREFIX
    yBillPayDatesCount  = DCOUNT(yBillPayDates, @VM)

    FOR I = 1 TO yBillPayDatesCount
        yBillPayDate = yBillPayDates<1, I>
        IF yBillPayDate LE TODAY THEN
            yBillIds        = rAaAccountDetails<PREFIX.BILL.ID> ; * please replace PREFIX with the actual PREFIX
            yBillIdsCount   = DCOUNT(yBillIds, @SM)
            yFlag           = @FALSE
            FOR J = 1 TO yBillIdsCount
                yPayMethod  = rAaAccountDetails<PREFIX.PAY.METHOD, I, J> ; * please replace PREFIX with the actual PREFIX
                yBillStatus = rAaAccountDetails<PREFIX.BILL.STATUS, I, J> ; * please replace PREFIX with the actual PREFIX
                IF yPayMethod EQ "DUE" AND yBillStatus NE "ADVANCED" THEN
                    yFlag = @TRUE
                    BREAK
                END
            NEXT J
        END

        IF yFlag AND yBillPayDate GT yDueDate THEN BREAK
    NEXT I

    yDueDate = yBillPayDate

    RETURN
END