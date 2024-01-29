SUBROUTINE ISHOLIDAY(yDate, yIsHoliday)

* call routine to check inputted date is holiday or not

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.HOLIDAY
    * add more if you need

main:
    GOSUB init
    GOSUB process

    RETURN

init:
    yIsHoliday = "FALSE"
    IF ISDIGIT(yDate) ELSE 
        yIsHoliday = "date must be numeric format"
        RETURN
    END

    IF LEN(yDate) NE 8 THEN
        yIsHoliday = "format date must be YYYYMMDD"
        RETURN
    END

    ffHoliday = "F.HOLIDAY"; fvHoliday = ""
    CALL OPF(ffHoliday, fvHoliday)

    yYear   = yDate[1,4]
    yMonth  = yDate[5,2]
    yDay    = yDate[7,2]

    yHolidayIDPrefix = "ID00"

    RETURN

process:
    yHolidayID = yHolidayIDPrefix : yYear
    CALL F.READ(ffHoliday, yHolidayID, rHoliday, fvHoliday, "")
    IF NOT(rHoliday) THEN
        yIsHoliday = "record not found on table " : fvHoliday : " for year " : yYear
        RETURN
    END

    yMounthField = "PREFIX.MTH." : yMonth : ".TABLE" ; * please replace PREFIX with the actual PREFIX
    yListDateHolidayThisMounth = rHoliday<yMounthField>

    ySelectedDate = yListDateHolidayThisMounth[yDay, 1]

    IF ySelectedDate EQ "H" THEN
        yIsHoliday = "TRUE"
    END

    RETURN
END